#!/usr/bin/env bash
# Shared helpers for regression checks. Sourced, never run directly.
#
# A check prints PASS/FAIL/SKIP lines and exits:
#   0 = all assertions passed, 1 = at least one failed, 2 = skipped (not applicable here)

set -uo pipefail

# ---- Install root: walk up to docker-compose.yml ----
_here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_ROOT="${HERMES_ROOT:-$_here}"
while [[ "$HERMES_ROOT" != "/" && ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
    HERMES_ROOT="$(dirname "$HERMES_ROOT")"
done
if [[ "$HERMES_ROOT" == "/" ]]; then
    echo "  FAIL  cannot find docker-compose.yml above $_here (run from inside the install root)"
    exit 1
fi
cd "$HERMES_ROOT" || exit 1

_FAILED=0
pass() { echo "  PASS  $*"; }
fail() { echo "  FAIL  $*"; _FAILED=1; }
skip() { echo "  SKIP  $*"; exit 2; }
done_check() { exit "$_FAILED"; }

# ---- Root DB access: socket, then client defaults, then the mounted secret ----
# Same order as scripts/system_update_docker.sh resolve_db_auth(): which one
# works differs per host.
_DB_AUTH=""
_db_resolve() {
    if docker exec hermes_db_server mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
        _DB_AUTH=root
    elif docker exec hermes_db_server mysql -N -s -e "SELECT 1" >/dev/null 2>&1; then
        _DB_AUTH=default
    elif docker exec hermes_db_server sh -c \
            'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD 2>/dev/null); export MYSQL_PWD; mysql -u root -e "SELECT 1"' \
            >/dev/null 2>&1; then
        _DB_AUTH=password
    else
        _DB_AUTH=none
    fi
}

# db <sql>  -- query the hermes DB, rows on stdout, empty on failure
db() {
    [[ -z "$_DB_AUTH" ]] && _db_resolve
    case "$_DB_AUTH" in
        default)  docker exec hermes_db_server mysql -N -s hermes -e "$1" 2>/dev/null ;;
        password) docker exec hermes_db_server sh -c \
                      'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD); export MYSQL_PWD; exec mysql -u root -N -s hermes -e "$1"' \
                      _ "$1" 2>/dev/null ;;
        root)     docker exec hermes_db_server mysql -u root -N -s hermes -e "$1" 2>/dev/null ;;
        *)        return 1 ;;
    esac
}

# wait_for <seconds> <command...>  -- retry until the command succeeds
wait_for() {
    local t=$1; shift
    local i
    for ((i = 0; i < t; i++)); do
        "$@" && return 0
        sleep 1
    done
    return 1
}
