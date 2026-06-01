#!/usr/bin/env bash
# ============================================================================
# Hermes SEG Docker -- cold-mode system backup (#219 Phase A)
# ============================================================================
# Stops the stack, dumps all six databases, tars all five storage tiers
# (Config / Data / Archive / Vmail / Nextcloud), writes a manifest with
# SHA256 per archive, atomically renames the .partial output to its final
# name, then restarts the stack.
#
# COLD mode only -- the stack is down for the duration of the backup
# (5-15 minutes for small sites; longer for large vmail/nextcloud installs).
# Hot mode + scoped backups + retention pruning + Ofelia scheduling land in
# the Phase B refactor.
#
# Output layout:
#   <-P>/hermes-backup-<build_no>-<timestamp>.tar
#       backup_manifest.json
#       databases.tar.gz          (6 .sql files: hermes, authelia, ...)
#       config.tar.gz             (the install root, MINUS the data tiers)
#       data.tar.gz, archive.tar.gz, vmail.tar.gz, nextcloud.tar.gz
#
# The outer .tar is uncompressed (each tier is already .tar.gz inside).
# Operators can `tar -xf` it once to inspect the manifest before restore.
#
# Required: run as root, all containers in a known state (running or
# fully stopped -- not partially up). Run via cron/Ofelia or by hand.
#
# Tracking: #219
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
LOG_FILE="${LOG_DIR}/system_backup_$(date '+%Y%m%d_%H%M%S').log"

# ---- Colors ----
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

# ---- Logging helpers ----
log()   { printf '%s[%s]%s %s\n' "$GREEN" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s[%s] WARN:%s %s\n' "$YELLOW" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
error() { printf '%s[%s] ERROR:%s %s\n' "$RED" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE" >&2; }
fatal() { error "$@"; cleanup_on_fatal; exit 1; }
header(){ printf '\n%s== %s ==%s\n' "$CYAN" "$*" "$NC" | tee -a "$LOG_FILE"; }

# ---- Args ----
BACKUP_PATH=""
ASSUME_YES=0
DRY_RUN=0
SHOW_HELP=0

usage() {
    cat <<EOF
Usage: $(basename "$0") -P <path> [--yes] [--dry-run] [--help]

Hermes SEG Docker cold-mode system backup (#219 Phase A).

Required:
  -P <path>      Output directory for the backup tarball. Must already
                 exist and be writable. The tarball will be created as
                 <path>/hermes-backup-<build_no>-<timestamp>.tar.

Options:
  --yes          Skip the interactive confirmation prompt.
  --dry-run      Show what would be done without stopping anything or
                 writing any files.
  --help         Show this help.

Examples:
  sudo $(basename "$0") -P /mnt/backups
  sudo $(basename "$0") -P /mnt/backups --yes

The stack is stopped for the duration of the backup. Plan around your
mail-flow tolerances. For hot-mode backups, use hypervisor snapshots
until #219 Phase B ships.

Output layout (inside the outer .tar):
  backup_manifest.json                   (versions, topology, SHA256 sums)
  databases.tar.gz                       (hermes, authelia, nextcloud,
                                          djigzo, opendmarc, Syslog)
  config.tar.gz                          (install root MINUS data tiers)
  data.tar.gz, archive.tar.gz,
  vmail.tar.gz, nextcloud.tar.gz         (five storage tiers)
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -P)             BACKUP_PATH="$2"; shift 2 ;;
        --yes|-y)       ASSUME_YES=1; shift ;;
        --dry-run|-n)   DRY_RUN=1; shift ;;
        --help|-h)      SHOW_HELP=1; shift ;;
        *)              error "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

if (( SHOW_HELP )); then usage; exit 0; fi
if [[ -z "$BACKUP_PATH" ]]; then error "Required flag -P missing."; usage; exit 1; fi
if [[ $EUID -ne 0 ]] && (( ! DRY_RUN )); then fatal "Must run as root (live mode)."; fi

# ---- Constants ----
DATABASES=( hermes authelia opendmarc Syslog djigzo nextcloud )
TIERS=( config data archive vmail nextcloud )

# Tier paths read from .env at runtime (resolved below).
declare -A TIER_PATH
declare -A ARCHIVE_SHA
declare -A ARCHIVE_SIZE

TIMESTAMP="$(date -u '+%Y%m%dT%H%M%SZ')"
BUILD_NO=""
STAGE_DIR=""    # populated in main()
FINAL_TAR=""    # populated in main()
PARTIAL_TAR=""  # populated in main()
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
    # If we already stopped the stack, try to bring it back up so the
    # operator isn't left with a dead system on a script error.
    if (( RESTART_NEEDED )) && (( ! DRY_RUN )); then
        warn "Attempting to restart stack after failure..."
        ( cd "$HERMES_ROOT" && docker compose up -d ) >>"$LOG_FILE" 2>&1 || true
    fi
    # Leave .partial files in place so the operator can inspect them.
    if [[ -d "${STAGE_DIR:-}" ]]; then
        warn "Staging directory left at ${STAGE_DIR} for inspection. Remove it manually after diagnosing."
    fi
}

confirm() {
    if (( ASSUME_YES )) || (( DRY_RUN )); then return 0; fi
    read -r -p "$1 [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

load_mounts() {
    local env_file="${HERMES_ROOT}/.env"
    [[ -f "$env_file" ]] || fatal "Cannot read ${env_file} -- need DATA_MOUNT/ARCHIVE_MOUNT/VMAIL_MOUNT/FILES_MOUNT."
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
        [[ -d "${TIER_PATH[$t]}" ]]   || fatal "Tier '$t' path does not exist: ${TIER_PATH[$t]}"
    done
}

read_build_no() {
    # Same source the orchestrator uses.
    if ! docker ps --format '{{.Names}}' | grep -q '^hermes_db_server$'; then
        warn "hermes_db_server not running -- starting it briefly to read build_no..."
        ( cd "$HERMES_ROOT" && docker compose up -d hermes_db_server ) >>"$LOG_FILE" 2>&1
        sleep 8
    fi
    BUILD_NO="$(docker exec hermes_db_server mariadb -u root -N -s hermes \
        -e "SELECT value FROM system_settings WHERE parameter='build_no';" 2>>"$LOG_FILE" | tr -d '[:space:]')"
    [[ -n "$BUILD_NO" ]] || fatal "Could not read build_no from system_settings."
}

wait_for_db() {
    local i
    for i in {1..30}; do
        if docker exec hermes_db_server mariadb -u root -e 'SELECT 1' >/dev/null 2>&1; then
            return 0
        fi
        sleep 2
    done
    fatal "hermes_db_server did not become reachable within 60s."
}

dump_databases() {
    header "Dumping databases"
    local db_stage="${STAGE_DIR}/databases"
    mkdir -p "$db_stage"
    local db
    for db in "${DATABASES[@]}"; do
        log "  dumping ${db}..."
        if (( DRY_RUN )); then
            printf '%s[dry-run]%s docker exec hermes_db_server mariadb-dump --single-transaction --routines --triggers --events %s\n' "$CYAN" "$NC" "$db" | tee -a "$LOG_FILE"
        else
            # --single-transaction: consistent dump without table locks (InnoDB)
            # --routines/triggers/events: capture stored procedures + scheduled events
            # No -p flag: socket auth from inside the container (root has it)
            if ! docker exec hermes_db_server \
                mariadb-dump --single-transaction --routines --triggers --events --databases "$db" \
                > "${db_stage}/${db}.sql" 2>>"$LOG_FILE"; then
                fatal "mariadb-dump failed for database '${db}'. See $LOG_FILE."
            fi
        fi
    done
    if (( ! DRY_RUN )); then
        log "  packaging databases.tar.gz..."
        tar -czf "${STAGE_DIR}/databases.tar.gz" -C "$db_stage" . 2>>"$LOG_FILE"
        rm -rf "$db_stage"
    fi
}

tar_tier() {
    local tier="$1"
    local src="${TIER_PATH[$tier]}"
    local out="${STAGE_DIR}/${tier}.tar.gz"
    log "  ${tier}: tarring ${src} -> $(basename "$out")"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s tar -czf %s ... \n' "$CYAN" "$NC" "$out" | tee -a "$LOG_FILE"
        return 0
    fi
    # For the config tier, exclude the install-logs dir (large, churning,
    # not needed for restore) and the data tier paths in case the operator
    # mounted them inside the install root.
    local exclude_args=()
    if [[ "$tier" == "config" ]]; then
        exclude_args+=( --exclude="./install-logs" --exclude="./.git" )
        for t in data archive vmail nextcloud; do
            local p="${TIER_PATH[$t]}"
            if [[ "$p" == "$src"/* ]]; then
                exclude_args+=( --exclude="./${p#$src/}" )
            fi
        done
    fi
    tar -czf "$out" "${exclude_args[@]}" -C "$src" . 2>>"$LOG_FILE" \
        || fatal "tar failed for tier '${tier}'"
}

compute_sha256() {
    local f="$1"
    if (( DRY_RUN )); then echo "DRYRUN_SHA256"; return; fi
    sha256sum "$f" | awk '{print $1}'
}

emit_manifest() {
    local m="${STAGE_DIR}/backup_manifest.json"
    log "  emitting manifest..."
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s would write %s\n' "$CYAN" "$NC" "$m" | tee -a "$LOG_FILE"
        return 0
    fi
    {
        printf '{\n'
        printf '  "manifest_version": "1.0",\n'
        printf '  "build_no": "%s",\n' "$BUILD_NO"
        printf '  "scope": "all",\n'
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
        printf '  "archives": {\n'
        local archives=( databases.tar.gz config.tar.gz data.tar.gz archive.tar.gz vmail.tar.gz nextcloud.tar.gz )
        first=1
        for a in "${archives[@]}"; do
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
    [[ -d "$BACKUP_PATH" ]] || fatal "Backup path does not exist: ${BACKUP_PATH}"
    [[ -w "$BACKUP_PATH" ]] || fatal "Backup path is not writable: ${BACKUP_PATH}"

    load_mounts
    read_build_no

    FINAL_TAR="${BACKUP_PATH}/hermes-backup-${BUILD_NO}-${TIMESTAMP}.tar"
    PARTIAL_TAR="${FINAL_TAR}.partial"
    STAGE_DIR="${BACKUP_PATH}/.staging-${TIMESTAMP}"
    [[ -e "$FINAL_TAR" || -e "$PARTIAL_TAR" || -e "$STAGE_DIR" ]] && \
        fatal "Target files already exist (timestamp collision): ${FINAL_TAR}*"

    log "HERMES_ROOT:   ${HERMES_ROOT}"
    log "build_no:      ${BUILD_NO}"
    log "Timestamp:     ${TIMESTAMP}"
    log "Output:        ${FINAL_TAR}"
    log "Staging:       ${STAGE_DIR}"
    for t in "${TIERS[@]}"; do log "Tier ${t}: ${TIER_PATH[$t]}"; done

    log ""
    log "This will STOP the Hermes stack for the duration of the backup."
    log "Plan around your mail-flow tolerances. The stack is restarted at the end."
    log ""
    if ! confirm "Proceed?"; then
        log "Aborted by operator."
        exit 0
    fi
    if (( ! DRY_RUN )); then mkdir -p "$STAGE_DIR"; fi
}

stop_stack_dump_dbs() {
    header "Stopping stack + dumping databases"
    log "docker compose stop (full stack down)..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop"
    RESTART_NEEDED=1

    log "Starting hermes_db_server briefly to dump databases..."
    run bash -c "cd '$HERMES_ROOT' && docker compose start hermes_db_server"
    if (( ! DRY_RUN )); then wait_for_db; fi

    dump_databases

    log "Stopping hermes_db_server..."
    run bash -c "cd '$HERMES_ROOT' && docker compose stop hermes_db_server"
}

tar_tiers() {
    header "Archiving five storage tiers"
    for t in "${TIERS[@]}"; do tar_tier "$t"; done
}

assemble_outer() {
    header "Assembling outer tarball"
    if (( DRY_RUN )); then
        printf '%s[dry-run]%s would compute SHA256 and emit manifest\n' "$CYAN" "$NC" | tee -a "$LOG_FILE"
        printf '%s[dry-run]%s tar -cf %s -C %s .\n' "$CYAN" "$NC" "$PARTIAL_TAR" "$STAGE_DIR" | tee -a "$LOG_FILE"
        printf '%s[dry-run]%s mv %s %s\n' "$CYAN" "$NC" "$PARTIAL_TAR" "$FINAL_TAR" | tee -a "$LOG_FILE"
        return 0
    fi

    local archives=( databases.tar.gz config.tar.gz data.tar.gz archive.tar.gz vmail.tar.gz nextcloud.tar.gz )
    for a in "${archives[@]}"; do
        ARCHIVE_SHA[$a]="$(compute_sha256 "${STAGE_DIR}/${a}")"
        ARCHIVE_SIZE[$a]="$(stat -c%s "${STAGE_DIR}/${a}")"
    done

    emit_manifest

    # Outer tar is UNCOMPRESSED -- the inners are already .gz.
    tar -cf "$PARTIAL_TAR" -C "$STAGE_DIR" . 2>>"$LOG_FILE" \
        || fatal "Outer tar assembly failed."

    # Atomic rename signals 'done'. If we crash before this, the operator
    # sees only .partial and knows the backup is incomplete.
    mv "$PARTIAL_TAR" "$FINAL_TAR" \
        || fatal "Atomic rename failed: ${PARTIAL_TAR} -> ${FINAL_TAR}"

    # Drop the staging dir on success.
    rm -rf "$STAGE_DIR"
}

restart_stack() {
    header "Restarting stack"
    run bash -c "cd '$HERMES_ROOT' && docker compose start"
    RESTART_NEEDED=0
    if (( DRY_RUN )); then return 0; fi

    # Brief readiness check: wait for commandbox to respond, then move on.
    local i
    for i in {1..30}; do
        if docker exec hermes_commandbox curl -sf --max-time 2 http://localhost:8888/ >/dev/null 2>&1; then
            log "  hermes_commandbox responding ✓"
            return 0
        fi
        sleep 2
    done
    warn "hermes_commandbox did not respond on :8888 within 60s. Stack may still be coming up; check with 'docker compose ps'."
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
    log "Size:           ${sz}"
    log "Log:            ${LOG_FILE}"
    log ""
    log "To restore on this or another host:"
    log "  sudo ./scripts/system_restore.sh -F '${FINAL_TAR}'"
}

main() {
    log "Hermes SEG cold-mode system backup (#219 Phase A)"
    log "Mode: $((( DRY_RUN )) && echo DRY-RUN || echo LIVE)"
    preflight
    stop_stack_dump_dbs
    tar_tiers
    assemble_outer
    restart_stack
    report
}

main "$@"
