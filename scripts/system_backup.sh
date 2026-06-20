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
#   <-P>/hermes-backup-<scope>-<build_no>-<UTC-ts>/    (a DIRECTORY)
#     +- contents:
#       manifest.json      (scope, mode, topology, SHA256 per archive)
#       backup.log         (log of this backup run)
#       databases.tar.gz   (6 .sql; system/all only)
#       ldap.ldif.gz       (slapcat output; system/all only)
#       config.tar.gz      (USER DATA ONLY: keys, .gnupg, ssl, templates,
#                           sa-bayes, sa-learn, dkim, arc, conf_files --
#                           NOT docker-compose.yml / .env / secrets / scripts;
#                           system/all)
#       data.tar.gz        (USER DATA ONLY from data tier: sieve scripts +
#                           Authelia SQLite if present. NOT logs, NOT queue,
#                           NOT regenerable state; system/all)
#       archive.tar.gz, vmail.tar.gz, nextcloud.tar.gz  (relevant tiers)
#
# A backup is a SELF-CONTAINED DIRECTORY (no outer tar wrapper). Operators
# move it around as a unit (rsync / cp -r / tar for archival / etc.).
# Restore reads it in-place from any reachable mount -- ZERO scratch space.
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
        [[ -n "${FINAL_DIR:-}" && -d "${FINAL_DIR}" ]] && \
            sz="$(du -sb "$FINAL_DIR" 2>/dev/null | cut -f1 | numfmt --to=iec --suffix=B 2>/dev/null || echo "?")"
        body="The Hermes backup at $(date) succeeded.

Host:        ${host}
Scope:       ${SCOPE:-?}
Mode:        $((( COLD_MODE )) && echo cold || echo hot)
Output dir:  ${FINAL_DIR:-?}
Total size:  ${sz}
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
  -P <path>      Parent directory where the backup will be created. Must
                 exist and be writable. Each backup run creates a NEW
                 subdirectory:
                   <-P>/hermes-backup-<scope>-<build_no>-<UTC-ts>/
                 containing manifest.json + backup.log + per-scope tar.gz
                 files. The backup directory IS the backup -- move it
                 around as a unit (rsync / cp -r / etc.).
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

Output directory:
  <path>/hermes-backup-<scope>-<build_no>-<UTC-timestamp>/

Contents (only the ones relevant to the chosen scope):
  manifest.json          (scope, mode, topology, SHA256 per archive)
  backup.log             (log of this backup run)
  databases.tar.gz       (6 .sql files; system/all only)
  ldap.ldif.gz           (slapcat output; system/all only)
  config.tar.gz          (USER DATA ONLY -- DKIM/PGP/SSL keys, custom
                          amavis templates, SpamAssassin bayes corpus,
                          OpenDKIM/ARC tables. Does NOT include
                          docker-compose.yml, .env, host secrets, scripts,
                          or release artifacts -- those come from the
                          target install's checkout. system/all only.)
  data.tar.gz            (USER DATA ONLY -- sieve scripts (dovecot/sieve/)
                          + Authelia SQLite (if present). NOT mariadb/ldap
                          (captured via dumps), NOT logs, NOT postfix queue,
                          NOT regenerable runtime state. system/all only.)
  archive.tar.gz         (Archive tier; archive/all only)
  vmail.tar.gz           (Vmail tier; vmail/all only)
  nextcloud.tar.gz       (Nextcloud tier; nextcloud/all only)

While a backup is in progress, the directory has a .staging- prefix
(.staging-hermes-backup-...). On success it's atomic-renamed to the
final name. On failure the staging dir is preserved with backup.log
inside for inspection.
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
# A backup is a DIRECTORY containing manifest.json + per-scope tar.gz
# files + the backup-time log. While the backup is running, it lives at
# PARTIAL_DIR (.staging-* prefix); on success, atomic-renamed to FINAL_DIR.
# Operators only ever see complete backups in normal listings.
FINAL_DIR=""
PARTIAL_DIR=""
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
    # Preserve PARTIAL_DIR on failure. The log file lives inside it, and
    # send_notification (called right after this) tails LOG_FILE for the
    # failure email. The .staging- prefix means operators easily distinguish
    # incomplete backups from completed ones in ls -- they can inspect the
    # log inside, then `rm -rf` when done. No auto-prompt: keeps the
    # behavior identical for cron vs interactive vs --yes runs.
    if [[ -d "${PARTIAL_DIR:-}" ]]; then
        warn "Partial backup preserved at: ${PARTIAL_DIR}"
        warn "  Log inside: ${PARTIAL_DIR}/backup.log"
        warn "  Remove manually when done: sudo rm -rf '${PARTIAL_DIR}'"
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
#
# Auth strategy: try no-password FIRST, fall back to /run/secrets/MYSQL_ROOT_PASSWORD.
#
# Why: canonical LinuxServer mariadb installs set root@localhost with
# unix_socket-style auth (empty plugin column, passwordless from inside
# the container). With unix_socket, sending a password is REJECTED, not
# ignored -- so always-supplying-password breaks the canonical case.
# Older installs (DEV) provisioned root@localhost with an actual password
# via FILE__MYSQL_ROOT_PASSWORD; for those the secret-file fallback works.
# This logic handles both. Pass -i as first arg to enable stdin.
db_exec() {
    local stdin_flag=""
    if [[ "${1:-}" == "-i" ]]; then stdin_flag="-i"; shift; fi
    docker exec $stdin_flag hermes_db_server bash -c '
        if mariadb -u root -e "SELECT 1" >/dev/null 2>&1; then
            exec mariadb -u root "$@"
        elif [[ -r /run/secrets/MYSQL_ROOT_PASSWORD ]]; then
            MYSQL_PWD="$(cat /run/secrets/MYSQL_ROOT_PASSWORD)" exec mariadb -u root "$@"
        else
            exec mariadb -u root "$@"
        fi
    ' bash "$@"
}

db_dump() {
    docker exec hermes_db_server bash -c '
        if mariadb -u root -e "SELECT 1" >/dev/null 2>&1; then
            exec mariadb-dump -u root --single-transaction --routines --triggers --events --databases "$1"
        elif [[ -r /run/secrets/MYSQL_ROOT_PASSWORD ]]; then
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
    local db_stage="${PARTIAL_DIR}/databases"
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
        tar -czf "${PARTIAL_DIR}/databases.tar.gz" -C "$db_stage" . 2>>"$LOG_FILE"
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
        | gzip -c > "${PARTIAL_DIR}/ldap.ldif.gz"; then
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
    local out="${PARTIAL_DIR}/${tier}.tar.gz"
    log "  ${tier}: tarring ${src} -> $(basename "$out")"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -czf %s ...\n' "$CYAN" "$NC" "$out" | tee -a "$LOG_FILE"
        return 0
    fi

    local exclude_args=()
    local include_paths=( "." )       # default: archive everything under $src

    case "$tier" in
        config)
            # CONFIG TIER == USER DATA ONLY.
            #
            # Earlier versions captured the whole install root with excludes.
            # That mixed user data with install-specific files (docker-
            # compose.yml, .env, host secrets) and release artifacts
            # (scripts/, Docker/, docs/). On cross-host restore, overlaying
            # those clobbered the target install's stack definition --
            # docker compose then prompted to recreate volumes because the
            # restored compose's volume specs no longer matched the running
            # Docker volumes. Catastrophic.
            #
            # Now: explicit allowlist of user-populated paths under
            # config/hermes/opt/hermes/. Restore just overlays these onto
            # the target install. Install-specific files and release
            # artifacts come from the target install's own checkout.
            #
            # Paths captured (each is a relative directory under $src;
            # tar will skip those that don't exist on the source via
            # --ignore-failed-read):
            #   keys/        DKIM private keys, host signing keys
            #   .gnupg/      PGP keyrings for encryption
            #   ssl/         admin-uploaded SSL certificates + bundles
            #   templates/   custom amavis/disclaimer/signature templates
            #   sa-bayes/    SpamAssassin bayes corpus
            #   sa-learn/    SpamAssassin per-user training
            #   dkim/        DKIM tables + keys
            #   arc/         ARC keys + tables
            #   conf_files/  admin custom config snippets
            include_paths=()
            local user_data_subdir candidate
            for user_data_subdir in keys .gnupg ssl templates sa-bayes sa-learn dkim arc conf_files; do
                candidate="config/hermes/opt/hermes/${user_data_subdir}"
                if [[ -e "${src}/${candidate}" ]]; then
                    include_paths+=( "./${candidate}" )
                fi
            done
            # Let's Encrypt cert store (the ACME certs nginx serves). It lives
            # OUTSIDE opt/hermes, at config/certbot/conf/{live,archive,renewal},
            # and is gitignored -- so the backup is the ONLY way it reaches a new
            # box. Without it a cross-host restore lands with no ACME certs, and
            # the nginx vhost regen then emits cert paths that don't exist ->
            # nginx refuses to start. tar preserves the live/ -> ../../archive/
            # relative symlinks (no -h / --dereference), so certbot can still
            # renew after restore.
            if [[ -e "${src}/config/certbot/conf" ]]; then
                include_paths+=( "./config/certbot/conf" )
            fi
            if (( ${#include_paths[@]} == 0 )); then
                warn "  config: no user-data subdirs found under ${src}/config/hermes/opt/hermes/ -- writing empty archive."
                # Write an empty archive so restore + manifest still see the tier.
                tar -czf "$out" -T /dev/null 2>>"$LOG_FILE" || fatal "empty config tar failed"
                ARCHIVES_CREATED+=( "${tier}.tar.gz" )
                return 0
            fi
            log "  config: capturing user-data subdirs only: ${include_paths[*]#./}"
            ;;
        data)
            # DATA TIER == USER DATA ONLY (same architectural fix as config tier).
            #
            # Earlier versions captured everything under DATA_MOUNT minus
            # dbase / ldap/data / clamav. That still pulled in:
            #   - postfix_dkim/queue, logs    (transient + ~10GB of logs)
            #   - dovecot/logs, nginx/logs    (logs we don't need to restore)
            #   - mail_filter/data/amavis     (runtime state, regenerable)
            #   - mail_filter/data/fangfrisch (sig metadata, regenerable)
            #   - commandbox                  (Lucee runtime, regenerable)
            #   - ofelia                      (re-generated from DB)
            # Net result: a `-B system` backup that should have been ~1GB
            # was instead 14-20GB of mostly logs + transient state.
            #
            # Now: explicit allowlist of user-populated subdirs that aren't
            # already captured by mariadb-dump or slapcat. Paths that don't
            # exist on the source are skipped at construction time.
            #   dovecot/sieve/    User-defined sieve scripts (filters,
            #                     vacation auto-replies)
            #   authelia/         Authelia SQLite DB (only present on
            #                     installs that haven't migrated to the
            #                     MariaDB-backed authelia DB; canonical
            #                     post-#179 installs are on MariaDB)
            include_paths=()
            local data_user_subdir candidate
            for data_user_subdir in dovecot/sieve authelia; do
                candidate="${data_user_subdir}"
                if [[ -e "${src}/${candidate}" ]]; then
                    include_paths+=( "./${candidate}" )
                fi
            done
            if (( ${#include_paths[@]} == 0 )); then
                warn "  data: no user-data subdirs found under ${src} -- writing empty archive."
                tar -czf "$out" -T /dev/null 2>>"$LOG_FILE" || fatal "empty data tar failed"
                ARCHIVES_CREATED+=( "${tier}.tar.gz" )
                return 0
            fi
            log "  data: capturing user-data subdirs only: ${include_paths[*]#./}"
            ;;
    esac

    # tar exit codes: 0=success, 1=warnings only (sockets, "file changed as
    # we read it" -- expected on hot backup of a live system), 2+=real error.
    # The script previously fatal'd on ANY non-zero; that misclassified
    # successful hot backups as failures.
    local tar_exit=0
    start_heartbeat "${tier}: tar" "$out" 60
    tar -czf "$out" "${exclude_args[@]}" -C "$src" "${include_paths[@]}" 2>>"$LOG_FILE" || tar_exit=$?
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
    local m="${PARTIAL_DIR}/manifest.json"
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

    # A backup is a directory. While the run is in progress it has a
    # .staging- prefix so operators don't mistake an in-flight backup
    # for a complete one. On success we atomic-rename (same FS) to the
    # final name.
    FINAL_DIR="${BACKUP_PATH}/hermes-backup-${SCOPE}-${BUILD_NO}-${TIMESTAMP}"
    PARTIAL_DIR="${BACKUP_PATH}/.staging-hermes-backup-${SCOPE}-${BUILD_NO}-${TIMESTAMP}"
    [[ -e "$FINAL_DIR" || -e "$PARTIAL_DIR" ]] && \
        fatal "Target directory already exists (timestamp collision): ${FINAL_DIR}"

    if (( ! DRY_RUN )); then mkdir -p "$PARTIAL_DIR"; fi

    # Relocate the log from the bootstrap /tmp path to live INSIDE the
    # backup directory. The backup directory IS the self-contained backup
    # unit -- log travels with manifest + tars wherever the backup is moved.
    # Best-effort: if the rename fails (rare -- different filesystem with
    # no link/rename support), keep using the /tmp path so nothing is lost.
    local final_log="${PARTIAL_DIR}/backup.log"
    if (( ! DRY_RUN )) && mv "$LOG_FILE" "$final_log" 2>/dev/null; then
        LOG_FILE="$final_log"
    elif (( ! DRY_RUN )); then
        warn "Could not relocate log from ${LOG_FILE} to ${final_log} -- continuing with /tmp path."
    fi

    log "HERMES_ROOT:   ${HERMES_ROOT}"
    log "build_no:      ${BUILD_NO}"
    log "Scope:         ${SCOPE}"
    log "Mode:          $((( COLD_MODE )) && echo COLD || echo HOT)"
    log "Output dir:    ${FINAL_DIR}"
    log "Working dir:   ${PARTIAL_DIR}  (renamed to Output dir on success)"
    log "Log:           ${LOG_FILE}"
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

finalize_backup() {
    header "Finalizing backup (SHA256s + manifest + atomic rename)"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s would compute SHA256 + write manifest.json + rename %s -> %s\n' \
            "$CYAN" "$NC" "$PARTIAL_DIR" "$FINAL_DIR" | tee -a "$LOG_FILE"
        return 0
    fi
    # Compute SHA256 + size for each archive. The values land in the
    # manifest restore reads to verify integrity per-file before destructive
    # ops. No outer-tar wrapper, so a directory-level SHA isn't computed --
    # restore checks each inner archive instead.
    local a
    for a in "${ARCHIVES_CREATED[@]}"; do
        ARCHIVE_SHA[$a]="$(compute_sha256 "${PARTIAL_DIR}/${a}")"
        ARCHIVE_SIZE[$a]="$(stat -c%s "${PARTIAL_DIR}/${a}")"
    done
    emit_manifest

    # Backup log is currently being written INSIDE PARTIAL_DIR. About to
    # rename PARTIAL_DIR to FINAL_DIR -- update LOG_FILE so subsequent
    # log() calls keep writing to the same physical file at its new path.
    local new_log="${FINAL_DIR}/$(basename "$LOG_FILE")"
    mv "$PARTIAL_DIR" "$FINAL_DIR" \
        || fatal "Atomic rename failed: ${PARTIAL_DIR} -> ${FINAL_DIR}"
    LOG_FILE="$new_log"
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
    sz="$(du -sb "$FINAL_DIR" 2>/dev/null | cut -f1 | numfmt --to=iec --suffix=B 2>/dev/null || echo "?")"
    log "Backup written: ${FINAL_DIR}/"
    log "Scope:          ${SCOPE} (${ARCHIVES_CREATED[*]})"
    log "Total size:     ${sz}"
    log "Log:            ${LOG_FILE}"
    log ""
    log "Contents:"
    ls -lh "$FINAL_DIR" 2>/dev/null | awk 'NR>1 {printf "  %s  %s\n", $5, $9}' | tee -a "$LOG_FILE"
    log ""
    log "To restore:"
    log "  sudo ./scripts/system_restore.sh -F '${FINAL_DIR}'"
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
    finalize_backup
    restart_stack_if_cold
    report
    send_notification SUCCESS
}

main "$@"
