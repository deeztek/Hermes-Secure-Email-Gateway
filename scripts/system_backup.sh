#!/usr/bin/env bash
# ============================================================================
# Hermes SEG Docker -- system backup
# ============================================================================
# Backs up Hermes's databases, LDAP directory, configs, and storage tiers
# WITHOUT downtime by default. Uses application-native hot-backup primitives
# (mariadb-dump --single-transaction, slapcat, atomic-rename mail formats).
#
# Scopes (-B):
#   system    -- Config + Data + 6 DB dumps + LDAP slapcat (nightly default)
#   archive   -- Archive tier only (Amavis quarantine)
#   vmail     -- Vmail tier only (Dovecot mailboxes)
#   nextcloud -- Nextcloud tier only (NC files; uses occ maintenance:mode)
#   all       -- Everything
#
# Modes:
#   HOT (default)  -- Zero application downtime. Used for daily backups.
#   COLD (--cold)  -- Full stack stop. Used for forensic / legal-hold
#                     backups where absolute byte-level consistency is
#                     required and the operator can afford downtime.
#
# Hot-backup safety per component:
#   MariaDB     -- mariadb-dump --single-transaction (InnoDB MVCC)
#   OpenLDAP    -- slapcat (live LDIF export; safe with no locks)
#   Dovecot     -- maildir/sdbox atomic-rename writes; safe for live tar
#   Amavis      -- quarantine atomic-rename writes; safe for live tar
#   Postfix     -- queue atomic-rename writes; safe for live tar
#   Nextcloud   -- occ maintenance:mode --on briefly (NC web UI only; mail
#                  flow unaffected); skip via --no-nc-maintenance
#   Logs        -- append-only; last few lines may be torn (cosmetic)
#   MariaDB / LDAP / ClamAV raw files -- excluded from data tier tar
#                  (dumps + slapcat are the authoritative restore source;
#                  ClamAV signatures are regenerable)
#
# Output:
#   <-P>/hermes-backup-<scope>-<build_no>-<UTC-ts>.tar
#       backup_manifest.json
#       databases.tar.gz   (6 .sql; system/all only)
#       ldap.ldif.gz       (slapcat output; system/all only)
#       config.tar.gz      (install root MINUS data tiers; system/all)
#       data.tar.gz        (Data tier MINUS mysql/ ldap/ clamav/; system/all)
#       archive.tar.gz, vmail.tar.gz, nextcloud.tar.gz  (relevant tiers)
# ============================================================================

set -uo pipefail

# ---- Self-locate HERMES_ROOT (walk up to find docker-compose.yml) ----
# Only docker-compose.yml is required as the sentinel; .git is intentionally
# NOT required here (unlike system_update_docker.sh which needs git for
# `git fetch` + `git checkout`). Upload-deployed installs that bypass git
# clone -- the common pattern on DEV / Test boxes that get files pushed via
# scp / rsync -- have no .git/ at all. The backup/restore scripts only
# need to find .env and call docker compose, so docker-compose.yml alone
# is enough to identify the install root.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]]; do
        if [[ -f "$HERMES_ROOT/docker-compose.yml" ]]; then
            break
        fi
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "ERROR: Could not locate docker-compose.yml walking up from $SCRIPT_DIR" >&2
        echo "Set HERMES_ROOT environment variable manually and retry." >&2
        exit 1
    fi
fi

# Log lives in a temp file until preflight validates the backup path; then
# it's moved alongside the backup tarball with a matching filename prefix.
# That way backup + log + sha256 travel together, and a remote postmortem
# (operator only has the remote share) has the full context.
LOG_FILE="$(mktemp /tmp/hermes-backup-XXXXXX.log)"

# ---- Colors ----
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

log()   { printf '%s[%s]%s %s\n' "$GREEN" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s[%s] WARN:%s %s\n' "$YELLOW" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
error() { printf '%s[%s] ERROR:%s %s\n' "$RED" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE" >&2; }
fatal() { error "$@"; cleanup_on_fatal; send_notification FAILURE "$*"; exit 1; }
header(){ printf '\n%s== %s ==%s\n' "$CYAN" "$*" "$NC" | tee -a "$LOG_FILE"; }

# ---- Notifications --------------------------------------------------------
# Sends a status email via the hermes_postfix_dkim container's sendmail.
# Subject is prefixed with [SUCCESS] or [FAILURE] -- the bracketed prefix is
# greppable in a mail client and visually unmissable. Body includes the run
# context + the tail of the log file.
#
# Caveats:
# - Requires hermes_postfix_dkim to be running. If the failure cause is "the
#   postfix container is down", the email won't go out -- catch that case
#   with external monitoring (Zabbix, healthchecks.io, etc.) instead.
# - sendmail-injected mail bypasses most of Postfix's smtpd_*_restrictions
#   (no network-receive checks), so the From: address can be anything
#   Postfix accepts as local; we use postmaster@<hostname>.
send_notification() {
    local status="$1"   # SUCCESS, FAILURE, TEST_SUCCESS, or TEST_FAILURE
    local detail="${2:-}"

    [[ -z "$NOTIFY_EMAIL" ]] && return 0
    [[ "$status" == "SUCCESS" ]] && (( ! NOTIFY_ON_SUCCESS )) && return 0
    (( DRY_RUN )) && { log "[dry-run] would send ${status} notification to ${NOTIFY_EMAIL}"; return 0; }

    local host subject from log_tail body status_label is_test=0
    host="$(hostname -f 2>/dev/null || hostname)"
    case "$status" in
        TEST_SUCCESS) status_label="[TEST] [SUCCESS]"; is_test=1 ;;
        TEST_FAILURE) status_label="[TEST] [FAILURE]"; is_test=1 ;;
        SUCCESS)      status_label="[SUCCESS]" ;;
        FAILURE)      status_label="[FAILURE]" ;;
        *)            status_label="[${status}]" ;;
    esac
    subject="${status_label} Hermes backup on ${host} (scope=${SCOPE:-test})"
    from="postmaster@${host}"
    log_tail="$(tail -50 "$LOG_FILE" 2>/dev/null || echo '(log unavailable)')"

    if (( is_test )); then
        # Test payload -- self-explanatory body, no real run context to report.
        body="This is a TEST notification from scripts/system_backup.sh.

Host:        ${host}
Subject:     ${subject}
Sent at:     $(date)
Sent by:     $(basename "$0") --test-notify

If you are reading this in your inbox, the Hermes backup notification path
is working end to end:
  1. docker exec into hermes_postfix_dkim succeeded
  2. The Postfix container accepted the message
  3. Postfix delivered to ${NOTIFY_EMAIL}

No actual backup was run. Real backups will send messages prefixed
[SUCCESS] or [FAILURE] (without the leading [TEST] tag), so any ops-
alert filters watching for [FAILURE] will NOT be tripped by this test.

---
This message was sent by scripts/system_backup.sh --test-notify."
    elif [[ "$status" == "FAILURE" ]]; then
        body="The Hermes backup at $(date) FAILED.

Host:        ${host}
Scope:       ${SCOPE:-?}
Mode:        $((( COLD_MODE )) && echo cold || echo hot)
Reason:      ${detail}
Log file:    ${LOG_FILE}

Last 50 lines of log:
${log_tail}

---
This message was sent by scripts/system_backup.sh on the Hermes Docker host.
Investigate the log file above for the full failure context."
    else
        local sz="(unknown)"
        [[ -n "${FINAL_TAR:-}" && -f "${FINAL_TAR}" ]] && \
            sz="$(stat -c%s "$FINAL_TAR" | numfmt --to=iec --suffix=B 2>/dev/null || stat -c%s "$FINAL_TAR")"
        body="The Hermes backup at $(date) succeeded.

Host:        ${host}
Scope:       ${SCOPE:-?}
Mode:        $((( COLD_MODE )) && echo cold || echo hot)
Output:      ${FINAL_TAR:-?}
Size:        ${sz}
Duration:    ${SECONDS}s
Log file:    ${LOG_FILE}

---
This message was sent by scripts/system_backup.sh on the Hermes Docker host.
You're receiving this because --notify-on-success was set."
    fi

    # Compose the SMTP message and pipe to sendmail inside the postfix
    # container. If hermes_postfix_dkim is down, this fails silently --
    # external monitoring is the safety net for that case.
    {
        printf 'From: %s\n' "$from"
        printf 'To: %s\n' "$NOTIFY_EMAIL"
        printf 'Subject: %s\n' "$subject"
        printf 'Auto-Submitted: auto-generated\n'
        printf 'Content-Type: text/plain; charset=utf-8\n'
        printf '\n'
        printf '%s\n' "$body"
    } | docker exec -i hermes_postfix_dkim sendmail -t 2>>"$LOG_FILE" \
        && log "Notification sent to ${NOTIFY_EMAIL} ([${status}])" \
        || warn "Failed to send ${status} notification to ${NOTIFY_EMAIL} (is hermes_postfix_dkim up?). Check ${LOG_FILE}."
}

# ---- Args ----
BACKUP_PATH=""
SCOPE=""
COLD_MODE=0
NO_NC_MAINTENANCE=0
NOTIFY_EMAIL=""
NOTIFY_ON_SUCCESS=0
TEST_NOTIFY=0
ASSUME_YES=0
DRY_RUN=0
SHOW_HELP=0

usage() {
    cat <<EOF
Usage: $(basename "$0") -P <path> -B <scope> [--cold] [--no-nc-maintenance]
                       [--yes] [--dry-run] [--help]

Hermes SEG Docker system backup.

Required:
  -P <path>      Output directory for the backup tarball. Must exist and
                 be writable.
  -B <scope>     What to back up. One of:
                   system    -- Config + Data + 6 DB dumps + LDAP slapcat.
                                Nightly default. Small + fast.
                   archive   -- Archive tier only (Amavis quarantine).
                   vmail     -- Vmail tier only (Dovecot mailboxes).
                   nextcloud -- Nextcloud tier only (NC files).
                   all       -- Everything (every tier + dumps + slapcat).

Mode:
  --cold         Stop the stack for the duration of the backup. Use for
                 legal hold / forensic snapshots where absolute byte-
                 level consistency matters more than uptime. Default is
                 HOT mode (zero application downtime; uses application-
                 native hot-backup primitives -- safe for daily use).

  --no-nc-maintenance
                 Skip the brief 'occ maintenance:mode --on' that hot-mode
                 nextcloud / all backups use to pause NC user writes
                 during the file tar. Without it, file uploads happening
                 mid-tar may be missed by the backup.

Notifications:
  --notify-email=ADDR
                 Send an email when the backup completes. By default
                 emails on FAILURE only ("noisy on failure, silent on
                 success"). Subject is prefixed with [SUCCESS] or
                 [FAILURE] so it's easy to spot in a mail client.
                 Delivered via 'docker exec -i hermes_postfix_dkim
                 sendmail -t' (uses the Postfix MTA Hermes already
                 runs; no host MTA configuration needed).

                 IMPORTANT: this only works if Hermes itself is healthy
                 enough to send mail. For the "Hermes is so dead it
                 can't tell you" case, ALSO use an external monitoring
                 tool (Zabbix, Nagios, healthchecks.io, etc.) -- see
                 the Notifications section of the Backup & Restore
                 documentation for details.

  --notify-on-success
                 Also email on successful completion (not just on
                 failure). Most operators want failure-only; this is
                 opt-in for the "daily I-am-alive confirmation" use
                 case.

  --test-notify  Send a test [TEST] [SUCCESS] email AND a test
                 [TEST] [FAILURE] email immediately, then exit. Lets
                 you verify the notification path (Hermes Postfix
                 container -> external delivery -> your inbox /
                 alerting tool) without running an actual backup or
                 forcing a real failure. Requires --notify-email=ADDR;
                 -P and -B are not required. Subjects are prefixed
                 [TEST] so any ops-alert filters watching for
                 [FAILURE] are not tripped.

Options:
  --yes          Skip the interactive confirmation prompt.
  --dry-run      Show what would be done without changing anything.
  --help         Show this help.

Examples:
  sudo $(basename "$0") -P /mnt/backups -B system --yes
  sudo $(basename "$0") -P /mnt/backups -B vmail
  sudo $(basename "$0") -P /mnt/backups -B all --yes
  sudo $(basename "$0") -P /mnt/backups -B all --cold     # forensic snapshot
  sudo $(basename "$0") -P /mnt/backups -B system --yes \\
       --notify-email=admin@example.com                   # email on failure
  sudo $(basename "$0") -P /mnt/backups -B all --yes \\
       --notify-email=admin@example.com --notify-on-success   # both
  sudo $(basename "$0") --test-notify --notify-email=admin@example.com  # test only

Output filename:
  <path>/hermes-backup-<scope>-<build_no>-<UTC-timestamp>.tar

Inner archives (only the ones relevant to the chosen scope):
  backup_manifest.json   (scope, mode, topology, SHA256 sums)
  databases.tar.gz       (6 .sql files; system/all only)
  ldap.ldif.gz           (slapcat output; system/all only)
  config.tar.gz          (install root MINUS data tiers; system/all only)
  data.tar.gz            (Data tier MINUS mysql/ ldap/ clamav/; system/all)
  archive.tar.gz         (Archive tier; archive/all only)
  vmail.tar.gz           (Vmail tier; vmail/all only)
  nextcloud.tar.gz       (Nextcloud tier; nextcloud/all only)
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -P)                   BACKUP_PATH="$2"; shift 2 ;;
        -B)                   SCOPE="$2"; shift 2 ;;
        --cold)               COLD_MODE=1; shift ;;
        --no-nc-maintenance)  NO_NC_MAINTENANCE=1; shift ;;
        --notify-email=*)     NOTIFY_EMAIL="${1#--notify-email=}"; shift ;;
        --notify-email)       NOTIFY_EMAIL="$2"; shift 2 ;;
        --notify-on-success)  NOTIFY_ON_SUCCESS=1; shift ;;
        --test-notify)        TEST_NOTIFY=1; shift ;;
        --yes|-y)             ASSUME_YES=1; shift ;;
        --dry-run|-n)         DRY_RUN=1; shift ;;
        --help|-h)            SHOW_HELP=1; shift ;;
        *)                    error "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

if (( SHOW_HELP )); then usage; exit 0; fi
# --test-notify is self-contained: needs --notify-email but NOT -P or -B.
# Handled below after the helper functions are defined; just relax the
# required-arg checks for it here.
if (( ! TEST_NOTIFY )); then
    if [[ -z "$BACKUP_PATH" ]]; then error "Required flag -P missing."; usage; exit 1; fi
    if [[ -z "$SCOPE" ]]; then error "Required flag -B missing."; usage; exit 1; fi
    BACKUP_PATH="${BACKUP_PATH%/}"  # strip trailing slash so concatenated paths don't show //
    case "$SCOPE" in
        system|archive|vmail|nextcloud|all) ;;
        *) error "Invalid -B scope '${SCOPE}'. Must be one of: system, archive, vmail, nextcloud, all."; exit 1 ;;
    esac
fi
if (( TEST_NOTIFY )) && [[ -z "$NOTIFY_EMAIL" ]]; then
    error "--test-notify requires --notify-email=ADDR (otherwise there's nowhere to send the test)."
    exit 1
fi
if [[ $EUID -ne 0 ]] && (( ! DRY_RUN )); then fatal "Must run as root (live mode)."; fi

# ---- Scope helpers --------------------------------------------------------
scope_needs_dbs() { [[ "$SCOPE" == "system" || "$SCOPE" == "all" ]]; }
scope_includes_tier() {
    local t="$1"
    case "$SCOPE" in
        all)       return 0 ;;
        system)    [[ "$t" == "config" || "$t" == "data" ]] ;;
        archive)   [[ "$t" == "archive" ]] ;;
        vmail)     [[ "$t" == "vmail" ]] ;;
        nextcloud) [[ "$t" == "nextcloud" ]] ;;
    esac
}
scope_touches_nextcloud() { [[ "$SCOPE" == "nextcloud" || "$SCOPE" == "all" ]]; }

# ---- Constants ----
DATABASES=( hermes authelia opendmarc Syslog djigzo nextcloud )
TIERS=( config data archive vmail nextcloud )
LDAP_SUFFIX="dc=hermes,dc=local"

# Filled in at runtime
declare -A TIER_PATH
declare -A ARCHIVE_SHA
declare -A ARCHIVE_SIZE
TIMESTAMP="$(date -u '+%Y%m%dT%H%M%SZ')"
BUILD_NO=""
STAGE_DIR=""
FINAL_TAR=""
PARTIAL_TAR=""
STACK_STOPPED=0
NC_MAINT_TOGGLED=0
ARCHIVES_CREATED=()

# ---- Helpers ----
run() {
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s %s\n' "$CYAN" "$NC" "$*" | tee -a "$LOG_FILE"
    else
        "$@" 2>>"$LOG_FILE"
    fi
}

cleanup_on_fatal() {
    # Heartbeat may still be running if fatal fired mid-op; reap it first so
    # it doesn't keep emitting "still running" lines after the FAILURE line.
    stop_heartbeat
    if (( NC_MAINT_TOGGLED )) && (( ! DRY_RUN )); then
        warn "Attempting to clear NC maintenance mode..."
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ maintenance:mode --off >>"$LOG_FILE" 2>&1 || true
    fi
    if (( STACK_STOPPED )) && (( ! DRY_RUN )); then
        warn "Attempting to restart stack after failure..."
        ( cd "$HERMES_ROOT" && docker compose up -d ) >>"$LOG_FILE" 2>&1 || true
    fi
    # Staging dir + .partial tarball cleanup. Auto-removed only for truly
    # unattended runs: no TTY (cron) or --dry-run (nothing real to keep).
    # --yes is orthogonal -- it skips the pre-run "proceed?" prompt, not
    # this post-failure cleanup decision. An operator who said --yes still
    # gets the chance to inspect partial dumps after a failure.
    local auto_cleanup=0
    if (( DRY_RUN )) || [[ ! -t 0 ]]; then
        auto_cleanup=1
    fi

    if [[ -d "${STAGE_DIR:-}" ]]; then
        local remove_staging=$auto_cleanup
        if (( ! auto_cleanup )); then
            warn "Staging directory left at: ${STAGE_DIR}"
            read -r -p "Remove it? (log already captured everything) [y/N] " reply
            [[ "$reply" =~ ^[Yy]$ ]] && remove_staging=1
        fi
        if (( remove_staging )); then
            warn "Removing staging directory: ${STAGE_DIR}"
            rm -rf "$STAGE_DIR" 2>>"$LOG_FILE" || \
                warn "Could not remove ${STAGE_DIR} -- delete manually."
        else
            warn "Staging preserved. Remove manually when done: rm -rf '${STAGE_DIR}'"
        fi
    fi

    if [[ -f "${PARTIAL_TAR:-}" ]]; then
        local remove_partial=$auto_cleanup
        if (( ! auto_cleanup )); then
            warn "Partial tarball left at: ${PARTIAL_TAR}"
            read -r -p "Remove it? [y/N] " reply
            [[ "$reply" =~ ^[Yy]$ ]] && remove_partial=1
        fi
        if (( remove_partial )); then
            warn "Removing partial tarball: ${PARTIAL_TAR}"
            rm -f "$PARTIAL_TAR" 2>>"$LOG_FILE" || \
                warn "Could not remove ${PARTIAL_TAR} -- delete manually."
        else
            warn "Partial tarball preserved. Remove manually: rm -f '${PARTIAL_TAR}'"
        fi
    fi
}

confirm() {
    if (( ASSUME_YES )) || (( DRY_RUN )); then return 0; fi
    read -r -p "$1 [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

load_mounts() {
    local env_file="${HERMES_ROOT}/.env"
    [[ -f "$env_file" ]] || fatal "Cannot read ${env_file} -- need DATA/ARCHIVE/VMAIL/FILES_MOUNT."
    local k v
    while IFS='=' read -r k v; do
        v="${v%\"}"; v="${v#\"}"; v="${v%\'}"; v="${v#\'}"
        case "$k" in
            DATA_MOUNT)    TIER_PATH[data]="$v" ;;
            ARCHIVE_MOUNT) TIER_PATH[archive]="$v" ;;
            VMAIL_MOUNT)   TIER_PATH[vmail]="$v" ;;
            FILES_MOUNT)   TIER_PATH[nextcloud]="$v" ;;
        esac
    done < <(grep -E '^(DATA|ARCHIVE|VMAIL|FILES)_MOUNT=' "$env_file" | sed 's/\r$//')
    TIER_PATH[config]="$HERMES_ROOT"
    for t in "${TIERS[@]}"; do
        [[ -n "${TIER_PATH[$t]:-}" ]] || fatal "Tier '$t' has no mount path in .env."
        if scope_includes_tier "$t"; then
            [[ -d "${TIER_PATH[$t]}" ]] || fatal "Tier '$t' path does not exist: ${TIER_PATH[$t]}"
        fi
    done
}

# Background heartbeat: emits a log line every N seconds with elapsed time
# and (if given a watch file) the file's current size. Wraps a long op so
# operators / cron logs can see progress instead of a frozen-looking terminal.
# stop_heartbeat is idempotent + safe to call when no heartbeat is running.
HEARTBEAT_PID=""
start_heartbeat() {
    local label="$1"
    local watch_file="${2:-}"
    local interval="${3:-60}"
    stop_heartbeat
    (
        local start=$SECONDS
        while true; do
            sleep "$interval"
            local elapsed=$((SECONDS - start))
            if [[ -n "$watch_file" && -f "$watch_file" ]]; then
                local size_h
                size_h=$(stat -c%s "$watch_file" 2>/dev/null | numfmt --to=iec 2>/dev/null)
                log "  ... ${label}: ${size_h:-?} after ${elapsed}s"
            else
                log "  ... ${label}: still running (${elapsed}s)"
            fi
        done
    ) &
    HEARTBEAT_PID=$!
    disown 2>/dev/null || true
}
stop_heartbeat() {
    [[ -n "$HEARTBEAT_PID" ]] && kill "$HEARTBEAT_PID" 2>/dev/null
    HEARTBEAT_PID=""
}

ensure_container_running() {
    local name="$1"
    if docker ps --format '{{.Names}}' | grep -q "^${name}$"; then return 0; fi
    if (( COLD_MODE )); then
        warn "Cold mode: starting ${name} briefly for dump..."
        ( cd "$HERMES_ROOT" && docker compose start "$name" ) >>"$LOG_FILE" 2>&1 || \
            fatal "Failed to start ${name} for dump."
        sleep 4
    else
        fatal "${name} is not running. Hot mode requires it to be up. Start it with: docker compose up -d ${name}"
    fi
}

# Run a mariadb client command inside hermes_db_server using root auth.
# Password is read from the mounted Docker secret at /run/secrets/MYSQL_ROOT_PASSWORD.
# (docker exec does NOT inherit env vars set by the entrypoint at runtime, so
# the FILE__MYSQL_ROOT_PASSWORD translation s6 does for mysqld is invisible here.)
# Falls back to no-password if the secret isn't mounted (very old installs with
# unix_socket grants). Pass -i as first arg to enable stdin (for piping SQL files).
db_exec() {
    local stdin_flag=""
    if [[ "${1:-}" == "-i" ]]; then stdin_flag="-i"; shift; fi
    docker exec $stdin_flag hermes_db_server bash -c '
        if [[ -r /run/secrets/MYSQL_ROOT_PASSWORD ]]; then
            MYSQL_PWD="$(cat /run/secrets/MYSQL_ROOT_PASSWORD)" exec mariadb -u root "$@"
        else
            exec mariadb -u root "$@"
        fi
    ' bash "$@"
}

db_dump() {
    docker exec hermes_db_server bash -c '
        if [[ -r /run/secrets/MYSQL_ROOT_PASSWORD ]]; then
            MYSQL_PWD="$(cat /run/secrets/MYSQL_ROOT_PASSWORD)" exec mariadb-dump -u root --single-transaction --routines --triggers --events --databases "$1"
        else
            exec mariadb-dump -u root --single-transaction --routines --triggers --events --databases "$1"
        fi
    ' bash "$1"
}

read_build_no() {
    ensure_container_running hermes_db_server
    local i
    for i in {1..15}; do
        if db_exec -e 'SELECT 1' >/dev/null 2>&1; then break; fi
        sleep 2
    done
    BUILD_NO="$(db_exec -N -s hermes -e "SELECT value FROM system_settings WHERE parameter='build_no';" 2>>"$LOG_FILE" | tr -d '[:space:]')"
    [[ -n "$BUILD_NO" ]] || fatal "Could not read build_no from system_settings."
}

dump_databases() {
    header "Dumping databases (mariadb-dump --single-transaction)"
    ensure_container_running hermes_db_server
    local db_stage="${STAGE_DIR}/databases"
    mkdir -p "$db_stage"
    local db
    for db in "${DATABASES[@]}"; do
        log "  dumping ${db}..."
        if (( DRY_RUN )); then
            printf '%s[dry-run]%s mariadb-dump --single-transaction %s\n' "$CYAN" "$NC" "$db" | tee -a "$LOG_FILE"
            continue
        fi
        if ! db_dump "$db" > "${db_stage}/${db}.sql" 2>>"$LOG_FILE"; then
            fatal "mariadb-dump failed for '${db}'. See $LOG_FILE."
        fi
    done
    if (( ! DRY_RUN )); then
        log "  packaging databases.tar.gz..."
        tar -czf "${STAGE_DIR}/databases.tar.gz" -C "$db_stage" . 2>>"$LOG_FILE"
        rm -rf "$db_stage"
        ARCHIVES_CREATED+=( "databases.tar.gz" )
    fi
}

dump_ldap() {
    header "Dumping OpenLDAP directory (slapcat)"
    ensure_container_running hermes_ldap
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s docker exec hermes_ldap slapcat -F /etc/ldap/slapd.d -b %s\n' "$CYAN" "$NC" "$LDAP_SUFFIX" | tee -a "$LOG_FILE"
        return 0
    fi
    # -F points slapcat at the OLC config dir slapd actually uses; without it,
    # slapcat falls back to /usr/local/etc/openldap/slapd.conf which is stale
    # in the Hermes image and breaks with "invalid path" at line 72.
    if ! docker exec hermes_ldap slapcat -F /etc/ldap/slapd.d -b "$LDAP_SUFFIX" 2>>"$LOG_FILE" \
        | gzip -c > "${STAGE_DIR}/ldap.ldif.gz"; then
        fatal "slapcat failed for ${LDAP_SUFFIX}. See $LOG_FILE."
    fi
    ARCHIVES_CREATED+=( "ldap.ldif.gz" )
}

nc_maintenance_on() {
    if (( NO_NC_MAINTENANCE )) || ! scope_touches_nextcloud; then return 0; fi
    log "Setting Nextcloud maintenance mode ON (paused NC web UI; mail flow unaffected)..."
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s occ maintenance:mode --on\n' "$CYAN" "$NC" | tee -a "$LOG_FILE"
        return 0
    fi
    if docker exec -u www-data hermes_nextcloud php /var/www/html/occ maintenance:mode --on >>"$LOG_FILE" 2>&1; then
        NC_MAINT_TOGGLED=1
    else
        warn "occ maintenance:mode --on failed; nextcloud tier tar will proceed without it."
    fi
}

nc_maintenance_off() {
    if ! (( NC_MAINT_TOGGLED )); then return 0; fi
    log "Clearing Nextcloud maintenance mode..."
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s occ maintenance:mode --off\n' "$CYAN" "$NC" | tee -a "$LOG_FILE"
        return 0
    fi
    docker exec -u www-data hermes_nextcloud php /var/www/html/occ maintenance:mode --off >>"$LOG_FILE" 2>&1 \
        || warn "occ maintenance:mode --off failed -- operator should run it manually."
    NC_MAINT_TOGGLED=0
}

tar_tier() {
    local tier="$1"
    local src="${TIER_PATH[$tier]}"
    local out="${STAGE_DIR}/${tier}.tar.gz"
    log "  ${tier}: tarring ${src} -> $(basename "$out")"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -czf %s ...\n' "$CYAN" "$NC" "$out" | tee -a "$LOG_FILE"
        return 0
    fi
    local exclude_args=()
    case "$tier" in
        config)
            exclude_args+=( --exclude='./install-logs' --exclude='./.git' )
            # Exclude any data tier paths nested inside the install root.
            for t in data archive vmail nextcloud; do
                local p="${TIER_PATH[$t]}"
                if [[ "$p" == "$src"/* ]]; then
                    exclude_args+=( --exclude="./${p#$src/}" )
                fi
            done
            ;;
        data)
            # Excluded from the data tier tar:
            #   ./dbase                       -- MariaDB datadir; mariadb-dump is authoritative
            #   ./ldap/data                   -- OpenLDAP datadir; slapcat is authoritative
            #                                    (logs at ./ldap/logs are kept)
            #   ./mail_filter/data/clamav     -- ClamAV signatures; regenerable, ~1GB
            exclude_args+=( \
                --exclude='./dbase' \
                --exclude='./ldap/data' \
                --exclude='./mail_filter/data/clamav' \
            )
            # Also exclude sibling tiers nested under data (operators on small
            # deployments collapse ARCHIVE_MOUNT=/mnt/data/amavis etc.; those
            # paths belong to their own scope, not 'system').
            for t in archive vmail nextcloud; do
                local p="${TIER_PATH[$t]}"
                if [[ "$p" == "$src"/* ]]; then
                    exclude_args+=( --exclude="./${p#$src/}" )
                fi
            done
            ;;
    esac
    # tar exit codes: 0=success, 1=warnings only (sockets, "file changed as
    # we read it" -- expected on hot backup of a live system), 2+=real error.
    # The script previously fatal'd on ANY non-zero; that misclassified
    # successful hot backups as failures.
    local tar_exit=0
    start_heartbeat "${tier}: tar" "$out" 60
    tar -czf "$out" "${exclude_args[@]}" -C "$src" . 2>>"$LOG_FILE" || tar_exit=$?
    stop_heartbeat
    case "$tar_exit" in
        0) ;;
        1) warn "  ${tier}: tar exited 1 (warnings only -- sockets ignored, live-file changes); archive is valid." ;;
        *) fatal "tar failed for tier '${tier}' (exit ${tar_exit})" ;;
    esac
    ARCHIVES_CREATED+=( "${tier}.tar.gz" )
}

compute_sha256() {
    sha256sum "$1" | awk '{print $1}'
}

emit_manifest() {
    local m="${STAGE_DIR}/backup_manifest.json"
    log "  emitting manifest..."
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s would write %s\n' "$CYAN" "$NC" "$m" | tee -a "$LOG_FILE"
        return 0
    fi
    local mode_str
    mode_str="$((( COLD_MODE )) && echo cold || echo hot)"
    {
        printf '{\n'
        printf '  "manifest_version": "1.0",\n'
        printf '  "build_no": "%s",\n' "$BUILD_NO"
        printf '  "scope": "%s",\n' "$SCOPE"
        printf '  "mode": "%s",\n' "$mode_str"
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "hostname": "%s",\n' "$(hostname -f 2>/dev/null || hostname)"
        printf '  "topology": {\n'
        printf '    "config_path": "%s",\n' "${TIER_PATH[config]}"
        printf '    "data_mount": "%s",\n' "${TIER_PATH[data]}"
        printf '    "archive_mount": "%s",\n' "${TIER_PATH[archive]}"
        printf '    "vmail_mount": "%s",\n' "${TIER_PATH[vmail]}"
        printf '    "files_mount": "%s"\n' "${TIER_PATH[nextcloud]}"
        printf '  },\n'
        printf '  "databases": ['
        local first=1 db
        for db in "${DATABASES[@]}"; do
            (( first )) && first=0 || printf ', '
            printf '"%s"' "$db"
        done
        printf '],\n'
        printf '  "ldap_suffix": "%s",\n' "$LDAP_SUFFIX"
        printf '  "archives": {\n'
        first=1
        local a
        for a in "${ARCHIVES_CREATED[@]}"; do
            (( first )) && first=0 || printf ',\n'
            printf '    "%s": {"sha256": "%s", "size_bytes": %s}' \
                "$a" "${ARCHIVE_SHA[$a]}" "${ARCHIVE_SIZE[$a]}"
        done
        printf '\n  }\n'
        printf '}\n'
    } > "$m"
}

# ---- Phases ----
preflight() {
    header "Preflight"
    if (( ! DRY_RUN )); then
        command -v docker >/dev/null 2>&1 || fatal "docker not in PATH"
        docker compose version >/dev/null 2>&1 || fatal "docker compose v2 not available"
    fi
    if [[ ! -d "$BACKUP_PATH" ]]; then
        error "Backup path does not exist: ${BACKUP_PATH}"
        error "The script does NOT auto-create the backup directory -- this is"
        error "deliberate, to catch typos in -P before writing GBs to the wrong place."
        error "Create it first, then re-run:"
        error "  sudo mkdir -p ${BACKUP_PATH}"
        fatal "Aborting."
    fi
    [[ -w "$BACKUP_PATH" ]] || fatal "Backup path exists but is not writable by root: ${BACKUP_PATH}"
    load_mounts
    read_build_no

    FINAL_TAR="${BACKUP_PATH}/hermes-backup-${SCOPE}-${BUILD_NO}-${TIMESTAMP}.tar"
    PARTIAL_TAR="${FINAL_TAR}.partial"
    STAGE_DIR="${BACKUP_PATH}/.staging-${SCOPE}-${TIMESTAMP}"
    [[ -e "$FINAL_TAR" || -e "$PARTIAL_TAR" || -e "$STAGE_DIR" ]] && \
        fatal "Target files already exist (timestamp collision): ${FINAL_TAR}*"

    # Relocate the log from the bootstrap /tmp path to live alongside the
    # backup tarball. Best-effort: if the rename fails (rare -- different
    # filesystem with no link/rename support), keep using the /tmp path so
    # nothing is lost.
    local final_log="${BACKUP_PATH}/hermes-backup-${SCOPE}-${BUILD_NO}-${TIMESTAMP}.log"
    if mv "$LOG_FILE" "$final_log" 2>/dev/null; then
        LOG_FILE="$final_log"
    else
        warn "Could not relocate log from ${LOG_FILE} to ${final_log} -- continuing with /tmp path."
    fi

    log "HERMES_ROOT:   ${HERMES_ROOT}"
    log "build_no:      ${BUILD_NO}"
    log "Scope:         ${SCOPE}"
    log "Mode:          $((( COLD_MODE )) && echo COLD || echo HOT)"
    log "Output:        ${FINAL_TAR}"
    log "Log:           ${LOG_FILE}"
    log "Staging:       ${STAGE_DIR}"
    for t in "${TIERS[@]}"; do
        scope_includes_tier "$t" && log "Tier ${t}: ${TIER_PATH[$t]}"
    done

    log ""
    if (( COLD_MODE )); then
        log "COLD mode: the stack will be STOPPED for the duration of the backup."
    else
        log "HOT mode: zero application downtime. Mail flow continues throughout."
        if scope_touches_nextcloud && ! (( NO_NC_MAINTENANCE )); then
            log "Nextcloud web UI will be in 'maintenance mode' for the duration of the NC file tar."
            log "Mail is unaffected. To skip, re-run with --no-nc-maintenance."
        fi
    fi
    log ""
    confirm "Proceed?" || { log "Aborted by operator."; exit 0; }
    if (( ! DRY_RUN )); then mkdir -p "$STAGE_DIR"; fi
}

run_backup() {
    if (( COLD_MODE )); then
        header "Stopping stack (cold mode)"
        run bash -c "cd '$HERMES_ROOT' && docker compose stop"
        STACK_STOPPED=1
    fi

    if scope_needs_dbs; then
        dump_databases
        dump_ldap
    fi

    nc_maintenance_on   # no-op if scope doesn't touch nextcloud

    header "Archiving in-scope storage tiers"
    for t in "${TIERS[@]}"; do
        scope_includes_tier "$t" && tar_tier "$t"
    done

    nc_maintenance_off
}

assemble_outer() {
    header "Assembling outer tarball"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s would compute SHA256 + emit manifest + outer tar + atomic rename\n' "$CYAN" "$NC" | tee -a "$LOG_FILE"
        return 0
    fi
    local a
    for a in "${ARCHIVES_CREATED[@]}"; do
        ARCHIVE_SHA[$a]="$(compute_sha256 "${STAGE_DIR}/${a}")"
        ARCHIVE_SIZE[$a]="$(stat -c%s "${STAGE_DIR}/${a}")"
    done
    emit_manifest
    # Same exit-code treatment as tar_tier(): exit 1 = warnings only (e.g.
    # CIFS's async dir-metadata updates can trigger "file changed as we
    # read it" on the staging dir itself even though all the inner files
    # are static and complete). Only exit >= 2 is a real failure.
    local outer_exit=0
    start_heartbeat "outer tar" "$PARTIAL_TAR" 60
    tar -cf "$PARTIAL_TAR" -C "$STAGE_DIR" . 2>>"$LOG_FILE" || outer_exit=$?
    stop_heartbeat
    case "$outer_exit" in
        0) ;;
        1) warn "  outer tar exited 1 (warnings only -- CIFS metadata quirk); archive is valid." ;;
        *) fatal "Outer tar assembly failed (exit ${outer_exit})." ;;
    esac
    mv "$PARTIAL_TAR" "$FINAL_TAR" \
        || fatal "Atomic rename failed: ${PARTIAL_TAR} -> ${FINAL_TAR}"
    rm -rf "$STAGE_DIR"
}

restart_stack_if_cold() {
    if ! (( STACK_STOPPED )); then return 0; fi
    header "Restarting stack (cold mode)"
    run bash -c "cd '$HERMES_ROOT' && docker compose up -d"
    STACK_STOPPED=0
    if (( DRY_RUN )); then return 0; fi
    local i
    for i in {1..30}; do
        if docker exec hermes_commandbox curl -sf --max-time 2 http://localhost:8888/ >/dev/null 2>&1; then
            log "  hermes_commandbox responding ✓"
            return 0
        fi
        sleep 2
    done
    warn "hermes_commandbox did not respond on :8888 within 60s. Check 'docker compose ps'."
}

report() {
    header "Done"
    if (( DRY_RUN )); then
        log "Dry-run complete. Nothing was changed."
        return 0
    fi
    local sz
    sz="$(stat -c%s "$FINAL_TAR" | numfmt --to=iec --suffix=B 2>/dev/null || stat -c%s "$FINAL_TAR")"
    log "Backup written: ${FINAL_TAR}"
    log "Scope:          ${SCOPE} (${ARCHIVES_CREATED[*]})"
    log "Size:           ${sz}"
    log "Log:            ${LOG_FILE}"
    log ""
    log "To restore:"
    log "  sudo ./scripts/system_restore.sh -F '${FINAL_TAR}'"
}

test_notify_and_exit() {
    log "Hermes SEG system backup -- test notification mode"
    log "Target: ${NOTIFY_EMAIL}"
    log "Sending [TEST] [SUCCESS] sample..."
    send_notification TEST_SUCCESS
    # 5s gap between the two test sends. Two messages with same From/To and
    # similar bodies submitted within microseconds of each other can trip
    # short-window content-hash dedup at a smarthost or receiving MX. The
    # gap defeats burst-style dedup; longer-window dedup may still collapse
    # them. If only one of the pair arrives, look at the smarthost's mail
    # log for "discarded as duplicate" or similar.
    log "Pausing 5s before second test (avoids burst-dedup at smarthost / MX)..."
    sleep 5
    log "Sending [TEST] [FAILURE] sample..."
    send_notification TEST_FAILURE
    log ""
    log "Two test messages dispatched to ${NOTIFY_EMAIL}."
    log "Check your inbox (and ops alerting if any) to confirm both arrived."
    log "If only one arrived: your smarthost or receiving MX is likely deduplicating"
    log "near-identical messages. Check that mailserver's log for discard / dedup"
    log "events. Real backup notifications (which send only one message) are not"
    log "affected by this."
    log "If neither arrived: verify hermes_postfix_dkim is running and check"
    log "${LOG_FILE} for sendmail errors."
    exit 0
}

main() {
    if (( TEST_NOTIFY )); then test_notify_and_exit; fi
    log "Hermes SEG system backup"
    preflight
    run_backup
    assemble_outer
    restart_stack_if_cold
    report
    send_notification SUCCESS
}

main "$@"
