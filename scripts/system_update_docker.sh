#!/bin/bash
#
# Hermes SEG Docker Update Orchestrator (#221)
#
# Single command to upgrade a running Hermes install from its current
# build_no to a newer release tag. Walks 5 phases:
#
#   Phase 1 — Pull new code (git fetch + checkout)
#   Phase 2 — Update containers (compose pull + up)
#   Phase 3 — Apply per-release artifacts (sql + cfml + scripts)
#   Phase 4 — Standard finalize (occ upgrade, service restarts)
#   Phase 5 — Post-upgrade hook (schedule/post_upgrade.cfm)
#
# Idempotent: every artifact is guarded so re-running picks up where it
# left off without breakage.
#
# Canonical reference for the methodology this script implements:
#   docs/install/release-and-update-methodology.md
#
# Usage:
#   ./scripts/system_update_docker.sh                    # latest release on github (production)
#   ./scripts/system_update_docker.sh v260601            # specific tag
#   ./scripts/system_update_docker.sh --remote=gitlab    # auto-detect latest on gitlab (RC testing)
#   ./scripts/system_update_docker.sh --remote=gitlab v260609   # specific tag on gitlab
#   ./scripts/system_update_docker.sh --dry-run          # show what would happen, do nothing
#   ./scripts/system_update_docker.sh --skip-git         # don't touch git (containers + artifacts only)
#   ./scripts/system_update_docker.sh --skip-compose     # don't touch docker images (git + artifacts only)
#
# Remotes:
#   Default --remote=origin -- which is github for real customer installs.
#   With no positional arg, the script polls the GitHub Releases API for
#   the latest published release and uses that tag.
#
#   --remote=gitlab is the test/RC workflow. The script fetches from the
#   'gitlab' remote (operator must have it configured via
#   `git remote add gitlab <gitlab-url>`) and picks the highest v* tag
#   from that remote's tag list. Lets you test a release candidate that's
#   tagged on gitlab but not yet promoted to github.
#
#   Any other --remote=NAME value works the same way as gitlab -- fetches
#   from that remote, picks highest v* tag via ls-remote. Useful for
#   testing against forks or mirror remotes.
#
# Prerequisites:
#   - Run on the Docker host (not inside a container)
#   - hermes_db_server container running (needed to read build_no)
#   - Docker Compose v2
#   - Git + curl
#
# ============================================================================

set -e
set -o pipefail

# ---------------------------------------------------------------------------
# Colors + logging
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log()    { echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"; }
warn()   { echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARN:${NC} $*" | tee -a "$LOG_FILE"; }
error()  { echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $*" | tee -a "$LOG_FILE" >&2; }
header() { echo -e "\n${BOLD}${BLUE}== $* ==${NC}\n" | tee -a "$LOG_FILE"; }

fatal() { error "$@"; exit 1; }

# ---------------------------------------------------------------------------
# Self-locator (walk up to find docker-compose.yml + .git pair)
# Matches the canonical pattern from install_hermes_docker.sh / #217.
# ---------------------------------------------------------------------------
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

# Log file lives alongside the script (same convention as install_hermes_docker.sh)
LOG_DIR="${HERMES_ROOT}/install-logs"
mkdir -p "$LOG_DIR" 2>/dev/null || true
LOG_FILE="${LOG_DIR}/hermes_update_$(date +%Y%m%d_%H%M%S).log"

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------
TARGET_TAG=""
DRY_RUN=0
SKIP_GIT=0
SKIP_COMPOSE=0
ASSUME_YES=0
# REMOTE: which git remote to fetch from + use for auto-detecting latest tag.
# Default is "origin" (= github for real customers; canonical production path).
# Test/RC workflow uses --remote=gitlab to test a release candidate that's
# tagged on gitlab but not yet promoted to github.
REMOTE="origin"

# Preserve argv before the parser consumes it.
#
# This loop runs at TOP LEVEL and shifts every argument away, so `main "$@"`
# at the bottom of the file receives NOTHING -- and the self-update re-exec
# inside main therefore relaunched with no arguments at all. Everything the
# operator asked for was silently dropped on the second incarnation (#288):
#
#   system_update_docker.sh v260731  -> re-exec resolved "latest release"
#                                       instead, and reported "already up to
#                                       date" while doing nothing
#   --remote=gitlab                  -> reverted to the GitHub Releases API,
#                                       defeating the entire RC workflow
#   --yes                            -> prompted again (visible as a second
#                                       "Proceed with upgrade?")
#   --dry-run                        -> THE SECOND INCARNATION RAN FOR REAL
#
# That last one is the dangerous case: a dry run performed an actual upgrade.
ORIG_ARGV=("$@")

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)      DRY_RUN=1; shift ;;
        --skip-git)     SKIP_GIT=1; shift ;;
        --skip-compose) SKIP_COMPOSE=1; shift ;;
        --yes|-y)       ASSUME_YES=1; shift ;;
        --remote=*)     REMOTE="${1#*=}"; shift ;;
        --help|-h)
            sed -n '/^# Usage:/,/^# =/p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        -*)
            fatal "Unknown flag: $1 (try --help)"
            ;;
        *)
            if [[ -z "$TARGET_TAG" ]]; then
                TARGET_TAG="$1"
            else
                fatal "Unexpected positional argument: $1 (target tag already set to '$TARGET_TAG')"
            fi
            shift
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Run a command; in dry-run mode just print what would have run.
run() {
    if (( DRY_RUN )); then
        echo -e "${CYAN}[dry-run]${NC} $*" | tee -a "$LOG_FILE"
    else
        "$@"
    fi
}

# Run a command capturing stdout (still respects dry-run, returning empty).
run_capture() {
    if (( DRY_RUN )); then
        echo -e "${CYAN}[dry-run]${NC} $*" >&2
        return 0
    fi
    "$@"
}

# Admin DB access: socket first, password as fallback.
#
# The design (install_hermes_docker.sh create_databases()) is that LinuxServer's
# mariadb image gives root@localhost the unix_socket plugin, so `docker exec`
# authenticates as OS root with no password -- MYSQL_ROOT_PASSWORD configures
# only root@'%'. That holds on a correctly-built box, and a password sent to a
# unix_socket account is REJECTED, so socket must stay the first choice.
#
# It does not hold everywhere. Observed on DEV 2026-08-01: root@localhost
# rejected socket auth outright ("Access denied ... using password: NO"). With
# socket-only access, get_current_build_no() returned empty and preflight
# called fatal() -- the orchestrator could not run AT ALL on that box. Since
# the root password is already on disk in creds/ and mounted into the container
# as a Docker secret, falling back to it costs nothing and makes the upgrade
# path work under either configuration. Read from the in-container secret so it
# never appears in argv, `ps`, or shell history. See #288.
DB_AUTH="unresolved"

resolve_db_auth() {
    if docker exec hermes_db_server mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
        DB_AUTH="root"
        log "Admin DB access: root via socket ✓"
    elif docker exec hermes_db_server mysql -N -s -e "SELECT 1" >/dev/null 2>&1; then
        # Bare invocation -- picks up the image's root client config. Kept as a
        # probe because an explicit `-u root` DISCARDS those credentials on
        # boxes that rely on them.
        DB_AUTH="default"
        log "Admin DB access: default client credentials ✓"
    elif docker exec hermes_db_server sh -c \
            'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD 2>/dev/null); export MYSQL_PWD; mysql -u root -e "SELECT 1"' \
            >/dev/null 2>&1; then
        DB_AUTH="password"
        warn "Admin DB access: socket auth rejected; using the root password from"
        warn "the mounted Docker secret. root@localhost is mysql_native_password"
        warn "on this box, contrary to the documented design (#288)."
    else
        DB_AUTH="none"
        fatal "Cannot authenticate to hermes_db_server as root by socket OR password.
Check:  docker exec hermes_db_server mysql -u root -e 'SELECT 1'
and that config/hermes/opt/hermes/creds/mysql_root_password matches the running DB."
    fi
}

# db_root_query <db> <sql>  -- returns rows, silent on failure
db_root_query() {
    case "$DB_AUTH" in
        default)  docker exec hermes_db_server mysql -N -s "$1" -e "$2" 2>/dev/null ;;
        password) docker exec hermes_db_server sh -c \
                      'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD); export MYSQL_PWD; exec mysql -u root -N -s "$1" -e "$2"' \
                      _ "$1" "$2" 2>/dev/null ;;
        *)        docker exec hermes_db_server mysql -u root -N -s "$1" -e "$2" 2>/dev/null ;;
    esac
}

# db_root_import <db> < file  -- applies SQL from stdin
db_root_import() {
    case "$DB_AUTH" in
        default)  docker exec -i hermes_db_server mysql "$1" 2>>"$LOG_FILE" ;;
        password) docker exec -i hermes_db_server sh -c \
                      'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD); export MYSQL_PWD; exec mysql -u root "$1"' \
                      _ "$1" 2>>"$LOG_FILE" ;;
        *)        docker exec -i hermes_db_server mysql -u root "$1" 2>>"$LOG_FILE" ;;
    esac
}

# Read current build_no from the live database.
get_current_build_no() {
    db_root_query hermes "SELECT value FROM system_settings WHERE parameter='build_no';"
}

# Resolve the target tag. Priority:
#   1. Explicit TARGET_TAG positional arg from operator
#   2. If REMOTE != "origin" (i.e. operator is using --remote=NAME for RC
#      testing on a non-production remote): list tags from that remote
#      directly via `git ls-remote --tags` and pick the highest v*. We do
#      NOT hit the GitHub Releases API in this case -- the whole point of
#      --remote=NAME is to test something that hasn't been promoted to a
#      GitHub Release yet.
#   3. Default (production path): poll GitHub Releases API for the latest
#      published release. This is what real customers hit when they run
#      `system_update_docker.sh` with no args.
resolve_target_tag() {
    if [[ -n "$TARGET_TAG" ]]; then
        echo "$TARGET_TAG"
        return 0
    fi

    if [[ "$REMOTE" != "origin" ]]; then
        # RC mode: use git ls-remote against the configured remote, find
        # the highest v* tag. Skips the GitHub Releases API entirely
        # (which won't see unpromoted release candidates).
        local tag
        tag=$(git ls-remote --tags --refs "$REMOTE" 2>/dev/null \
              | awk '{print $2}' \
              | sed 's|^refs/tags/||' \
              | grep -E '^v[0-9]{6}(\.[0-9]+)?$' \
              | sort -V \
              | tail -1)
        if [[ -z "$tag" ]]; then
            fatal "No v* tag found on remote '${REMOTE}'. Is the remote configured and the tag pushed?"
        fi
        echo "$tag"
        return 0
    fi

    # Default: GitHub Releases API for the latest published release.
    # The repo is hardcoded — same one referenced in schedule/check_for_update.cfm.
    local api_url="https://api.github.com/repos/deeztek/Hermes-Secure-Email-Gateway/releases/latest"
    local resp
    if ! resp=$(curl -sf "$api_url" 2>/dev/null); then
        fatal "Could not reach GitHub Releases API ($api_url). Pass a tag explicitly or check network."
    fi
    # Extract tag_name without jq dependency — simple grep is enough for this stable JSON shape.
    local tag
    tag=$(echo "$resp" | grep -oE '"tag_name"[[:space:]]*:[[:space:]]*"[^"]+"' | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
    if [[ -z "$tag" ]]; then
        fatal "Could not parse tag_name from GitHub Releases API response."
    fi
    echo "$tag"
}

# Compare two vYYMMDD tags; print -1, 0, or 1.
# Plain string compare works because of the fixed-width calendar format.
compare_versions() {
    local a="$1" b="$2"
    if [[ "$a" == "$b" ]]; then echo 0
    elif [[ "$a" < "$b" ]]; then echo -1
    else echo 1
    fi
}

# Find updates/v<DATE>/ directories STRICTLY GREATER than $1 (current build_no),
# sorted chronologically.
find_pending_releases() {
    local current="$1"
    shopt -s nullglob
    local dirs=( "${HERMES_ROOT}"/updates/v[0-9][0-9][0-9][0-9][0-9][0-9]/ )
    shopt -u nullglob
    local d ver pending=()
    for d in "${dirs[@]}"; do
        ver="$(basename "${d%/}")"      # vYYMMDD
        if [[ "$(compare_versions "$ver" "$current")" == "1" ]]; then
            pending+=( "$ver" )
        fi
    done
    # Sort chronologically (calendar versioning sorts correctly as string)
    if (( ${#pending[@]} > 0 )); then
        printf '%s\n' "${pending[@]}" | sort
    fi
}

# Detect NC version drift between .env's NCVERSION and what
# hermes_nextcloud is actually running; if they differ, run
# `occ upgrade` and rehydrate Hermes-required NC apps. Called
# from phase4_finalize. See #264.
nc_upgrade_if_needed() {
    local declared_nc=""
    if grep -qE '^NCVERSION=' "${HERMES_ROOT}/.env" 2>/dev/null; then
        declared_nc="$(grep -E '^NCVERSION=' "${HERMES_ROOT}/.env" \
            | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'" | tr -d '[:space:]')"
    fi

    if [[ -z "$declared_nc" ]]; then
        log "No NCVERSION in .env -- skipping NC upgrade detection."
        return 0
    fi

    if ! docker ps --format '{{.Names}}' | grep -q '^hermes_nextcloud$'; then
        warn "hermes_nextcloud container not running -- skipping NC upgrade detection."
        return 0
    fi

    log "Declared NCVERSION in .env: ${declared_nc}"

    if (( DRY_RUN )); then
        echo -e "${CYAN}[dry-run]${NC} docker exec hermes_nextcloud php occ status --output=json"
        echo -e "${CYAN}[dry-run]${NC} (if live versionstring != ${declared_nc}: run occ upgrade + rehydrate apps)"
        return 0
    fi

    # Wait briefly for occ to be responsive (NC may still be initializing
    # after Phase 2's `docker compose up -d`).
    local status_json="" attempt
    for attempt in {1..15}; do
        status_json="$(docker exec hermes_nextcloud php occ status --output=json 2>/dev/null || true)"
        [[ -n "$status_json" ]] && break
        sleep 2
    done

    if [[ -z "$status_json" ]]; then
        warn "occ status returned no output after 30s -- skipping NC upgrade detection."
        warn "If a release included an NC bump, run manually: docker exec -u www-data hermes_nextcloud php /var/www/html/occ upgrade"
        return 0
    fi

    # Extract versionstring without depending on host jq.
    local live_nc
    live_nc="$(echo "$status_json" | grep -oE '"versionstring":"[^"]+"' \
        | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"

    if [[ -z "$live_nc" ]]; then
        warn "Could not parse versionstring from occ status output -- skipping NC upgrade detection."
        return 0
    fi

    # Match prefix: NC sometimes appends a build segment (e.g. live=30.0.15.1
    # vs declared=30.0.15). Prefix-match is the same rule test_nc_integration.sh uses.
    if [[ "$live_nc" == "$declared_nc"* ]]; then
        log "  Live NC version '${live_nc}' matches declared '${declared_nc}' ✓"
        return 0
    fi

    log "  NC version drift detected: live='${live_nc}' declared='${declared_nc}'"
    log "  Running occ upgrade (can take several minutes; output streamed to log)..."
    if ! docker exec -u www-data hermes_nextcloud php /var/www/html/occ upgrade 2>&1 | tee -a "$LOG_FILE"; then
        fatal "occ upgrade failed. See $LOG_FILE. NC is half-upgraded -- investigate before retrying."
    fi
    log "  occ upgrade complete ✓"

    # Rehydrate Hermes-required NC apps. NC's compatibility check
    # auto-disables apps it thinks are incompatible with the new core
    # version; re-enable them after upgrade. Mirrors the rehydrate loop
    # in scripts/test_nc_integration.sh.
    log "  Rehydrating Hermes-required NC apps..."
    local app
    for app in user_oidc mail twofactor_totp twofactor_backupcodes external; do
        if docker exec -u www-data hermes_nextcloud php /var/www/html/occ app:enable "$app" >> "$LOG_FILE" 2>&1; then
            log "    enabled: ${app} ✓"
        else
            warn "    could not enable ${app} (see $LOG_FILE); test_nc_integration.sh will fail until resolved"
        fi
    done

    # Verify post-upgrade state.
    local post_status post_needsdb post_maint new_live_nc
    post_status="$(docker exec hermes_nextcloud php occ status --output=json 2>/dev/null || true)"
    post_needsdb="$(echo "$post_status" | grep -oE '"needsDbUpgrade":(true|false)' | head -1 | cut -d: -f2)"
    post_maint="$(echo "$post_status" | grep -oE '"maintenance":(true|false)' | head -1 | cut -d: -f2)"
    new_live_nc="$(echo "$post_status" | grep -oE '"versionstring":"[^"]+"' \
        | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"

    if [[ "$post_needsdb" == "true" ]]; then
        fatal "Post-upgrade: NC still reports needsDbUpgrade=true. Investigate before continuing."
    fi
    if [[ "$post_maint" == "true" ]]; then
        warn "Post-upgrade: NC is still in maintenance mode. Disable with:"
        warn "  docker exec -u www-data hermes_nextcloud php /var/www/html/occ maintenance:mode --off"
    fi

    log "  Nextcloud upgraded: ${live_nc} → ${new_live_nc} ✓"
}

# Prompt yes/no unless --yes was passed OR we're in --dry-run mode.
# Dry-run skips the prompt because nothing is at risk (no changes are made).
confirm() {
    local prompt="${1:-Continue?}"
    if (( ASSUME_YES )) || (( DRY_RUN )); then
        return 0
    fi
    local reply
    read -r -p "$prompt [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
preflight() {
    header "Preflight"

    # Reconcile tracked-file drift instead of refusing.
    #
    # In the git-deploy model the tracked tree is authoritative-from-the-release;
    # real runtime state lives in the data mounts and in UNTRACKED files (HMAC/ARC
    # keys, .env, .hermes_install_config, install-state, restored GPG keyrings).
    # Tracked files routinely drift on their own: the fail2ban image rewrites its
    # shipped action.d/filter.d configs, SpamAssassin rewrites its Bayes DB,
    # OpenLDAP rewrites its runtime ldif, and a restore/rehost leaves a pile of
    # diffs. That drift is EXPECTED and must never block an upgrade (a customer who
    # restored from backup would otherwise be unable to update at all).
    #
    # So: save a recovery patch of any tracked drift, then let Phase 1 force the
    # checkout (which discards that drift and lands exactly on the release).
    # UNTRACKED files are never touched here -- keys/.env/restored data are safe.
    cd "$HERMES_ROOT"
    if ! git diff --quiet || ! git diff --cached --quiet; then
        local drift_patch="${LOG_FILE%.log}_discarded-tracked-drift.patch"
        git diff HEAD > "$drift_patch" 2>/dev/null || true
        warn "Tracked files differ from git -- expected runtime/restore drift, NOT a blocker."
        warn "A recovery patch of the changes Phase 1 will discard was saved to:"
        warn "  ${drift_patch}"
        warn "Untracked files (keys, .env, .hermes_install_config, restored data) are left untouched."
    else
        log "Working tree clean ✓"
    fi

    # hermes_db_server running
    if ! docker ps --format '{{.Names}}' | grep -q '^hermes_db_server$'; then
        fatal "hermes_db_server is not running. Start it first: docker compose up -d hermes_db_server"
    fi
    log "hermes_db_server running ✓"

    # Decide how to authenticate as root BEFORE anything reads the DB --
    # get_current_build_no() below is a hard fatal on empty, so an unresolved
    # connection would abort the upgrade with a misleading "could not read
    # build_no" instead of naming the real problem.
    resolve_db_auth

    # Read current build_no
    CURRENT_BUILD="$(get_current_build_no)"
    if [[ -z "$CURRENT_BUILD" ]]; then
        fatal "Could not read system_settings.build_no from hermes_db_server."
    fi
    log "Current build_no: ${CURRENT_BUILD}"

    # Resolve target tag
    TARGET_TAG="$(resolve_target_tag)"
    log "Target tag:      ${TARGET_TAG}"

    # Same? Nothing to do.
    if [[ "$CURRENT_BUILD" == "$TARGET_TAG" ]]; then
        log "Already at ${TARGET_TAG} — nothing to update."
        exit 0
    fi

    # Target older than current? Refuse.
    if [[ "$(compare_versions "$TARGET_TAG" "$CURRENT_BUILD")" == "-1" ]]; then
        fatal "Target tag ${TARGET_TAG} is older than current build ${CURRENT_BUILD}. Refusing to downgrade."
    fi

    # Confirm
    log "Upgrade path: ${CURRENT_BUILD} → ${TARGET_TAG}"
    if ! confirm "Proceed with upgrade?"; then
        log "Aborted by user."
        exit 0
    fi
}

# ---------------------------------------------------------------------------
# Phase 1 — Pull new code
# ---------------------------------------------------------------------------
phase1_pull_code() {
    header "Phase 1 — Pull new code"

    if (( SKIP_GIT )); then
        log "Skipping git operations (--skip-git)."
        return 0
    fi

    cd "$HERMES_ROOT"
    log "git fetch --tags ${REMOTE}..."
    run git fetch --tags --quiet "$REMOTE"

    # Verify the target tag actually exists locally after fetch.
    if (( ! DRY_RUN )); then
        if ! git rev-parse --verify --quiet "refs/tags/${TARGET_TAG}" >/dev/null; then
            fatal "Tag ${TARGET_TAG} not found after fetch from ${REMOTE}. Is the release tag pushed to that remote?"
        fi
    fi

    # Force the checkout so runtime/restore drift in TRACKED files can never block
    # the upgrade (the preflight already saved a recovery patch of that drift).
    # `-f` discards local tracked modifications and overwrites any untracked file
    # that sits at a path this release tracks (e.g. a config the release now ships)
    # -- which is the correct outcome: the release version wins. It does NOT delete
    # unrelated untracked files: keys, .env, .hermes_install_config and restored
    # data live at paths the repo never tracks, so they are left in place.
    log "git checkout -f ${TARGET_TAG} (forces past any runtime/restore drift)..."
    run git checkout -f --quiet "$TARGET_TAG"

    log "Phase 1 complete."
}

# ---------------------------------------------------------------------------
# Phase 2 — Update containers
# ---------------------------------------------------------------------------
phase2_update_containers() {
    header "Phase 2 — Update containers"

    if (( SKIP_COMPOSE )); then
        log "Skipping container updates (--skip-compose)."
        return 0
    fi

    cd "$HERMES_ROOT"

    # Pre-container migration hook: run each pending release's pre-scripts/
    # BEFORE compose pull + up. Required when a release adds new bind-mount
    # source paths in docker-compose.yml (e.g. new Docker secrets sourced
    # from new files in creds/). Without this, `docker compose up` would
    # fail on "bind source path does not exist" because the migration
    # creating those files lives in Phase 3.
    #
    # Each release dir CAN have a pre-scripts/ directory (optional). Scripts
    # are run in sorted order, must be idempotent. Conventionally numbered
    # NN-name.sh.
    local pending ver
    pending="$(find_pending_releases "$CURRENT_BUILD")"
    while IFS= read -r ver; do
        [[ -z "$ver" ]] && continue
        local pre_dir="${HERMES_ROOT}/updates/${ver}/pre-scripts"
        if [[ -d "$pre_dir" ]]; then
            shopt -s nullglob
            local pre_files=( "${pre_dir}"/*.sh )
            shopt -u nullglob
            if (( ${#pre_files[@]} > 0 )); then
                log "Running ${ver} pre-container scripts (${#pre_files[@]} file(s))..."
                IFS=$'\n' pre_files=( $(printf '%s\n' "${pre_files[@]}" | sort) )
                unset IFS
                local f rel
                for f in "${pre_files[@]}"; do
                    rel="${f#${HERMES_ROOT}/}"
                    log "  pre-scripts/ ${rel}"
                    if (( DRY_RUN )); then
                        echo -e "    ${CYAN}[dry-run]${NC} bash $f"
                    else
                        if ! bash "$f" 2>>"$LOG_FILE"; then
                            fatal "Failed to run pre-container script ${rel} (see $LOG_FILE)"
                        fi
                    fi
                done
            fi
        fi
    done <<< "$pending"

    log "docker compose pull (--quiet, suppresses per-layer progress)..."
    run docker compose pull --quiet

    # --build is REQUIRED here, same as the installer's `up -d --build`.
    # hermes_fail2ban is the one service built locally from its Dockerfile
    # (mariadb-client + iptables-backend detection on top of the upstream
    # lscr.io/linuxserver/fail2ban image); it is NOT pushed to a registry.
    # The `pull` above fetches the vanilla upstream fail2ban over the locally
    # built image, so without --build the upgrade would silently drop those
    # customizations. --build is a no-op for the image-only services.
    log "docker compose up -d --build (rebuilds fail2ban; restarts services whose config/image changed)..."
    run docker compose up -d --build

    log "Phase 2 complete."
}

# ---------------------------------------------------------------------------
# Phase 3 — Apply per-release artifacts
# ---------------------------------------------------------------------------
phase3_apply_release_artifacts() {
    header "Phase 3 — Apply per-release artifacts"

    local pending
    pending="$(find_pending_releases "$CURRENT_BUILD")"

    if [[ -z "$pending" ]]; then
        log "No updates/v<DATE>/ directories newer than ${CURRENT_BUILD}. Nothing to apply."
        return 0
    fi

    log "Pending releases to apply (chronological):"
    while IFS= read -r ver; do
        log "  - $ver"
    done <<< "$pending"

    # Wait for hermes_commandbox to be reachable (Phase 2 may have restarted it).
    # Each phase 3 cfml artifact will call into the commandbox, so make sure it's up.
    if ! (( DRY_RUN )); then
        if docker ps --format '{{.Names}}' | grep -q '^hermes_commandbox$'; then
            local i
            for i in {1..30}; do
                if docker exec hermes_commandbox curl -sf --max-time 2 http://localhost:8888/ >/dev/null 2>&1; then
                    break
                fi
                if (( i == 30 )); then
                    warn "hermes_commandbox is running but http://localhost:8888/ is not responding after 60s. CFML artifacts may fail."
                fi
                sleep 2
            done
        fi
    fi

    # Walk each release directory in order.
    local ver dir
    while IFS= read -r ver; do
        dir="${HERMES_ROOT}/updates/${ver}"
        header "Applying ${ver}"

        # ---- sql/ ----
        if [[ -d "${dir}/sql" ]]; then
            shopt -s nullglob
            local sql_files=( "${dir}/sql"/*.sql )
            shopt -u nullglob
            if (( ${#sql_files[@]} > 0 )); then
                local f
                # Sort alphabetically
                IFS=$'\n' sql_files=( $(printf '%s\n' "${sql_files[@]}" | sort) )
                unset IFS
                for f in "${sql_files[@]}"; do
                    local rel="${f#${HERMES_ROOT}/}"
                    log "  sql/  ${rel}"
                    if (( DRY_RUN )); then
                        echo -e "    ${CYAN}[dry-run]${NC} db_root_import hermes < $f"
                    else
                        if ! db_root_import hermes < "$f"; then
                            fatal "Failed to apply ${rel} (see $LOG_FILE for details)"
                        fi
                    fi
                done
            fi
        fi

        # ---- cfml/ ----
        if [[ -d "${dir}/cfml" ]]; then
            shopt -s nullglob
            local cfml_files=( "${dir}/cfml"/*.cfm )
            shopt -u nullglob
            if (( ${#cfml_files[@]} > 0 )); then
                IFS=$'\n' cfml_files=( $(printf '%s\n' "${cfml_files[@]}" | sort) )
                unset IFS
                local f
                for f in "${cfml_files[@]}"; do
                    local rel="${f#${HERMES_ROOT}/}"
                    log "  cfml/ ${rel}"
                    # CFML migration is invoked via curl from inside the commandbox container.
                    # The container path mirrors host path under /var/www/html-equivalent;
                    # we mount updates/ in (TBD on first-real-use; document this caveat
                    # in the methodology doc when first CFML migration ships).
                    if (( DRY_RUN )); then
                        echo -e "    ${CYAN}[dry-run]${NC} docker exec hermes_commandbox /usr/bin/curl --silent http://localhost:8888/updates/${ver}/cfml/$(basename "$f")"
                    else
                        # NOTE for MVP: there is no volume mount that maps host updates/
                        # into the commandbox container. The first release that needs
                        # a CFML migration will require adding that mount + setting up
                        # a Lucee mapping or symlink. For now we WARN if any .cfm
                        # artifact exists, rather than silently fail.
                        warn "CFML artifacts not yet wired into commandbox container — skipping ${rel}."
                        warn "First release with a real cfml/ migration will need to mount updates/ into hermes_commandbox + add a Lucee mapping."
                    fi
                done
            fi
        fi

        # ---- scripts/ ----
        if [[ -d "${dir}/scripts" ]]; then
            shopt -s nullglob
            local sh_files=( "${dir}/scripts"/*.sh )
            shopt -u nullglob
            if (( ${#sh_files[@]} > 0 )); then
                IFS=$'\n' sh_files=( $(printf '%s\n' "${sh_files[@]}" | sort) )
                unset IFS
                local f
                for f in "${sh_files[@]}"; do
                    local rel="${f#${HERMES_ROOT}/}"
                    log "  scripts/ ${rel}"
                    if (( DRY_RUN )); then
                        echo -e "    ${CYAN}[dry-run]${NC} bash $f"
                    else
                        if ! bash "$f" 2>>"$LOG_FILE"; then
                            fatal "Failed to run ${rel} (see $LOG_FILE for details)"
                        fi
                    fi
                done
            fi
        fi

        # build_no is advanced by the release's schema_updates.sql at its end.
        # Re-read to confirm.
        if ! (( DRY_RUN )); then
            local stamped
            stamped="$(get_current_build_no)"
            if [[ "$stamped" != "$ver" ]]; then
                warn "After applying ${ver}, build_no is '${stamped}' (expected '${ver}'). Did this release's schema_updates.sql include the version stamp?"
            else
                log "  build_no advanced to ${stamped} ✓"
            fi
        fi
    done <<< "$pending"

    log "Phase 3 complete."
}

# ---------------------------------------------------------------------------
# Phase 4 — Standard finalize
# ---------------------------------------------------------------------------
phase4_finalize() {
    header "Phase 4 — Standard finalize"

    # MVP scope: restart hermes_commandbox so it picks up any schedule/,
    # admin/2/, or schema changes that aren't auto-detected by Lucee.
    # v2 will diff config files between tags to know which containers
    # specifically need restart (avoiding the unnecessary churn of always
    # restarting commandbox).
    log "Restarting hermes_commandbox (MVP: always)..."
    run docker compose restart hermes_commandbox

    # Postfix reads master.cf and main.cf ONCE at startup. Both are tracked and
    # bind-mounted, so phase 1's checkout can change them under a running
    # container without Postfix noticing: `compose up -d` recreates a container
    # when its DEFINITION changes (image, env, ports, volume list), not when the
    # CONTENTS of a bind-mounted file change.
    #
    # That bit in v260807, which enabled the submission and smtps listeners in
    # master.cf. It happened to apply anyway because every image was rebuilt that
    # release, so all containers were recreated. A release that ships only a
    # config change would have gone unapplied and looked fine (#292).
    #
    # Restarting unconditionally rather than diffing: Postfix restarts in about a
    # second, the queue is on disk so nothing is lost, and a missed config change
    # is far more expensive to diagnose than a second of downtime.
    log "Restarting hermes_postfix_dkim (picks up master.cf / main.cf changes)..."
    run docker compose restart hermes_postfix_dkim

    # Wait briefly for it to come back up.
    if ! (( DRY_RUN )); then
        local i
        for i in {1..30}; do
            if docker exec hermes_commandbox curl -sf --max-time 2 http://localhost:8888/ >/dev/null 2>&1; then
                log "  hermes_commandbox back up ✓"
                break
            fi
            if (( i == 30 )); then
                warn "hermes_commandbox did not respond on :8888 within 60s. Phase 5 may fail."
            fi
            sleep 2
        done
    fi

    # Ofelia schedule re-render (#288).
    #
    # Two reasons this must run on EVERY upgrade, not just the release that
    # introduced it:
    #
    #  1. config/ofelia/config.ini is a generated artifact that is tracked in
    #     the repo and bind-mounted onto /etc/ofelia. Phase 1's `git` step
    #     therefore OVERWRITES the live, correctly-rendered schedule with the
    #     repo's snapshot on every single upgrade -- discarding the admin's
    #     substituted notification addresses and any job rows added since.
    #     Re-rendering from `ofelia_jobs` afterwards makes that self-healing.
    #
    #  2. Installs predating #288 are running the snapshot frozen at v260612:
    #     missing the mail-queue health check, DMARC reports, Authelia log
    #     rotation and the fangfrisch malware-feed refresh, and still calling
    #     the pre-#218 update_check.sh (the cause of a permanent "UPDATE CHECK
    #     PENDING" on the dashboard).
    #
    # apply_schema_updates() has always deferred this here by design -- see its
    # closing note that service config regens are the orchestrator's concern.
    # Non-fatal: a failed render leaves the previous schedule in place.
    if (( DRY_RUN )); then
        echo -e "${CYAN}[dry-run]${NC} docker exec hermes_commandbox curl --silent http://localhost:8888/schedule/regen_ofelia_config.cfm"
    else
        log "Re-rendering Ofelia schedule from ofelia_jobs..."
        local ofelia_resp
        if ! ofelia_resp=$(docker exec hermes_commandbox /usr/bin/curl --silent --max-time 300 \
                               http://localhost:8888/schedule/regen_ofelia_config.cfm 2>&1); then
            warn "Ofelia schedule render failed. Output:"
            echo "$ofelia_resp" | tee -a "$LOG_FILE"
            warn "Continuing — re-run later with: ./scripts/install_hermes_docker.sh --render-ofelia"
        elif [[ "$ofelia_resp" == *OFELIA_CONFIG_REGEN_OK* ]]; then
            log "  Ofelia schedule rendered; hermes_ofelia restarted ✓"
        else
            echo "$ofelia_resp" | tee -a "$LOG_FILE"
            warn "Ofelia render did not confirm success — check the scheduler after the upgrade."
        fi
    fi

    # NCVERSION change detection + automated upgrade (#264).
    # If .env's NCVERSION differs from what NC is currently running,
    # run `occ upgrade` and rehydrate Hermes-required NC apps. This
    # makes customer-side NCVERSION bumps a fully-automated path -- no
    # manual occ step required after pulling a release that includes an
    # NC bump.
    nc_upgrade_if_needed


    # *.HERMES template re-render reminder.
    log "Reminder: if this release modified any config/<service>/etc/.../*.HERMES template,"
    log "  the corresponding admin page must be re-saved to regenerate the live config file."
    log "  v2 of this orchestrator will detect + trigger these automatically."

    log "Phase 4 complete."
}

# ---------------------------------------------------------------------------
# Phase 5 — Post-upgrade hook
# ---------------------------------------------------------------------------
phase5_post_upgrade() {
    header "Phase 5 — Post-upgrade hook"

    if (( DRY_RUN )); then
        echo -e "${CYAN}[dry-run]${NC} docker exec hermes_commandbox curl --silent http://localhost:8888/schedule/post_upgrade.cfm"
        return 0
    fi

    local resp
    if ! resp=$(docker exec hermes_commandbox /usr/bin/curl --silent --max-time 600 \
                    http://localhost:8888/schedule/post_upgrade.cfm 2>&1); then
        warn "post_upgrade.cfm invocation failed. Output:"
        echo "$resp" | tee -a "$LOG_FILE"
        warn "Continuing — post_upgrade is non-fatal for the orchestrator."
        return 0
    fi
    echo "$resp" | tee -a "$LOG_FILE"
    log "Phase 5 complete."
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
summarize() {
    header "Update complete"

    if (( DRY_RUN )); then
        log "Dry run finished. No changes were made."
        log "Re-run without --dry-run to apply."
        return 0
    fi

    local final_build
    final_build="$(get_current_build_no)"
    log "build_no:  ${CURRENT_BUILD} → ${final_build}"
    log "Log file:  ${LOG_FILE}"

    if [[ "$final_build" != "$TARGET_TAG" ]]; then
        warn "Final build_no '${final_build}' does not match target tag '${TARGET_TAG}'."
        warn "Some release artifacts may have failed. Inspect $LOG_FILE."
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    header "Hermes SEG Update Orchestrator (#221)"
    log "HERMES_ROOT: $HERMES_ROOT"
    log "Log file:    $LOG_FILE"
    if (( DRY_RUN )); then
        log "Mode:        DRY RUN (no changes will be made)"
    fi

    preflight

    # SELF-UPDATE: After Phase 1 git checkout, this script file on disk may
    # have changed (e.g. release adds new orchestrator features like the
    # pre-scripts/ hook below). bash is running the OLD script from memory,
    # so the new logic wouldn't fire unless we re-exec. Re-exec'ing the
    # second incarnation runs phases 2-5 against the target tag's logic.
    #
    # HERMES_UPDATE_REEXEC env var marks the second incarnation so we don't
    # infinite-loop. --skip-git skips the re-exec because operator pulled
    # manually (so the script on disk = the running script already).
    if [[ "${HERMES_UPDATE_REEXEC:-0}" != "1" ]] && (( ! SKIP_GIT )); then
        phase1_pull_code
        log ""
        log "Re-executing system_update_docker.sh from the newly-checked-out tag"
        log "so phases 2-5 run against the target version's orchestrator logic."
        log ""
        export HERMES_UPDATE_REEXEC=1
        # ORIG_ARGV, not "$@" -- see the note at the parser. `main "$@"` is
        # handed an already-emptied argv, so "$@" here forwards nothing.
        exec "$0" "${ORIG_ARGV[@]}"
    fi

    # Second incarnation (or --skip-git). phase1_pull_code is idempotent --
    # if already at target tag it's a no-op. Safe to call again here.
    phase1_pull_code
    phase2_update_containers
    phase3_apply_release_artifacts
    phase4_finalize
    phase5_post_upgrade
    summarize
}

main "$@"
