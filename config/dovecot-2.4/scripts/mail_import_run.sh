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
# still expands %{...} in the value, so the caller turns every "%{" into "%%{"
# (a literal "%{"). Any other % is taken literally and must not be doubled.
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
# WHY import AND NOT sync OR backup
#
# `doveadm backup` reverts changes in the destination, which would delete mail
# already delivered to the Hermes mailbox. `doveadm sync -1R` (used before
# v261107) treats each target folder as a replica of ONE source folder: it
# copies the source's UIDVALIDITY onto it. A second source account with a
# folder of the same name (INBOX, Sent, Trash...) then has a different
# UIDVALIDITY, dsync sees a conflict and copies nothing from it. Importing a
# second account into a mailbox lost almost all of its mail that way.
#
# `doveadm import` copies messages into same-named folders whatever is already
# there, but is not incremental by itself. So this runner keeps, per job and
# per source folder, the source UIDVALIDITY and the highest UID already
# imported ($STATE/state/<key>):
#
# - Folder with state and the same UIDVALIDITY: import only UIDs above the
#   recorded one. Mail deleted in Hermes is not brought back.
# - Folder without state (first run, a new folder, or the source reset its
#   UIDVALIDITY): import only the messages whose Message-ID is not already in
#   the target folder. That keeps a first run from duplicating mail that is
#   already there, including mail copied by the old sync-based runner.
#
# The upper UID is fixed when the folder is listed, so mail arriving during the
# import is picked up by the next run, not copied twice.

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
    local prefix="" since_days="0" max_mb="0" timeout="600" job="0" line key val version

    umask 077
    mkdir -p "$BASE"
    mkdir -p "$STATE"
    chmod 755 "$STATE"
    mkdir "$dir" || exit 65
    : > "$dir/excludes"

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
            JOB)        job="$val" ;;
            USER)       printf '%s' "$val" > "$dir/user" ;;
            PASS)       printf '%s' "$val" > "$dir/pw" ;;
            EXCLUDE)    printf '%s\n' "$val" >> "$dir/excludes" ;;
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
    need JOB "$job" '^[0-9]+$'

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

    # The source filters, as doveadm search terms added to every import.
    : > "$dir/filter"
    if [[ "$since_days" != "0" ]]; then
        printf 'SINCE\n%s\n' "$(date -d "-$since_days days" +%Y-%m-%d)" >> "$dir/filter"
    fi
    if [[ "$max_mb" != "0" ]]; then
        printf 'SMALLER\n%s\n' "$(( max_mb * 1048576 + 1 ))" >> "$dir/filter"
    fi
    printf '%s' "$timeout" > "$dir/timeout"

    # Incremental state is per job and per source: a new job, or a job edited
    # to point somewhere else, starts again from the Message-ID comparison.
    printf '%s-%s' "$job" "$(printf '%s|%s|%s|%s|%s' "$host" "$port" "$(< "$dir/user")" "$prefix" "$target" | sha256sum | cut -c1-16)" > "$dir/statekey"

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

# True when a source folder matches an Exclude Folders line. A line matches the
# folder itself and everything below it; "*" is the only wildcard.
is_excluded() {
    local name="$1" ex pat
    for ex in "${excludes[@]}"; do
        [[ -z "$ex" ]] && continue
        pat=$(printf '%s' "$ex" | sed 's/[][?\\]/\\&/g')
        # shellcheck disable=SC2053
        if [[ "$name" == $pat || "$name" == $pat/* ]]; then
            return 0
        fi
    done
    return 1
}

# Turn sorted UIDs on stdin into IMAP sets of at most 200 ranges, one per line,
# so no single doveadm argument gets too long.
uid_sets() {
    awk 'function flush() { if (s != "") { r = (s == e) ? s : s ":" e; set = (set == "") ? r : set "," r; n++ }
                            if (n >= 200) { print set; set = ""; n = 0 } }
         { u = $1 + 0; if (s != "" && u == e + 1) { e = u } else { flush(); s = u; e = u } }
         END { flush(); if (set != "") print set }'
}

# Message-IDs in a target folder, one per line (empty if it does not exist).
target_ids() {
    doveadm -f tab fetch -u "$1" 'hdr.message-id' mailbox "$2" 2> /dev/null \
        | tail -n +2 | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | grep -v '^$'
}

# Import one UID set from one source folder. "User lookup failed" is the
# auth-worker dropping an idle database connection (#342): retried, not fatal.
import_set() {
    local target="$1" conf="$2" log="$3" timeout="$4" name="$5" set="$6" attempt rc=1
    for attempt in 1 2 3; do
        doveadm -c "$conf" -o "imapc_cmd_timeout=${timeout}s" \
            import -u "$target" imapc: "" mailbox "$name" UID "$set" "${filter[@]}" >> "$log" 2>&1
        rc=$?
        if [[ $rc -ne 0 ]] && tail -n 5 "$log" | grep -q 'User lookup failed'; then
            sleep 15
            continue
        fi
        break
    done
    return $rc
}

import_all() {
    local target="$1" conf="$2" log="$3" statefile="$4" timeout="$5"
    local src="doveadm -c $conf -o mail_driver=imapc -o mail_path="
    local header line name uidv uidnext top prev_v prev_top set rc=0 frc
    local -a cols
    local -A col state_v state_top
    local newstate="$statefile.tmp"

    # Previous state: uidvalidity <TAB> last uid <TAB> folder
    if [[ -f "$statefile" ]]; then
        while IFS=$'\t' read -r uidv top name; do
            [[ -n "$name" ]] || continue
            state_v["$name"]="$uidv"
            state_top["$name"]="$top"
        done < "$statefile"
    fi

    # One listing of every source folder. Columns come back in doveadm's own
    # order, so they are looked up by the header.
    local listing
    listing=$($src -f tab mailbox status -u "$target" 'messages uidnext uidvalidity' '*' 2>> "$log")
    if [[ -z "$listing" ]]; then
        echo "Could not list the source folders." >> "$log"
        return 75
    fi
    header=$(head -n 1 <<< "$listing")
    IFS=$'\t' read -r -a cols <<< "$header"
    for i in "${!cols[@]}"; do col["${cols[$i]}"]=$i; done

    : > "$newstate"
    chmod 600 "$newstate"
    while IFS= read -r line; do
        IFS=$'\t' read -r -a f <<< "$line"
        name="${f[${col[mailbox]}]}"
        uidv="${f[${col[uidvalidity]}]}"
        uidnext="${f[${col[uidnext]}]}"
        [[ -n "$name" && "$uidv" =~ ^[0-9]+$ && "$uidnext" =~ ^[0-9]+$ ]] || continue
        is_excluded "$name" && continue
        top=$(( uidnext - 1 ))
        prev_v="${state_v[$name]:-}"
        prev_top="${state_top[$name]:-0}"
        frc=0

        if (( top < 1 )); then
            :
        elif [[ "$prev_v" == "$uidv" ]]; then
            # Incremental: only what arrived since the last run.
            if (( top > prev_top )); then
                import_set "$target" "$conf" "$log" "$timeout" "$name" "$(( prev_top + 1 )):$top" || frc=$?
            fi
        else
            # First run for this folder: everything whose Message-ID the target
            # folder does not already have. Messages with no Message-ID are
            # always taken.
            while IFS= read -r set; do
                [[ -n "$set" ]] || continue
                import_set "$target" "$conf" "$log" "$timeout" "$name" "$set" || { frc=$?; break; }
            done < <(
                $src -f tab fetch -u "$target" 'uid hdr.message-id' mailbox "$name" UID "1:$top" 2>> "$log" \
                    | tail -n +2 \
                    | awk -F'\t' 'function emit() { gsub(/^[ \t]+|[ \t]+$/, "", id)
                                                    if (uid != "" && (id == "" || !(id in have))) print uid }
                                  FILENAME == ARGV[1] { have[$0] = 1; next }
                                  # A folded header (common from Exchange) puts the
                                  # ID on its own line: it belongs to the message above.
                                  /^[0-9]+\t/ { emit(); uid = $1 + 0; id = substr($0, index($0, "\t") + 1)
                                                if (uid < 1) uid = ""; next }
                                  { id = id " " $0 }
                                  END { emit() }' \
                          <(target_ids "$target" "$name") - \
                    | sort -n | uid_sets
            )
        fi

        if [[ $frc -eq 0 ]]; then
            printf '%s\t%s\t%s\n' "$uidv" "$top" "$name" >> "$newstate"
        else
            rc=$frc
            # Keep the old state for this folder, so the next run retries it.
            if [[ -n "$prev_v" ]]; then
                printf '%s\t%s\t%s\n' "$prev_v" "$prev_top" "$name" >> "$newstate"
            fi
        fi
    done < <(tail -n +2 <<< "$listing")

    mv "$newstate" "$statefile"
    return $rc
}

work_job() {
    local log="$STATE/$token.log" conf="$dir/job.conf"
    local target quota before after rc=0 stats size source_total watcher reason=""
    local timeout statefile

    trap 'rm -rf "$dir"; rm -f "$pidfile" "$progressfile"' EXIT
    echo $$ > "$pidfile"
    chmod 644 "$pidfile"
    : > "$log"
    chmod 644 "$log"

    mapfile -t filter < "$dir/filter"
    mapfile -t excludes < "$dir/excludes"
    timeout=$(< "$dir/timeout")
    mkdir -p "$STATE/state"
    statefile="$STATE/state/$(< "$dir/statekey")"
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

    import_all "$target" "$conf" "$log" "$statefile" "$timeout"
    rc=$?

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
