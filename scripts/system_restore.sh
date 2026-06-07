#!/usr/bin/env bash
# ============================================================================
# Hermes SEG Docker -- system restore
# ============================================================================
# Restores a backup DIRECTORY produced by scripts/system_backup.sh. The
# backup directory contains manifest.json + per-scope tar.gz files; -F
# points at the directory. No outer-tar extraction, no staging space.
#
# Reads manifest.json to learn the backup's scope, then for each archive:
#   1. Verifies SHA256 in-place against manifest values
#   2. Streams the archive directly to its destination (no intermediate)
#
# The stack is STOPPED for the duration of the restore (always cold on
# the restore side; we're overwriting live tier contents). Auto-remaps
# to this host's tier paths if backup topology differs.
#
# Reads the backup's scope from manifest.json and only restores what's in
# the backup -- so restoring a "vmail" backup overwrites just /mnt/vmail
# and leaves everything else alone.
# ============================================================================

set -uo pipefail

# ---- Self-locate HERMES_ROOT (walk up to find docker-compose.yml) ----
# Only docker-compose.yml is required as the sentinel; .git is intentionally
# NOT required (upload-deployed installs that bypass git clone have no .git
# at all). The restore script only needs to find .env and call docker
# compose, so docker-compose.yml alone is enough to identify the install root.
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

# Log lives in a temp file initially; preflight relocates it to the host's
# install-logs directory once HERMES_ROOT is known. We don't write into the
# backup directory -- the backup is read-only conceptually (operator may
# even mount it read-only) and may be a different mount than the host.
LOG_FILE="$(mktemp /tmp/hermes-restore-XXXXXX.log)"

# ---- Colors ----
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

log()   { printf '%s[%s]%s %s\n' "$GREEN" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s[%s] WARN:%s %s\n' "$YELLOW" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
error() { printf '%s[%s] ERROR:%s %s\n' "$RED" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE" >&2; }
fatal() { error "$@"; cleanup_on_fatal; exit 1; }
header(){ printf '\n%s== %s ==%s\n' "$CYAN" "$*" "$NC" | tee -a "$LOG_FILE"; }

# ---- Args ----
BACKUP_FILE=""
ASSUME_YES=0
DRY_RUN=0
SHOW_HELP=0

usage() {
    cat <<EOF
Usage: $(basename "$0") -F <backup-dir> [--yes] [--dry-run] [--help]

Hermes SEG Docker system restore.

Required:
  -F <path>      Path to a backup DIRECTORY produced by system_backup.sh
                 (i.e. a hermes-backup-<scope>-<build>-<ts>/ directory
                 containing manifest.json + per-scope tar.gz files).

Options:
  --yes          Skip the interactive confirmation prompt.
  --dry-run      Show what would be done without changing anything.
  --help         Show this help.

Disk space:
  ZERO scratch space required. Restore reads the backup directory in
  place: SHA256 verifies each archive, then streams each archive
  directly to its destination (mariadb pipe, slapadd pipe, tar -xzf
  into TIER_PATH). No outer-tar extract, no staging dir, no copies.
  Backup share can be read-only (CIFS -o ro is fine).

Environment:
  FORCE_VERSION_MISMATCH=1
                 Required if the backup's Hermes build_no does NOT match
                 this host's current build_no. Schema migrations between
                 builds make restore unsafe by default. Override only if
                 you understand the schema risk -- the documented
                 procedure is to install Hermes at the matching build
                 first, restore, then upgrade forward with
                 system_update_docker.sh.

The stack is STOPPED for the duration of the restore. All data in the
backup's scope is REPLACED on this host. Other scopes are left alone:
restoring a "vmail" backup only touches /mnt/vmail; restoring an
"archive" backup only touches /mnt/archive; etc.

Disaster-recovery flow (different host):
  1. Install Hermes fresh on the new host (install root + .env exist).
  2. Mount your backup storage on the new host so the backup directory
     is reachable directly. Restore reads the backup in-place -- no
     copy, no extraction, no scratch space. Read-only mount is fine.
     Example:
         sudo mount -t cifs //backup-host/share /mnt/backups \
             -o credentials=/root/.smbcreds,ro
  3. sudo $(basename "$0") -F /mnt/backups/hermes-backup-system-vXXXXXX-TS/
  4. After restore completes, if the new host's IP/hostname differs from
     the backup's, run scripts/system_rehost.sh to rewire identity.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -F)                 BACKUP_FILE="$2"; shift 2 ;;
        --yes|-y)           ASSUME_YES=1; shift ;;
        --dry-run|-n)       DRY_RUN=1; shift ;;
        --help|-h)          SHOW_HELP=1; shift ;;
        *)                  error "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

if (( SHOW_HELP )); then usage; exit 0; fi
if [[ -z "$BACKUP_FILE" ]]; then error "Required flag -F missing."; usage; exit 1; fi
if [[ ! -d "$BACKUP_FILE" ]]; then error "Backup directory not found: ${BACKUP_FILE}"; exit 1; fi
# Strip trailing slash so paths concat cleanly
BACKUP_FILE="${BACKUP_FILE%/}"
if [[ $EUID -ne 0 ]] && (( ! DRY_RUN )); then fatal "Must run as root (live mode)."; fi

# ---- Constants ----
DATABASES=( hermes authelia opendmarc Syslog djigzo nextcloud )
TIERS=( config data archive vmail nextcloud )
LDAP_SUFFIX="dc=hermes,dc=local"

declare -A TIER_PATH       # current host's tier paths
declare -A BK_TIER_PATH    # backup's tier paths (from manifest)
declare -a BK_ARCHIVES     # archives actually present in the backup

STACK_STOPPED=0

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
    if (( STACK_STOPPED )) && (( ! DRY_RUN )); then
        warn "Attempting to restart stack after failure..."
        ( cd "$HERMES_ROOT" && docker compose up -d ) >>"$LOG_FILE" 2>&1 || true
    fi
    # Restore writes nothing to a staging area in the directory-style format
    # (everything streams from BACKUP_FILE directly to destinations). The
    # mid-op state we DO leave behind is partial extraction at TIER_PATH
    # destinations -- those can only be cleaned by the operator (re-run
    # restore overwrites them, or wipe + reinstall). Documented in --help.
}

confirm() {
    if (( ASSUME_YES )) || (( DRY_RUN )); then return 0; fi
    read -r -p "$1 [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

load_current_mounts() {
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
}

parse_manifest() {
    local m="${BACKUP_FILE}/manifest.json"
    [[ -f "$m" ]] || fatal "Backup is missing manifest.json -- not a valid Hermes backup."

    local get_string
    get_string() {
        grep -oE "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]+\"" "$m" \
            | head -1 | sed 's/.*"\([^"]*\)"$/\1/'
    }

    BK_BUILD_NO="$(get_string build_no)"
    BK_SCOPE="$(get_string scope)"
    BK_MODE="$(get_string mode)"
    BK_TIMESTAMP="$(get_string timestamp)"
    BK_HOSTNAME="$(get_string hostname)"
    BK_TIER_PATH[config]="$(get_string config_path)"
    BK_TIER_PATH[data]="$(get_string data_mount)"
    BK_TIER_PATH[archive]="$(get_string archive_mount)"
    BK_TIER_PATH[vmail]="$(get_string vmail_mount)"
    BK_TIER_PATH[nextcloud]="$(get_string files_mount)"

    [[ -n "$BK_BUILD_NO" ]] || fatal "Manifest missing build_no field."
    [[ -n "$BK_SCOPE" ]]    || fatal "Manifest missing scope field."

    # Extract the list of archives present in the backup. They appear as
    # keys inside the "archives" block.
    mapfile -t BK_ARCHIVES < <(grep -oE '"[^"]+\.(tar\.gz|ldif\.gz)"[[:space:]]*:[[:space:]]*\{' "$m" \
        | sed 's/^"\([^"]*\)".*/\1/' | sort -u)
    (( ${#BK_ARCHIVES[@]} > 0 )) || fatal "Manifest 'archives' block is empty."
}

bk_has_archive() {
    local target="$1"
    local a
    for a in "${BK_ARCHIVES[@]}"; do
        [[ "$a" == "$target" ]] && return 0
    done
    return 1
}

verify_archive_sha() {
    local archive="$1"
    local expected
    expected="$(grep -oE "\"${archive}\"[[:space:]]*:[[:space:]]*\\{[^}]+\\}" "${BACKUP_FILE}/manifest.json" \
        | grep -oE '"sha256"[[:space:]]*:[[:space:]]*"[^"]+"' \
        | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"
    [[ -n "$expected" ]] || fatal "Manifest missing SHA256 for ${archive}"
    local actual
    actual="$(sha256sum "${BACKUP_FILE}/${archive}" | awk '{print $1}')"
    if [[ "$actual" != "$expected" ]]; then
        fatal "SHA256 mismatch for ${archive}: manifest=${expected} actual=${actual}. Backup is corrupt."
    fi
    log "  ${archive}: SHA256 ✓"
}

wait_for_container() {
    local name="$1"
    local cmd="$2"
    local i
    for i in {1..30}; do
        if eval "$cmd" >/dev/null 2>&1; then return 0; fi
        sleep 2
    done
    fatal "${name} did not become ready within 60s."
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
            # No-password path (canonical / unix_socket-style)
            exec mariadb -u root "$@"
        elif [[ -r /run/secrets/MYSQL_ROOT_PASSWORD ]]; then
            # Password-from-secret path (older installs with native_password root)
            MYSQL_PWD="$(cat /run/secrets/MYSQL_ROOT_PASSWORD)" exec mariadb -u root "$@"
        else
            # Last resort -- no auth options left; let mariadb error meaningfully
            exec mariadb -u root "$@"
        fi
    ' bash "$@"
}

# ---- Phases ----
preflight() {
    header "Preflight"
    if (( ! DRY_RUN )); then
        command -v docker >/dev/null 2>&1 || fatal "docker not in PATH"
        command -v rsync >/dev/null 2>&1 || fatal "rsync not in PATH"
        docker compose version >/dev/null 2>&1 || fatal "docker compose v2 not available"
    fi
    load_current_mounts

    # Relocate the log from /tmp to the host's install-logs directory so
    # operators have it in a known place (matches install_hermes_docker.sh
    # convention). The backup directory may be a read-only mount we
    # shouldn't write into; the host install-logs is always writable.
    local log_dir="${HERMES_ROOT}/install-logs"
    mkdir -p "$log_dir" 2>/dev/null || true
    local final_log="${log_dir}/system_restore_$(date '+%Y%m%d_%H%M%S').log"
    if mv "$LOG_FILE" "$final_log" 2>/dev/null; then
        LOG_FILE="$final_log"
    else
        warn "Could not relocate log from ${LOG_FILE} to ${final_log} -- continuing with /tmp path."
    fi

    log "HERMES_ROOT:   ${HERMES_ROOT}"
    log "Backup dir:    ${BACKUP_FILE}"
    log "Log:           ${LOG_FILE}"
}

verify_backup() {
    header "Verifying backup"
    # The backup is a directory containing manifest.json + per-scope
    # tar.gz files. No outer tar to extract, no staging dir to create --
    # we read manifest in place + verify SHA256 of each archive in place.
    # Zero scratch space required.
    [[ -d "$BACKUP_FILE" ]] || fatal "Backup path is not a directory: ${BACKUP_FILE}"
    [[ -f "${BACKUP_FILE}/manifest.json" ]] || \
        fatal "Backup directory has no manifest.json: ${BACKUP_FILE}"

    parse_manifest

    log "Backup metadata:"
    log "  build_no:   ${BK_BUILD_NO}"
    log "  scope:      ${BK_SCOPE}"
    log "  mode:       ${BK_MODE}"
    log "  timestamp:  ${BK_TIMESTAMP}"
    log "  hostname:   ${BK_HOSTNAME}"
    log "  archives:   ${BK_ARCHIVES[*]}"

    if (( DRY_RUN )); then
        printf '%s[dry-run]%s would sha256sum each archive in %s against manifest\n' \
            "$CYAN" "$NC" "$BACKUP_FILE" | tee -a "$LOG_FILE"
        return 0
    fi

    log "Verifying SHA256 of archives in place (no extraction)..."
    local a
    for a in "${BK_ARCHIVES[@]}"; do verify_archive_sha "$a"; done
}

check_version_match() {
    header "Version match check"
    # Reads build_no from the current host's system_settings table. If the
    # backup was taken on a different build, refuse unless FORCE_VERSION_MISMATCH=1.
    # Version-mismatch is the ONE gate that does require an explicit override
    # (FORCE_VERSION_MISMATCH=1) -- topology mismatch auto-remaps, but
    # version mismatch can silently corrupt DBs via schema drift.
    #
    # Why: schema migrations between Hermes releases can change tables, so a DB
    # dump from build X restored onto a host running build Y leaves the schema
    # in a state the running code doesn't expect -- breaks silently, hours later,
    # when something hits a missing column. Hard-refusing upfront is the right
    # default; the operator can override for legitimate cross-version cases
    # (e.g., extracting old vmail files from an older backup without touching
    # the DB).
    if ! docker ps --format '{{.Names}}' | grep -q '^hermes_db_server$'; then
        warn "hermes_db_server not running -- starting briefly to read current build_no..."
        ( cd "$HERMES_ROOT" && docker compose start hermes_db_server ) >>"$LOG_FILE" 2>&1
        sleep 4
    fi
    local current_build
    current_build="$(db_exec -N -s hermes -e "SELECT value FROM system_settings WHERE parameter='build_no';" 2>>"$LOG_FILE" | tr -d '[:space:]')"
    if [[ -z "$current_build" ]]; then
        warn "Could not read current build_no from system_settings -- proceeding without version check."
        warn "If this is a fresh install or a partially-initialized host, that's expected."
        return 0
    fi
    if [[ "$BK_BUILD_NO" == "$current_build" ]]; then
        log "  Version match: ${current_build} ✓"
        return 0
    fi
    if [[ "${FORCE_VERSION_MISMATCH:-0}" == "1" ]]; then
        warn "Version mismatch: backup=${BK_BUILD_NO}, current host=${current_build}"
        warn "FORCE_VERSION_MISMATCH=1 -- proceeding. Restored DBs may be incompatible with running code."
        warn "Schema-sensitive paths (admin UI queries, mail-flow handlers, etc.) may fail unpredictably"
        warn "until you complete a 'system_update_docker.sh' run to migrate the schema forward."
        return 0
    fi
    error "Version mismatch: backup build=${BK_BUILD_NO}, current host build=${current_build}."
    error "Schema migrations between these versions make restore unsafe."
    error ""
    error "Correct procedure (matches the legacy methodology):"
    error "  1. Install Hermes at the SAME build as the backup (${BK_BUILD_NO})"
    error "     git checkout ${BK_BUILD_NO} && docker compose up -d"
    error "  2. Re-run this restore -- version match, restore proceeds."
    error "  3. After restore verified, upgrade forward with"
    error "     scripts/system_update_docker.sh"
    error ""
    error "To restore anyway and accept the schema-mismatch risk:"
    error "  FORCE_VERSION_MISMATCH=1 $0 -F ${BACKUP_FILE}"
    fatal "Refusing to restore on version mismatch without explicit FORCE_VERSION_MISMATCH=1."
}

check_topology() {
    header "Topology check"
    # Auto-remap by default: rsync always targets the CURRENT host's tier
    # paths regardless. Topology mismatch is the EXPECTED case for any
    # new-hardware DR -- requiring an explicit FORCE_REMAP flag was friction
    # without safety benefit. The destructive confirmation prompt already
    # shows which paths data lands at, --yes already requires explicit
    # operator opt-in, and version-match catches "wrong backup" scenarios.
    local mismatch=0
    local t
    for t in "${TIERS[@]}"; do
        # Only check tiers the backup actually included
        if [[ "$t" == "config" ]] && ! bk_has_archive "config.tar.gz"; then continue; fi
        if [[ "$t" == "data" ]]    && ! bk_has_archive "data.tar.gz";    then continue; fi
        if [[ "$t" == "archive" ]] && ! bk_has_archive "archive.tar.gz"; then continue; fi
        if [[ "$t" == "vmail" ]]   && ! bk_has_archive "vmail.tar.gz";   then continue; fi
        if [[ "$t" == "nextcloud" ]] && ! bk_has_archive "nextcloud.tar.gz"; then continue; fi
        if [[ "${BK_TIER_PATH[$t]}" != "${TIER_PATH[$t]}" ]]; then
            warn "  ${t}: REMAP backup=${BK_TIER_PATH[$t]} -> current=${TIER_PATH[$t]}"
            mismatch=1
        else
            log "  ${t}: ${TIER_PATH[$t]} ✓"
        fi
    done
    if (( mismatch )); then
        warn ""
        warn "Auto-remap active: data will be restored to this host's tier paths"
        warn "(shown above), not the backup's original paths. This is the normal"
        warn "behavior for restoring on different hardware."
    fi
}

confirm_destructive() {
    header "Confirm"
    log ""
    log "This will REPLACE the following on this host:"
    bk_has_archive "databases.tar.gz" && log "  - All 6 databases (hermes, authelia, nextcloud, djigzo, opendmarc, Syslog)"
    bk_has_archive "ldap.ldif.gz"     && log "  - OpenLDAP directory (${LDAP_SUFFIX})"
    bk_has_archive "config.tar.gz"    && log "  - Install root (repo working tree, secrets, .env)"
    bk_has_archive "data.tar.gz"      && log "  - Data tier (${TIER_PATH[data]}; mysql/ ldap/ clamav/ preserved)"
    bk_has_archive "archive.tar.gz"   && log "  - Archive tier (${TIER_PATH[archive]})"
    bk_has_archive "vmail.tar.gz"     && log "  - Vmail tier (${TIER_PATH[vmail]})"
    bk_has_archive "nextcloud.tar.gz" && log "  - Nextcloud tier (${TIER_PATH[nextcloud]})"
    log ""
    log "The stack will be STOPPED for the duration of the restore."
    log ""
    if ! confirm "Proceed with restore?"; then
        log "Aborted by operator."
        exit 0
    fi
}

stop_stack() {
    header "Stopping stack"
    run bash -c "cd '$HERMES_ROOT' && docker compose stop"
    STACK_STOPPED=1
}

restore_databases() {
    bk_has_archive "databases.tar.gz" || return 0
    header "Restoring databases"
    log "Starting hermes_db_server briefly..."
    run bash -c "cd '$HERMES_ROOT' && docker compose start hermes_db_server"
    if (( ! DRY_RUN )); then
        wait_for_container hermes_db_server "db_exec -e 'SELECT 1'"
    fi

    local db
    for db in "${DATABASES[@]}"; do
        log "  restoring ${db}..."
        if (( DRY_RUN )); then
            printf '%s[dry-run]%s drop+restore database %s (streamed from %s)\n' \
                "$CYAN" "$NC" "$db" "${BACKUP_FILE}/databases.tar.gz" | tee -a "$LOG_FILE"
            continue
        fi
        db_exec -e "DROP DATABASE IF EXISTS \`${db}\`;" 2>>"$LOG_FILE" \
            || fatal "Failed to drop ${db}."
        # Stream the .sql DIRECTLY out of databases.tar.gz into mariadb.
        # tar -xzOf extracts to stdout, piped into db_exec -i (which reads
        # stdin). No on-disk extraction, no scratch space. Verify that the
        # archive contains the expected member before streaming.
        if ! tar -tzf "${BACKUP_FILE}/databases.tar.gz" "./${db}.sql" >/dev/null 2>&1; then
            fatal "Missing ./${db}.sql in databases.tar.gz."
        fi
        # Heartbeat without watch_file -- mariadb's on-disk datadir location
        # varies by install (host bind vs Docker named volume), so just
        # emit elapsed-time ticks so the operator sees the restore is alive
        # during long INSERTs on big tables (e.g. msgs, SystemEvents).
        start_heartbeat "${db}: restoring" "" 60
        tar -xzOf "${BACKUP_FILE}/databases.tar.gz" "./${db}.sql" \
            | db_exec -i 2>>"$LOG_FILE" \
            || { stop_heartbeat; fatal "Failed to restore ${db}."; }
        stop_heartbeat
    done
    db_exec -e "FLUSH PRIVILEGES;" 2>>"$LOG_FILE" || true

    log "Stopping hermes_db_server..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop hermes_db_server"
}

restore_ldap() {
    bk_has_archive "ldap.ldif.gz" || return 0
    header "Restoring OpenLDAP directory"
    log "Starting hermes_ldap briefly..."
    run bash -c "cd '$HERMES_ROOT' && docker compose start hermes_ldap"
    if (( ! DRY_RUN )); then sleep 4; fi

    if (( DRY_RUN )); then
        printf '%s[dry-run]%s stop hermes_ldap, run slapadd via one-shot container (wipe DB + load %s), start hermes_ldap\n' \
            "$CYAN" "$NC" "$LDAP_SUFFIX" | tee -a "$LOG_FILE"
    else
        # The Hermes OpenLDAP container runs slapd as PID 1 -- pkill'ing
        # slapd just kills the container (Docker restart policy then spins
        # it back up). So we have to STOP the container properly, then run
        # slapadd via a one-shot container that mounts the same volumes but
        # uses slapadd as its entrypoint (not slapd). After slapadd
        # finishes, start the original container.
        #
        # slapadd ALSO requires the DB directory to be empty -- it only
        # ADDs entries, won't overwrite. Fresh installs bootstrap the
        # dc=hermes,dc=local root entry, which conflicts. So the one-shot
        # container wipes the DB dir before slapadd. The DB directory path
        # is read from olcDbDirectory in the slapd config (slapadd-internal
        # path; varies between custom builds and distro packages).
        log "  stopping hermes_ldap container fully (slapd is PID 1; container exits)..."
        run bash -c "cd '$HERMES_ROOT' && docker compose stop hermes_ldap"
        sleep 2

        log "  running one-shot wipe + slapadd container..."
        start_heartbeat "slapadd: wipe + load LDIF" "" 60
        # NB: We capture stderr to the log so failure surfaces clearly.
        # sh -c chain: read DB dir from olcDbDirectory, wipe its contents,
        # run slapadd reading LDIF from stdin.
        gunzip -c "${BACKUP_FILE}/ldap.ldif.gz" | ( \
            cd "$HERMES_ROOT" && \
            docker compose run --rm -i --entrypoint sh hermes_ldap -c '
                DB_DIR=$(grep -h "olcDbDirectory" /etc/ldap/slapd.d/cn=config/olcDatabase=*.ldif 2>/dev/null \
                         | head -1 | cut -d: -f2- | tr -d " ")
                if [ -z "$DB_DIR" ] || [ ! -d "$DB_DIR" ]; then
                    echo "ERROR: could not determine LDAP DB directory from olcDbDirectory" >&2
                    exit 1
                fi
                echo "Wiping ${DB_DIR}/* before slapadd..." >&2
                rm -rf "${DB_DIR}"/* 2>/dev/null || true
                slapadd -F /etc/ldap/slapd.d -b "'"$LDAP_SUFFIX"'"
            ' 2>>"$LOG_FILE" \
        ) || { stop_heartbeat; fatal "slapadd via one-shot container failed -- check ${LOG_FILE} for the wipe / slapadd error."; }
        stop_heartbeat

        log "  starting hermes_ldap container with restored DB..."
        run bash -c "cd '$HERMES_ROOT' && docker compose start hermes_ldap"
        sleep 4
    fi

    log "Stopping hermes_ldap..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop hermes_ldap"
}

restore_tier() {
    local tier="$1"
    local archive="${tier}.tar.gz"
    bk_has_archive "$archive" || return 0

    local src_archive="${BACKUP_FILE}/${archive}"
    local dest="${TIER_PATH[$tier]}"

    log "  ${tier}: extract directly to ${dest}"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -xzf %s -C %s\n' "$CYAN" "$NC" "$src_archive" "$dest" | tee -a "$LOG_FILE"
        return 0
    fi

    mkdir -p "$dest"

    # Stream-extract the tier tar DIRECTLY from the backup directory to its
    # final destination. No scratch space anywhere -- tar -xzf reads from
    # the backup share, writes to TIER_PATH[$tier]. The legacy non-Docker
    # system_restore.sh worked this way (tar -xf to root); we kept the same
    # shape, just per-tier instead of monolithic.
    #
    # Trade-off: no --delete semantics. Files that exist at DEST but weren't
    # in the backup (e.g. mail received after the backup was taken, or
    # leftovers from a prior install) will SURVIVE the restore. For DR onto
    # a fresh install: no impact (DEST is empty). For "restore-over-existing"
    # scenarios: orphan files persist; clean manually if it matters.
    #
    # Preserved on DEST without explicit handling:
    #   - dbase/, ldap/data/, mail_filter/data/clamav/ in the data tier
    #     (backup excludes them; tar -x can't delete what it doesn't see)
    #   - install-logs/, .git/ in the config tier (same rationale)
    start_heartbeat "${tier}: extract" "" 60
    tar -xzf "$src_archive" -C "$dest" 2>>"$LOG_FILE" \
        || { stop_heartbeat; fatal "Failed to extract ${archive} to ${dest}."; }
    stop_heartbeat
}

restore_tiers() {
    header "Restoring in-scope storage tiers"
    local t
    for t in "${TIERS[@]}"; do restore_tier "$t"; done
}

ensure_scripts_executable() {
    # Defensive chmod +x on every .sh in the repo. tar/rsync restore can
    # strip the executable bit depending on the source filesystem and the
    # tar/rsync flags used. cfexecute on a non-executable script throws an
    # exception that surfaces in the admin UI as
    # "There was an error executing /opt/hermes/scripts/...".
    # Run after restore_config completes (it rsyncs over the repo's
    # config/hermes/opt/hermes/scripts/ tree) and before stack restart.
    header "Ensuring .sh files are executable"
    local count
    count=$(find "$HERMES_ROOT" -name '*.sh' -type f ! -perm -u+x \
            -not -path '*/.git/*' 2>/dev/null | wc -l)
    if (( count > 0 )); then
        find "$HERMES_ROOT" -name '*.sh' -type f ! -perm -u+x \
            -not -path '*/.git/*' -exec chmod +x {} + 2>>"$LOG_FILE"
        log "  +x applied to ${count} .sh file(s)"
    else
        log "  all .sh files already executable"
    fi
}

restart_stack() {
    header "Restarting stack"
    run bash -c "cd '$HERMES_ROOT' && docker compose up -d"
    STACK_STOPPED=0
    if (( DRY_RUN )); then return 0; fi
    local i
    for i in {1..30}; do
        if docker exec hermes_commandbox curl -sf --max-time 2 http://localhost:8888/ >/dev/null 2>&1; then
            log "  hermes_commandbox responding ✓"
            break
        fi
        sleep 2
    done
}

post_restore_nc_maintenance_off() {
    bk_has_archive "nextcloud.tar.gz" || return 0
    header "Post-restore: clear Nextcloud maintenance mode"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s occ maintenance:mode --off\n' "$CYAN" "$NC" | tee -a "$LOG_FILE"
        return 0
    fi
    local i
    for i in {1..30}; do
        if docker exec hermes_nextcloud true 2>/dev/null; then break; fi
        sleep 2
    done
    docker exec -u www-data hermes_nextcloud php /var/www/html/occ maintenance:mode --off >>"$LOG_FILE" 2>&1 \
        || warn "occ maintenance:mode --off failed -- the operator should run it manually."
}

detect_host_identity_mismatch() {
    # After restore, the restored .env carries the OLD host's IP / hostname.
    # If this host has a different identity, the restored config makes the
    # system unreachable -- nginx server_name, Authelia cookie domain,
    # Postfix HELO etc. all reference the wrong host. Detect + warn so the
    # operator knows to run system_rehost.sh.
    #
    # Returns 0 if mismatch detected, 1 if no mismatch (or detection failed).
    [[ -f "${HERMES_ROOT}/.env" ]] || return 1
    local restored_ip current_ip
    restored_ip=$(grep -E '^HOST_IP=' "${HERMES_ROOT}/.env" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'")
    current_ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')
    [[ -z "$restored_ip" || -z "$current_ip" ]] && return 1
    [[ "$restored_ip" != "$current_ip" ]]
}

report() {
    header "Done"
    if (( DRY_RUN )); then
        log "Dry-run complete. Nothing was changed."
        return 0
    fi
    log "Restore complete from: ${BACKUP_FILE}"
    log "Scope restored:        ${BK_SCOPE} (${BK_ARCHIVES[*]})"
    log "Log:                   ${LOG_FILE}"
    log ""

    if detect_host_identity_mismatch; then
        local restored_ip current_ip
        restored_ip=$(grep -E '^HOST_IP=' "${HERMES_ROOT}/.env" | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'")
        current_ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')
        warn "================================================================"
        warn "  HOST IDENTITY MISMATCH DETECTED"
        warn "================================================================"
        warn "  Restored .env HOST_IP = ${restored_ip}"
        warn "  This host's IP        = ${current_ip}"
        warn ""
        warn "  The restored config references the old host. nginx, Authelia,"
        warn "  Postfix, and Nextcloud are now configured for ${restored_ip} --"
        warn "  the admin console will be UNREACHABLE at ${current_ip} until you"
        warn "  rewire the host identity. Run:"
        warn ""
        warn "    sudo ${HERMES_ROOT}/scripts/system_rehost.sh"
        warn ""
        warn "  system_rehost.sh auto-detects this host's IP/hostname and"
        warn "  rewires .env, DB rows, nginx, Authelia, Postfix, and"
        warn "  Nextcloud in one step. See --help for non-default targets."
        warn "================================================================"
        return 0
    fi

    log "Next steps:"
    log "  1. Verify you can log into the admin console (https://<console-host>/admin/)"
    log "  2. Verify mail flow (send + receive a test message)"
    log "  3. If something looks off, check ${LOG_FILE} for warnings."
}

main() {
    log "Hermes SEG system restore"
    log "Mode: $((( DRY_RUN )) && echo DRY-RUN || echo LIVE)"
    preflight
    verify_backup
    check_version_match
    check_topology
    confirm_destructive
    stop_stack
    restore_databases
    restore_ldap
    restore_tiers
    ensure_scripts_executable
    restart_stack
    post_restore_nc_maintenance_off
    report
}

main "$@"
