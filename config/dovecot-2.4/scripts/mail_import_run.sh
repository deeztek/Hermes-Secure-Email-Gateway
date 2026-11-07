#!/bin/bash
#
# Hermes SEG - Mail Import runner (GitHub #356)
#
# Runs inside hermes_dovecot. schedule/mail_import.cfm calls it through
# `docker exec -i`; nothing here is meant to be run by hand.
#
#   mail_import_run.sh start <token>   read a job from stdin, start it detached
#   mail_import_run.sh alive <token>   print "alive" or "gone"
#   mail_import_run.sh stop  <token>   kill a running import and clean up
#
# WHY IT DETACHES
#
# An import can take hours. `start` writes the job files, launches the worker
# in its own session and returns, so no HTTP request or docker exec stays open.
# The worker records its result in $STATE/<token>.status, which the scheduler
# reads through the dovecot_logs volume. While it runs, $STATE/<token>.progress
# holds the counts the console shows.
#
# THE SOURCE PASSWORD
#
# It arrives on stdin, never as an argument, and is written to a mode 600 file
# read by `imapc_password = <file`. That form needs no quoting, but Dovecot 2.4
# still expands %{...} in the value, so the caller doubles every % first.
# The job directory is removed when the worker exits, and by `alive` if the
# container restarted and killed the worker before it could clean up.
#
# WHY THE JOB FILE LOOKS THE WAY IT DOES
#
# - dovecot_config_version must be the first setting in any config file. An
#   !include on line 1 is refused, so the line is copied from the live config.
# - sieve_enabled = no: during a sync the doveadm-sieve plugin opens the user's
#   Sieve storage on INBOX. That fails here and aborts the sync with a generic
#   internal error and nothing in the log. An import has no business touching
#   Sieve scripts. This applies to this job file only, so delivery filters and
#   vacation replies are unaffected.
# - no-metadata: an import does not copy IMAP METADATA, so do not ask for it.
#
# WHY sync -1R AND NOT backup
#
# `doveadm backup` reverts changes in the destination, which would delete mail
# already delivered to the Hermes mailbox. `sync -1` keeps them. A repeat run
# copies only what is new.

set -u

BASE=/tmp/hermes_mail_import
STATE=/logs/mail_import
MAIN_CONF=/etc/dovecot/dovecot.conf

cmd="${1:-}"
token="${2:-}"

if [[ ! "$token" =~ ^[a-z0-9]{32}$ ]]; then
    echo "invalid token"
    exit 64
fi

dir="$BASE/$token"
pidfile="$STATE/$token.pid"
progressfile="$STATE/$token.progress"

# Refuse anything that is not exactly the expected shape. The console validates
# these too; this file is the last stop before a root doveadm command.
need() {
    if [[ ! "$2" =~ $3 ]]; then
        echo "invalid value for $1"
        rm -rf "$dir"
        exit 65
    fi
}

start_job() {
    local host="" port="" ssl="" verify="yes" target="" quota="0" features=""
    local prefix="" since_days="0" max_mb="0" timeout="600" line key val version

    umask 077
    mkdir -p "$BASE"
    mkdir -p "$STATE"
    chmod 755 "$STATE"
    mkdir "$dir" || exit 65
    : > "$dir/args"

    while IFS= read -r line || [[ -n "$line" ]]; do
        key="${line%%=*}"
        val="${line#*=}"
        case "$key" in
            HOST)       host="$val" ;;
            PORT)       port="$val" ;;
            SSL)        ssl="$val" ;;
            VERIFY)     verify="$val" ;;
            TARGET)     target="$val" ;;
            QUOTA)      quota="$val" ;;
            FEATURES)   features="$val" ;;
            PREFIX)     prefix="$val" ;;
            SINCE_DAYS) since_days="$val" ;;
            MAX_MB)     max_mb="$val" ;;
            TIMEOUT)    timeout="$val" ;;
            USER)       printf '%s' "$val" > "$dir/user" ;;
            PASS)       printf '%s' "$val" > "$dir/pw" ;;
            EXCLUDE)    printf -- '-x\n%s\n' "$val" >> "$dir/args" ;;
        esac
    done

    need HOST "$host" '^[A-Za-z0-9._-]+$'
    need PORT "$port" '^[0-9]{1,5}$'
    need SSL "$ssl" '^(imaps|starttls|no)$'
    need VERIFY "$verify" '^(yes|no)$'
    need TARGET "$target" '^[^[:space:]]+@[^[:space:]]+$'
    need QUOTA "$quota" '^[0-9]+$'
    need FEATURES "$features" '^[a-z -]*$'
    need PREFIX "$prefix" '^[A-Za-z0-9._/-]*$'
    need SINCE_DAYS "$since_days" '^[0-9]+$'
    need MAX_MB "$max_mb" '^[0-9]+$'
    need TIMEOUT "$timeout" '^[0-9]+$'

    if [[ ! -s "$dir/user" || ! -s "$dir/pw" ]]; then
        echo "missing credentials"
        rm -rf "$dir"
        exit 65
    fi

    version=$(grep -m1 '^dovecot_config_version' "$MAIN_CONF")
    if [[ -z "$version" ]]; then
        echo "no dovecot_config_version in $MAIN_CONF"
        rm -rf "$dir"
        exit 65
    fi

    {
        printf '%s\n' "$version"
        printf '!include %s\n' "$MAIN_CONF"
        printf 'imapc_host = %s\n' "$host"
        printf 'imapc_port = %s\n' "$port"
        printf 'imapc_ssl = %s\n' "$ssl"
        printf 'imapc_user = <%s\n' "$dir/user"
        printf 'imapc_password = <%s\n' "$dir/pw"
        printf 'imapc_features = no-metadata %s\n' "$features"
        printf 'sieve_enabled = no\n'
        if [[ -n "$prefix" ]]; then
            printf 'imapc_list_prefix = %s\n' "$prefix"
        fi
        if [[ "$verify" == "no" ]]; then
            printf 'ssl_client_require_valid_cert = no\n'
        fi
    } > "$dir/job.conf"

    printf -- '-T\n%s\n' "$timeout" >> "$dir/args"
    if [[ "$since_days" != "0" ]]; then
        printf -- '-t\n%s\n' "$(date -d "-$since_days days" +%s)" >> "$dir/args"
    fi
    if [[ "$max_mb" != "0" ]]; then
        printf -- '-I\n%sM\n' "$max_mb" >> "$dir/args"
    fi

    printf '%s' "$target" > "$dir/target"
    printf '%s' "$quota" > "$dir/quota"

    setsid nohup /bin/bash "$0" work "$token" > /dev/null 2>&1 < /dev/null &
    echo "started"
}

write_status() {
    local tmp="$STATE/$token.status.tmp"
    printf 'exit=%s\nbefore=%s\nafter=%s\nreason=%s\n' "$1" "$2" "$3" "$4" > "$tmp"
    chmod 644 "$tmp"
    mv "$tmp" "$STATE/$token.status"
}

count_messages() {
    doveadm mailbox status -u "$1" -t messages '*' 2>/dev/null | sed -n 's/.*messages=//p'
}

write_progress() {
    local tmp="$progressfile.tmp"
    printf 'before=%s\nnow=%s\nsource=%s\n' "$1" "$2" "$3" > "$tmp"
    chmod 644 "$tmp"
    mv "$tmp" "$progressfile"
}

# Runs beside the sync. The console reads the file, so a page load never has to
# reach into this container.
watch_progress() {
    while :; do
        write_progress "$2" "$(count_messages "$1")" "$3"
        sleep 60
    done
}

work_job() {
    local log="$STATE/$token.log" conf="$dir/job.conf"
    local target quota before after rc=1 attempt stats size source_total watcher reason=""
    local -a args

    trap 'rm -rf "$dir"; rm -f "$pidfile" "$progressfile"' EXIT
    echo $$ > "$pidfile"
    chmod 644 "$pidfile"
    : > "$log"
    chmod 644 "$log"

    mapfile -t args < "$dir/args"
    target=$(< "$dir/target")
    quota=$(< "$dir/quota")
    before=$(count_messages "$target")

    # Compare the whole source account with the mailbox limit, so a mailbox
    # that cannot hold the import fails before anything is copied. A repeat
    # run compares the same two numbers, so mail already imported is not
    # counted twice. The same listing gives the source total for the console.
    stats=$(doveadm -c "$conf" -o mail_driver=imapc -o mail_path= \
                mailbox status -u "$target" -t 'messages vsize' '*' 2>> "$log")
    source_total=$(sed -n 's/.*messages=\([0-9]*\).*/\1/p' <<< "$stats")
    size=$(sed -n 's/.*vsize=\([0-9]*\).*/\1/p' <<< "$stats")
    if [[ "$quota" != "0" && "$size" =~ ^[0-9]+$ ]] && (( size > quota )); then
        write_status 70 "$before" "$before" "source_too_large:$size"
        exit 0
    fi

    watch_progress "$target" "$before" "$source_total" &
    watcher=$!

    # Exit 2 means the mailbox changed during the sync and it should be run
    # again. "User lookup failed" is the auth-worker dropping an idle database
    # connection (#342). Neither is a real failure on the first attempt.
    for attempt in 1 2 3; do
        doveadm -c "$conf" sync -1R "${args[@]}" -u "$target" imapc: >> "$log" 2>&1
        rc=$?
        if [[ $rc -eq 2 ]] || { [[ $rc -ne 0 ]] && tail -n 5 "$log" | grep -q 'User lookup failed'; }; then
            sleep 15
            continue
        fi
        break
    done

    kill "$watcher" 2> /dev/null
    after=$(count_messages "$target")
    write_status "$rc" "$before" "$after" "$reason"
}

is_alive() {
    local pid
    if [[ -f "$pidfile" ]]; then
        pid=$(< "$pidfile")
        if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2> /dev/null; then
            return 0
        fi
    fi
    return 1
}

case "$cmd" in
    start)
        start_job
        ;;
    work)
        work_job
        ;;
    alive)
        if is_alive; then
            echo "alive"
        else
            rm -rf "$dir"
            rm -f "$pidfile" "$progressfile"
            echo "gone"
        fi
        ;;
    stop)
        if is_alive; then
            kill -TERM -- "-$(< "$pidfile")" 2> /dev/null
            sleep 2
        fi
        rm -rf "$dir"
        rm -f "$pidfile" "$progressfile"
        echo "stopped"
        ;;
    *)
        echo "usage: $0 start|alive|stop <token>"
        exit 64
        ;;
esac
