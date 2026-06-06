#!/usr/bin/env bash
# ============================================================================
# Hermes SEG Docker -- system restore
# ============================================================================
# Restores a backup tarball produced by scripts/system_backup.sh. Verifies
# the manifest + per-archive SHA256 BEFORE any destructive action, refuses
# with auto-remap to the current host's tier paths if topology differs, stops the stack for
# the duration of the restore (always cold on the restore side because we
# are overwriting tier contents), restores databases via socket auth +
# `mariadb -u root`, restores OpenLDAP via slapadd, rsyncs each in-scope
# tier from staging with --delete, restarts the stack.
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

# Log lives in a temp file until preflight knows where the backup file is;
# then it's moved to live alongside the backup with a matching filename
# (same prefix, .restore.log extension so it doesn't collide with the
# backup's own creation-time log). Operator postmortems from a remote share
# see both the backup-time log and the restore-time log next to each other.
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
STAGING_DIR_OVERRIDE=""
ASSUME_YES=0
DRY_RUN=0
SHOW_HELP=0

usage() {
    cat <<EOF
Usage: $(basename "$0") -F <backup.tar> [--staging-dir=PATH] [--yes] [--dry-run] [--help]

Hermes SEG Docker system restore.

Required:
  -F <path>      Path to the backup tarball produced by system_backup.sh.

Options:
  --staging-dir=PATH   Where to extract the outer + tier tars during restore.
                       Defaults to the backup file's parent directory (where
                       there is by definition enough space, since the backup
                       itself lives there). Override when:
                         - the backup file is on a read-only mount
                         - you have fast local scratch and want better perf
                           than extracting over CIFS/NFS
                       Must have at least ~2x the backup size free.
  --yes          Skip the interactive confirmation prompt.
  --dry-run      Show what would be done without changing anything.
  --help         Show this help.

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
  2. scp the backup tarball from offsite storage.
  3. sudo $(basename "$0") -F /path/to/backup.tar
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -F)                 BACKUP_FILE="$2"; shift 2 ;;
        --staging-dir=*)    STAGING_DIR_OVERRIDE="${1#*=}"; shift ;;
        --yes|-y)           ASSUME_YES=1; shift ;;
        --dry-run|-n)       DRY_RUN=1; shift ;;
        --help|-h)          SHOW_HELP=1; shift ;;
        *)                  error "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

if (( SHOW_HELP )); then usage; exit 0; fi
if [[ -z "$BACKUP_FILE" ]]; then error "Required flag -F missing."; usage; exit 1; fi
if [[ ! -f "$BACKUP_FILE" ]]; then error "Backup file not found: ${BACKUP_FILE}"; exit 1; fi
if [[ $EUID -ne 0 ]] && (( ! DRY_RUN )); then fatal "Must run as root (live mode)."; fi

# ---- Constants ----
DATABASES=( hermes authelia opendmarc Syslog djigzo nextcloud )
TIERS=( config data archive vmail nextcloud )
LDAP_SUFFIX="dc=hermes,dc=local"

declare -A TIER_PATH       # current host's tier paths
declare -A BK_TIER_PATH    # backup's tier paths (from manifest)
declare -a BK_ARCHIVES     # archives actually present in the backup

STAGE_DIR=""
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
    if [[ -d "${STAGE_DIR:-}" ]]; then
        warn "Staging directory left at ${STAGE_DIR} for inspection."
    fi
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
    local m="${STAGE_DIR}/backup_manifest.json"
    [[ -f "$m" ]] || fatal "Backup is missing backup_manifest.json -- not a valid Hermes backup."

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
    expected="$(grep -oE "\"${archive}\"[[:space:]]*:[[:space:]]*\\{[^}]+\\}" "${STAGE_DIR}/backup_manifest.json" \
        | grep -oE '"sha256"[[:space:]]*:[[:space:]]*"[^"]+"' \
        | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"
    [[ -n "$expected" ]] || fatal "Manifest missing SHA256 for ${archive}"
    local actual
    actual="$(sha256sum "${STAGE_DIR}/${archive}" | awk '{print $1}')"
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

# ---- Phases ----
preflight() {
    header "Preflight"
    if (( ! DRY_RUN )); then
        command -v docker >/dev/null 2>&1 || fatal "docker not in PATH"
        command -v rsync >/dev/null 2>&1 || fatal "rsync not in PATH"
        docker compose version >/dev/null 2>&1 || fatal "docker compose v2 not available"
    fi
    load_current_mounts

    # Relocate the log from the bootstrap /tmp path to live alongside the
    # backup file. Uses .restore.log so it doesn't collide with the backup
    # script's own creation-time .log file. Best-effort: keep /tmp path
    # if the rename fails (different filesystem etc.).
    local final_log="${BACKUP_FILE%.tar}.restore.log"
    if mv "$LOG_FILE" "$final_log" 2>/dev/null; then
        LOG_FILE="$final_log"
    else
        warn "Could not relocate log from ${LOG_FILE} to ${final_log} -- continuing with /tmp path."
    fi

    log "HERMES_ROOT:   ${HERMES_ROOT}"
    log "Backup file:   ${BACKUP_FILE}"
    log "Log:           ${LOG_FILE}"
}

extract_and_verify() {
    header "Extracting backup + verifying manifest"
    # Default staging location: same directory as the backup file. The
    # backup itself lives there, so by definition there's at least enough
    # space to hold its uncompressed extract (and likely more, since the
    # backup landed there from elsewhere). Operator can override with
    # --staging-dir=PATH for read-only mounts or to use faster local
    # scratch.
    #
    # /tmp was the prior default but it's typically root FS (~50-100GB) --
    # a 2TB backup would fill root and brick the host mid-restore.
    local staging_parent
    if [[ -n "$STAGING_DIR_OVERRIDE" ]]; then
        staging_parent="$STAGING_DIR_OVERRIDE"
        [[ -d "$staging_parent" ]] || fatal "--staging-dir does not exist: ${staging_parent}"
        [[ -w "$staging_parent" ]] || fatal "--staging-dir is not writable: ${staging_parent}"
    else
        staging_parent="$(dirname "$BACKUP_FILE")"
        if [[ ! -w "$staging_parent" ]]; then
            fatal "Default staging dir (${staging_parent}) is not writable. Use --staging-dir=PATH to point elsewhere."
        fi
    fi
    STAGE_DIR="$(mktemp -d -p "$staging_parent" hermes-restore-XXXXXX)" \
        || fatal "Failed to create staging dir under ${staging_parent}"
    log "Staging dir: ${STAGE_DIR}"

    # Disk-space warning + sanity check. The staging directory will hold:
    #   1. The extracted outer tar (= backup file size, since the outer
    #      tar is uncompressed -cf, not -czf -- its contents are already
    #      gzip'd inner archives)
    #   2. Per-tier extracts (each inner tier.tar.gz expanded into
    #      extracted_<tier>/ -- raw uncompressed data, can be 2-3x the
    #      gzip'd size on top of the outer-tar extract from step 1)
    # Rough estimate: peak usage = backup_size + sum(uncompressed_tier_sizes)
    # which can easily be 3-4x the .tar size for data-heavy backups.
    local backup_size_bytes backup_size_h required_bytes required_h avail_bytes avail_h fs_label
    backup_size_bytes=$(stat -c%s "$BACKUP_FILE" 2>/dev/null || echo 0)
    backup_size_h=$(numfmt --to=iec "$backup_size_bytes" 2>/dev/null || echo "?")
    # Conservative multiplier: 3x backup size as the safe required estimate
    required_bytes=$(( backup_size_bytes * 3 ))
    required_h=$(numfmt --to=iec "$required_bytes" 2>/dev/null || echo "?")
    avail_bytes=$(df --output=avail -B1 "$staging_parent" 2>/dev/null | tail -1 | tr -d ' ')
    avail_h=$(numfmt --to=iec "${avail_bytes:-0}" 2>/dev/null || echo "?")
    fs_label=$(df --output=target "$staging_parent" 2>/dev/null | tail -1)

    echo "" | tee -a "$LOG_FILE"
    warn "================================================================"
    warn "  DISK SPACE WARNING"
    warn "================================================================"
    warn "  Restore extracts the backup to a staging directory BEFORE"
    warn "  rsync'ing data to the final tier paths. Peak disk use during"
    warn "  restore is roughly 3x the backup size (outer tar extract +"
    warn "  per-tier uncompressed extracts running in sequence)."
    warn ""
    warn "  Backup file size:     ${backup_size_h}"
    warn "  Estimated required:   ${required_h}  (3x backup, conservative)"
    warn "  Staging filesystem:   ${fs_label:-${staging_parent}}"
    warn "  Available space:      ${avail_h}"
    warn ""
    if (( avail_bytes < required_bytes )); then
        warn "  *** INSUFFICIENT SPACE -- restore will likely fail mid-extract. ***"
        warn ""
        warn "  Options:"
        warn "    - Free space on ${fs_label:-${staging_parent}} and retry"
        warn "    - Point staging elsewhere with --staging-dir=PATH"
        warn "      (must have at least ${required_h} free)"
        warn "================================================================"
        fatal "Aborting before extraction. Free space or use --staging-dir."
    fi
    warn "  Looks OK. Proceeding."
    warn "================================================================"
    echo "" | tee -a "$LOG_FILE"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -xf %s -C %s\n' "$CYAN" "$NC" "$BACKUP_FILE" "$STAGE_DIR" | tee -a "$LOG_FILE"
        return 0
    fi
    start_heartbeat "extract outer tar" "" 60
    tar -xf "$BACKUP_FILE" -C "$STAGE_DIR" 2>>"$LOG_FILE" \
        || { stop_heartbeat; fatal "Failed to extract outer tarball."; }
    stop_heartbeat

    parse_manifest

    log "Backup metadata:"
    log "  build_no:   ${BK_BUILD_NO}"
    log "  scope:      ${BK_SCOPE}"
    log "  mode:       ${BK_MODE}"
    log "  timestamp:  ${BK_TIMESTAMP}"
    log "  hostname:   ${BK_HOSTNAME}"
    log "  archives:   ${BK_ARCHIVES[*]}"

    log "Verifying SHA256 of inner archives..."
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
        rm -rf "$STAGE_DIR" 2>/dev/null || true
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

    if (( ! DRY_RUN )); then
        local db_stage="${STAGE_DIR}/databases"
        mkdir -p "$db_stage"
        tar -xzf "${STAGE_DIR}/databases.tar.gz" -C "$db_stage" 2>>"$LOG_FILE"
    fi

    local db
    for db in "${DATABASES[@]}"; do
        log "  restoring ${db}..."
        if (( DRY_RUN )); then
            printf '%s[dry-run]%s drop+restore database %s\n' "$CYAN" "$NC" "$db" | tee -a "$LOG_FILE"
            continue
        fi
        local sql="${STAGE_DIR}/databases/${db}.sql"
        [[ -f "$sql" ]] || fatal "Missing ${db}.sql in backup."
        db_exec -e "DROP DATABASE IF EXISTS \`${db}\`;" 2>>"$LOG_FILE" \
            || fatal "Failed to drop ${db}."
        db_exec -i < "$sql" 2>>"$LOG_FILE" \
            || fatal "Failed to restore ${db}."
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
        printf '%s[dry-run]%s gunzip ldap.ldif.gz | docker exec -i hermes_ldap slapadd -F /etc/ldap/slapd.d -b %s\n' \
            "$CYAN" "$NC" "$LDAP_SUFFIX" | tee -a "$LOG_FILE"
    else
        # slapadd writes to the on-disk LDAP DB. slapd must NOT be running
        # while slapadd writes -- so we stop slapd inside the container,
        # run slapadd, then start slapd. The Hermes image's entrypoint
        # starts slapd; we kill+restart it inline.
        log "  stopping slapd inside hermes_ldap..."
        docker exec hermes_ldap bash -c 'pkill -f slapd || true; sleep 2' 2>>"$LOG_FILE" || true

        log "  running slapadd (wipe + reload)..."
        # -F points slapadd at the OLC config dir slapd uses (matches the
        # backup-side slapcat invocation). -c would continue on errors but
        # we want failures to abort so the operator notices.
        gunzip -c "${STAGE_DIR}/ldap.ldif.gz" \
            | docker exec -i hermes_ldap slapadd -F /etc/ldap/slapd.d -b "$LDAP_SUFFIX" 2>>"$LOG_FILE" \
            || fatal "slapadd failed."

        # Fix ownership on the LDAP data files. slapd in the Hermes image
        # runs as root (-u root -g root in ps output), so chown to root:root.
        docker exec hermes_ldap chown -R root:root /var/lib/ldap 2>>"$LOG_FILE" || true

        log "  restarting hermes_ldap container so slapd picks up the restored DB..."
        run bash -c "cd '$HERMES_ROOT' && docker compose restart hermes_ldap"
        sleep 4
    fi

    log "Stopping hermes_ldap..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop hermes_ldap"
}

restore_tier() {
    local tier="$1"
    local archive="${tier}.tar.gz"
    bk_has_archive "$archive" || return 0

    local src_archive="${STAGE_DIR}/${archive}"
    local dest="${TIER_PATH[$tier]}"
    local tier_stage="${STAGE_DIR}/extracted_${tier}"

    log "  ${tier}: extract + rsync --delete to ${dest}"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -xzf %s -C %s\n' "$CYAN" "$NC" "$src_archive" "$tier_stage" | tee -a "$LOG_FILE"
        printf '%s[dry-run]%s rsync -a --delete %s/ %s/\n' "$CYAN" "$NC" "$tier_stage" "$dest" | tee -a "$LOG_FILE"
        return 0
    fi

    mkdir -p "$tier_stage"
    start_heartbeat "${tier}: extract" "" 60
    tar -xzf "$src_archive" -C "$tier_stage" 2>>"$LOG_FILE" \
        || { stop_heartbeat; fatal "Failed to extract ${archive}."; }
    stop_heartbeat

    local exclude_args=()
    case "$tier" in
        config)
            # Preserve install-logs/ and .git/ on the target -- they were
            # excluded from the backup so without these excludes rsync's
            # --delete would wipe them.
            exclude_args=( --exclude='install-logs/' --exclude='.git/' )
            ;;
        data)
            # Preserve dbase/, ldap/data/, and mail_filter/data/clamav/ on
            # the target -- the backup excluded them because DB dumps,
            # slapcat, and ClamAV signature regeneration are the
            # authoritative sources. Without these excludes, --delete would
            # wipe MariaDB's tablespace files (restore would still work via
            # mariadb-dump repopulating) and slapd's data files (LDAP restore
            # would have no on-disk LMDB to slapadd into).
            #
            # Paths must match the backup-side excludes in system_backup.sh
            # tar_tier(). If you change one, change the other.
            exclude_args=( \
                --exclude='dbase/' \
                --exclude='ldap/data/' \
                --exclude='mail_filter/data/clamav/' \
            )
            ;;
    esac

    start_heartbeat "${tier}: rsync" "" 60
    rsync -a --delete "${exclude_args[@]}" "${tier_stage}/" "${dest}/" 2>>"$LOG_FILE" \
        || { stop_heartbeat; fatal "rsync failed for tier '${tier}'."; }
    stop_heartbeat

    rm -rf "$tier_stage"
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

cleanup_stage() {
    if (( DRY_RUN )); then return 0; fi
    if [[ -d "$STAGE_DIR" ]]; then rm -rf "$STAGE_DIR"; fi
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
    extract_and_verify
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
    cleanup_stage
    report
}

main "$@"
