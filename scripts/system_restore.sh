#!/usr/bin/env bash
# ============================================================================
# Hermes SEG Docker -- cold-mode system restore (#220 Phase A)
# ============================================================================
# Restores a backup tarball produced by scripts/system_backup.sh. Verifies
# the manifest + per-archive SHA256 BEFORE any destructive action, refuses
# to restore onto a host with a different storage topology (unless
# FORCE_REMAP=1 is set), stops the stack, restores all six databases via
# socket auth (no -p flag, per the MariaDB unix-socket auth convention),
# rsyncs each tier from staging to its mount path with --delete, restarts
# the stack, and verifies the stack came back up.
#
# Required: run as root, the host's stack must be in a known state
# (running OR fully stopped, not partially up), the backup file must be
# accessible. Run after `scp`-ing the tarball over from another host
# (typical disaster-recovery flow) or on the same host that produced it.
#
# Tracking: #220
# ============================================================================

set -uo pipefail

# ---- Self-locate HERMES_ROOT (walk up to find docker-compose.yml + .git) ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]]; do
        if [[ -f "$HERMES_ROOT/docker-compose.yml" && -d "$HERMES_ROOT/.git" ]]; then
            break
        fi
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "ERROR: Could not locate docker-compose.yml + .git pair walking up from $SCRIPT_DIR" >&2
        echo "Set HERMES_ROOT environment variable manually and retry." >&2
        exit 1
    fi
fi

LOG_DIR="${HERMES_ROOT}/install-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/system_restore_$(date '+%Y%m%d_%H%M%S').log"

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
Usage: $(basename "$0") -F <backup.tar> [--yes] [--dry-run] [--help]

Hermes SEG Docker cold-mode system restore (#220 Phase A).

Required:
  -F <path>      Path to the backup tarball produced by system_backup.sh.

Options:
  --yes          Skip the interactive confirmation prompt.
  --dry-run      Show what would be done without stopping anything or
                 writing any files.
  --help         Show this help.

Environment:
  FORCE_REMAP=1  Required if the backup's storage topology does NOT
                 match this host's (different DATA_MOUNT etc.). Without
                 it, restore refuses on topology mismatch to protect
                 against accidental cross-topology restore.

The stack is STOPPED for the duration of the restore. All current
data is REPLACED with the backup's contents. Plan accordingly.

Disaster-recovery flow (other host):
  1. Install Hermes fresh on the new host so the install root exists
     and the .env points at the right mount paths.
  2. \`scp\` the backup tarball from offsite storage.
  3. sudo $(basename "$0") -F /path/to/hermes-backup-<build>-<ts>.tar
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -F)             BACKUP_FILE="$2"; shift 2 ;;
        --yes|-y)       ASSUME_YES=1; shift ;;
        --dry-run|-n)   DRY_RUN=1; shift ;;
        --help|-h)      SHOW_HELP=1; shift ;;
        *)              error "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

if (( SHOW_HELP )); then usage; exit 0; fi
if [[ -z "$BACKUP_FILE" ]]; then error "Required flag -F missing."; usage; exit 1; fi
if [[ ! -f "$BACKUP_FILE" ]]; then error "Backup file not found: ${BACKUP_FILE}"; exit 1; fi
if [[ $EUID -ne 0 ]] && (( ! DRY_RUN )); then fatal "Must run as root (live mode)."; fi

# ---- Constants ----
DATABASES=( hermes authelia opendmarc Syslog djigzo nextcloud )
TIERS=( config data archive vmail nextcloud )
ARCHIVES=( databases.tar.gz config.tar.gz data.tar.gz archive.tar.gz vmail.tar.gz nextcloud.tar.gz )

declare -A TIER_PATH      # current host's tier paths
declare -A BK_TIER_PATH   # backup's tier paths (from manifest)

STAGE_DIR=""
RESTART_NEEDED=0

# ---- Helpers ----
run() {
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s %s\n' "$CYAN" "$NC" "$*" | tee -a "$LOG_FILE"
    else
        "$@" 2>>"$LOG_FILE"
    fi
}

cleanup_on_fatal() {
    if (( RESTART_NEEDED )) && (( ! DRY_RUN )); then
        warn "Attempting to restart stack after failure..."
        ( cd "$HERMES_ROOT" && docker compose up -d ) >>"$LOG_FILE" 2>&1 || true
    fi
    if [[ -d "${STAGE_DIR:-}" ]]; then
        warn "Staging directory left at ${STAGE_DIR} for inspection. Remove it manually after diagnosing."
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
    for t in "${TIERS[@]}"; do
        [[ -n "${TIER_PATH[$t]:-}" ]] || fatal "Current host: tier '$t' has no mount path in .env."
    done
}

parse_manifest() {
    # Extract values from backup_manifest.json using grep+sed (no jq dep).
    # The manifest is written by system_backup.sh with stable key ordering.
    local m="${STAGE_DIR}/backup_manifest.json"
    [[ -f "$m" ]] || fatal "Backup is missing backup_manifest.json -- not a valid Hermes backup."

    local get
    get() { grep -oE "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]+\"" "$m" | head -1 | sed 's/.*"\([^"]*\)"$/\1/'; }

    BK_BUILD_NO="$(get build_no)"
    BK_TIMESTAMP="$(get timestamp)"
    BK_HOSTNAME="$(get hostname)"
    BK_TIER_PATH[config]="$(get config_path)"
    BK_TIER_PATH[data]="$(get data_mount)"
    BK_TIER_PATH[archive]="$(get archive_mount)"
    BK_TIER_PATH[vmail]="$(get vmail_mount)"
    BK_TIER_PATH[nextcloud]="$(get files_mount)"

    [[ -n "$BK_BUILD_NO" ]] || fatal "Manifest missing build_no field."
    for t in "${TIERS[@]}"; do
        [[ -n "${BK_TIER_PATH[$t]}" ]] || fatal "Manifest missing tier path for '$t'."
    done
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
        fatal "SHA256 mismatch for ${archive}: manifest=${expected} actual=${actual}. Backup is corrupt or tampered with."
    fi
    log "  ${archive}: SHA256 ✓"
}

wait_for_db() {
    local i
    for i in {1..30}; do
        if docker exec hermes_db_server mariadb -u root -e 'SELECT 1' >/dev/null 2>&1; then return 0; fi
        sleep 2
    done
    fatal "hermes_db_server did not become reachable within 60s."
}

# ---- Phases ----
preflight() {
    header "Preflight"
    if (( ! DRY_RUN )); then
        command -v docker >/dev/null 2>&1 || fatal "docker not in PATH"
        command -v rsync >/dev/null 2>&1 || fatal "rsync not in PATH (install rsync first)"
        docker compose version >/dev/null 2>&1 || fatal "docker compose v2 not available"
    fi
    load_current_mounts
    log "HERMES_ROOT:   ${HERMES_ROOT}"
    log "Backup file:   ${BACKUP_FILE}"
    log "Log:           ${LOG_FILE}"
}

extract_and_verify() {
    header "Extracting backup + verifying manifest"
    STAGE_DIR="$(mktemp -d -t hermes-restore-XXXXXX)"
    log "Staging dir: ${STAGE_DIR}"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -xf %s -C %s\n' "$CYAN" "$NC" "$BACKUP_FILE" "$STAGE_DIR" | tee -a "$LOG_FILE"
        return 0
    fi
    tar -xf "$BACKUP_FILE" -C "$STAGE_DIR" 2>>"$LOG_FILE" \
        || fatal "Failed to extract outer tarball."

    parse_manifest

    log "Backup metadata:"
    log "  build_no:   ${BK_BUILD_NO}"
    log "  timestamp:  ${BK_TIMESTAMP}"
    log "  hostname:   ${BK_HOSTNAME}"

    log "Verifying SHA256 of inner archives..."
    for a in "${ARCHIVES[@]}"; do verify_archive_sha "$a"; done
}

check_topology() {
    header "Topology check"
    local mismatch=0
    for t in "${TIERS[@]}"; do
        if [[ "${BK_TIER_PATH[$t]}" != "${TIER_PATH[$t]}" ]]; then
            warn "Topology mismatch for tier '${t}': backup=${BK_TIER_PATH[$t]} current=${TIER_PATH[$t]}"
            mismatch=1
        else
            log "  ${t}: ${TIER_PATH[$t]} ✓"
        fi
    done
    if (( mismatch )); then
        if [[ "${FORCE_REMAP:-0}" == "1" ]]; then
            warn "FORCE_REMAP=1 -- proceeding with the CURRENT host's tier paths."
            warn "The backup's tier paths will be IGNORED. Backup data will land at current paths."
        else
            error "Topology mismatch detected. To restore anyway and remap tiers to this host's paths,"
            error "re-run with FORCE_REMAP=1: FORCE_REMAP=1 $0 -F ${BACKUP_FILE}"
            error "Hot-mode + per-tier --remap-tiers flag will land in Phase B; cold-mode Phase A uses"
            error "an all-or-nothing env-var gate."
            fatal "Refusing to restore on topology mismatch without explicit FORCE_REMAP=1."
        fi
    fi
}

confirm_destructive() {
    header "Confirm"
    log ""
    log "This will REPLACE all current data on this host with the backup's contents:"
    log "  - All six databases (hermes, authelia, nextcloud, djigzo, opendmarc, Syslog)"
    log "  - The install root (repo working tree, secrets, .env)"
    log "  - All four storage tiers (Data, Archive, Vmail, Nextcloud)"
    log ""
    log "The stack will be STOPPED for the duration of the restore."
    log ""
    if ! confirm "Proceed with restore?"; then
        log "Aborted by operator."
        rm -rf "$STAGE_DIR" 2>/dev/null || true
        exit 0
    fi
}

stop_stack_restore_dbs() {
    header "Stopping stack + restoring databases"
    log "docker compose stop (full stack down)..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop"
    RESTART_NEEDED=1

    log "Starting hermes_db_server briefly..."
    run bash -c "cd '$HERMES_ROOT' && docker compose start hermes_db_server"
    if (( ! DRY_RUN )); then wait_for_db; fi

    log "Extracting databases.tar.gz to staging..."
    if (( ! DRY_RUN )); then
        local db_stage="${STAGE_DIR}/databases"
        mkdir -p "$db_stage"
        tar -xzf "${STAGE_DIR}/databases.tar.gz" -C "$db_stage" 2>>"$LOG_FILE"
    fi

    for db in "${DATABASES[@]}"; do
        log "  restoring ${db}..."
        if (( DRY_RUN )); then
            printf '%s[dry-run]%s drop+restore database %s\n' "$CYAN" "$NC" "$db" | tee -a "$LOG_FILE"
            continue
        fi
        local sql="${STAGE_DIR}/databases/${db}.sql"
        [[ -f "$sql" ]] || fatal "Missing ${db}.sql in backup."
        # Drop+recreate ensures table set matches the dump (rather than
        # leftover tables from the OLD state). mysql.db user grants are
        # stored separately and survive the drop.
        docker exec hermes_db_server mariadb -u root -e "DROP DATABASE IF EXISTS \`${db}\`;" 2>>"$LOG_FILE" \
            || fatal "Failed to drop database '${db}'."
        # The dump contains CREATE DATABASE + USE statements (--databases flag at backup time).
        docker exec -i hermes_db_server mariadb -u root < "$sql" 2>>"$LOG_FILE" \
            || fatal "Failed to restore database '${db}'."
    done
    docker exec hermes_db_server mariadb -u root -e "FLUSH PRIVILEGES;" 2>>"$LOG_FILE" || true

    log "Stopping hermes_db_server..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop hermes_db_server"
}

restore_tier() {
    local tier="$1"
    local src_archive="${STAGE_DIR}/${tier}.tar.gz"
    local dest="${TIER_PATH[$tier]}"
    local tier_stage="${STAGE_DIR}/extracted_${tier}"

    log "  ${tier}: extract + rsync --delete to ${dest}"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -xzf %s -C %s\n' "$CYAN" "$NC" "$src_archive" "$tier_stage" | tee -a "$LOG_FILE"
        printf '%s[dry-run]%s rsync -a --delete %s/ %s/\n' "$CYAN" "$NC" "$tier_stage" "$dest" | tee -a "$LOG_FILE"
        return 0
    fi

    mkdir -p "$tier_stage"
    tar -xzf "$src_archive" -C "$tier_stage" 2>>"$LOG_FILE" \
        || fatal "Failed to extract ${tier}.tar.gz to staging."

    # For the Config tier, preserve install-logs/ and .git/ on the target.
    # They were excluded from the backup, so without these excludes rsync's
    # --delete would wipe them. Other tiers have no excludes.
    local exclude_args=()
    if [[ "$tier" == "config" ]]; then
        exclude_args=( --exclude='install-logs/' --exclude='.git/' )
    fi

    rsync -a --delete "${exclude_args[@]}" "${tier_stage}/" "${dest}/" 2>>"$LOG_FILE" \
        || fatal "rsync failed for tier '${tier}'."

    rm -rf "$tier_stage"
}

restore_tiers() {
    header "Restoring five storage tiers"
    for t in "${TIERS[@]}"; do restore_tier "$t"; done
}

restart_stack() {
    header "Restarting stack"
    run bash -c "cd '$HERMES_ROOT' && docker compose start"
    RESTART_NEEDED=0
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
    header "Post-restore: ensure Nextcloud maintenance mode is OFF"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s occ maintenance:mode --off\n' "$CYAN" "$NC" | tee -a "$LOG_FILE"
        return 0
    fi
    # The NC config.php file is on the backed-up Nextcloud tier and persists
    # `maintenance => true` if the backup was taken while NC was in
    # maintenance mode. Forcibly turn it off post-restore to avoid surprises.
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
    if [[ -d "$STAGE_DIR" ]]; then
        log "Cleaning up staging dir ${STAGE_DIR}..."
        rm -rf "$STAGE_DIR"
    fi
}

report() {
    header "Done"
    if (( DRY_RUN )); then
        log "Dry-run complete. Nothing was changed."
        return 0
    fi
    log "Restore complete from: ${BACKUP_FILE}"
    log "Log:                   ${LOG_FILE}"
    log ""
    log "Next steps:"
    log "  1. Verify you can log into the admin console (https://<console-host>/admin/)"
    log "  2. Verify mail flow (send + receive a test message)"
    log "  3. If something looks off, check ${LOG_FILE} for warnings."
}

main() {
    log "Hermes SEG cold-mode system restore (#220 Phase A)"
    log "Mode: $((( DRY_RUN )) && echo DRY-RUN || echo LIVE)"
    preflight
    extract_and_verify
    check_topology
    confirm_destructive
    stop_stack_restore_dbs
    restore_tiers
    restart_stack
    post_restore_nc_maintenance_off
    cleanup_stage
    report
}

main "$@"
