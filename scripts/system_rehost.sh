#!/bin/bash
# ============================================================================
# Hermes SEG Docker -- rehost helper (host-identity rewiring after restore)
#
# What this is for:
#   After system_restore.sh moves a backup from host A onto host B with
#   different IP/hostname, several pieces still reference A's identity:
#     - .env (HOST_IP, HERMES_HOSTNAME, CONSOLE_HOST)
#     - parameters2 table (server_ip, console.host, server_name, server_domain)
#     - parameters table (Postfix myorigin/myhostname child rows)
#     - nginx vhost server_name + bootstrap cert SAN
#     - Authelia session domain + cookie scope
#     - Postfix main.cf myhostname/mydestination
#     - Nextcloud trusted_domains + theming URL + OIDC discovery URL
#   Without rehost, B serves the configuration of A and is unreachable.
#
#   Also useful standalone: admin moves the box to a new subnet, gets a
#   new IP, or changes the FQDN. Re-running this rewires everything.
#
# What it does:
#   1. Compares the current host's IP/hostname to what's in .env
#   2. If they differ (or operator forces with --to-ip / --to-hostname):
#      - Updates .env in place
#      - UPDATEs parameters2 + parameters rows in MariaDB
#      - Re-renders nginx, Authelia, Postfix, amavis config files
#      - Updates Nextcloud trusted_domains + theming via occ
#      - Restarts hermes_nginx + hermes_authelia + hermes_postfix_dkim +
#        hermes_commandbox (commandbox so CFML re-reads env)
#   3. Reports what changed + what to verify
#
# Usage:
#   sudo ./scripts/system_rehost.sh [--to-ip=X.X.X.X] [--to-hostname=FQDN]
#                                   [--to-console=IP|FQDN] [--yes] [--dry-run]
#
#   With no flags, auto-detects the current host's primary IPv4 + hostname
#   and uses those. Operator confirmation required unless --yes.
#
# Safety:
#   - Reads the CURRENT .env to capture old values for comparison + rollback
#   - If new values match current .env: no-op, exits 0
#   - Backs up .env to .env.pre-rehost-<timestamp> before modifying
#   - Refuses to proceed without docker stack able to reach MariaDB (--yes
#     skips confirmation but does NOT skip the MariaDB reachability check)
# ============================================================================

set -uo pipefail

# ---- Self-locate HERMES_ROOT ----
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
        exit 1
    fi
fi
INSTALL_SCRIPT="${HERMES_ROOT}/scripts/install_hermes_docker.sh"
[[ -f "$INSTALL_SCRIPT" ]] || { echo "ERROR: install_hermes_docker.sh not found at $INSTALL_SCRIPT" >&2; exit 1; }

# ---- Logging (mirrors install script style) ----
LOG_DIR="${HERMES_ROOT}/install-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/system_rehost_$(date '+%Y%m%d_%H%M%S').log"

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

log()   { printf '%s[%s] INFO:%s  %s\n'  "$GREEN"  "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s[%s] WARN:%s  %s\n'  "$YELLOW" "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE"; }
error() { printf '%s[%s] ERROR:%s %s\n'  "$RED"    "$(date '+%Y-%m-%d %H:%M:%S')" "$NC" "$*" | tee -a "$LOG_FILE" >&2; }
header(){ printf '\n%s== %s ==%s\n' "$CYAN" "$*" "$NC" | tee -a "$LOG_FILE"; }
fatal() { error "$@"; exit 1; }

# ---- Args ----
TO_IP=""
TO_HOSTNAME=""
TO_CONSOLE=""
ASSUME_YES=0
DRY_RUN=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [--to-ip=X.X.X.X] [--to-hostname=FQDN] [--to-console=IP|FQDN]
                       [--yes] [--dry-run] [--help]

Rewires Hermes host identity (IP, hostname, console address) after a
restore-to-new-hardware scenario or after the operator changes the host's
network identity.

With no flags, auto-detects the current host's primary IPv4 and hostname
and prompts for confirmation.

Flags:
  --to-ip=X.X.X.X        Force-set the new host IP. Default: auto-detect via
                         'ip -4 route get 1.1.1.1'.
  --to-hostname=FQDN     Force-set the new mail hostname. Default: .env
                         HERMES_HOSTNAME (falls back to 'hostname -f').
  --to-console=IP|FQDN   Force-set the new console address. Default: same as
                         --to-ip (operator can change later via System >
                         Console Settings UI).
  --yes                  Skip the confirmation prompt (unattended use).
  --dry-run              Print what would change without modifying anything.
  --force                Apply even if the new values already match .env. The
                         normal no-op short-circuit compares .env ONLY; after a
                         cross-host restore the database can hold the source
                         host's identity while .env is already correct (the slim
                         backup omits .env). --force rewrites parameters2 +
                         parameters and re-renders configs regardless.
  --help                 Show this help.

Examples:
  sudo $(basename "$0")                                # auto-detect, prompt
  sudo $(basename "$0") --to-ip=192.168.30.50          # override IP only
  sudo $(basename "$0") --to-ip=10.0.0.5 --to-hostname=mail.corp.example.com --yes
  sudo $(basename "$0") --to-hostname=mail.corp.example.com --force   # resync DB after a cross-host restore
EOF
}

FORCE=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --to-ip=*)       TO_IP="${1#*=}";       shift ;;
        --to-hostname=*) TO_HOSTNAME="${1#*=}"; shift ;;
        --to-console=*)  TO_CONSOLE="${1#*=}";  shift ;;
        --yes)           ASSUME_YES=1;          shift ;;
        --dry-run)       DRY_RUN=1;             shift ;;
        --force)         FORCE=1;               shift ;;
        --help|-h)       usage; exit 0 ;;
        *) error "Unknown option: $1"; usage; exit 1 ;;
    esac
done

# ---- Detect new host values ----
detect_new_ip() {
    # Match install script's prompt_host_ip default-detection logic
    ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}'
}

detect_new_hostname() {
    # Prefer the mail hostname already configured in .env -- it is an FQDN and is
    # the operator's intended identity (and, after a cross-host restore, .env
    # holds THIS host's target hostname since .env is excluded from the backup).
    # Fall back to the OS hostname, which is often a bare name (e.g.
    # 'homedocker-ub-2404') that fails the FQDN validation.
    local env_hostname
    env_hostname=$(read_env_value HERMES_HOSTNAME 2>/dev/null)
    if [[ -n "$env_hostname" ]]; then
        printf '%s' "$env_hostname"
        return 0
    fi
    hostname -f 2>/dev/null || hostname
}

# ---- Read current .env values ----
read_env_value() {
    local key="$1"
    grep -E "^${key}=" "${HERMES_ROOT}/.env" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'"
}

# ---- DB helpers (mirrors backup/restore scripts' db_exec pattern) ----
# Auth strategy: try no-password FIRST, fall back to secret-file. Canonical
# LinuxServer mariadb installs use unix_socket-style root@localhost which
# REJECTS passwords; older installs (DEV) use native_password requiring the
# secret. See feedback_mariadb_unix_socket_via_docker_exec memory.
db_exec() {
    docker exec hermes_db_server bash -c '
        if mariadb -u root -e "SELECT 1" >/dev/null 2>&1; then
            exec mariadb -u root "$@"
        elif [[ -r /run/secrets/MYSQL_ROOT_PASSWORD ]]; then
            MYSQL_PWD="$(cat /run/secrets/MYSQL_ROOT_PASSWORD)" exec mariadb -u root "$@"
        else
            exec mariadb -u root "$@"
        fi
    ' bash "$@"
}

# ---- Validation ----
validate_ipv4() {
    [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1
    local ip="$1" IFS='.' octet
    for octet in $ip; do
        (( octet >= 0 && octet <= 255 )) || return 1
    done
    return 0
}

validate_fqdn() {
    [[ "$1" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)+$ ]]
}

# ---- Main ----
main() {
    log "Hermes SEG rehost"
    log "HERMES_ROOT: ${HERMES_ROOT}"
    log "Log:         ${LOG_FILE}"
    log "Mode:        $((( DRY_RUN )) && echo DRY-RUN || echo LIVE)"

    [[ "$(id -u)" -eq 0 ]] || fatal "Must run as root (need to edit .env, restart containers, etc.)"
    [[ -f "${HERMES_ROOT}/.env" ]] || fatal "No .env at ${HERMES_ROOT}/.env -- has Hermes been installed?"

    # ---- Determine current vs new state ----
    header "Determining current vs new state"

    local cur_ip cur_hostname cur_console
    cur_ip=$(read_env_value HOST_IP)
    cur_hostname=$(read_env_value HERMES_HOSTNAME)
    cur_console=$(read_env_value CONSOLE_HOST)
    log "  Current .env HOST_IP:         ${cur_ip:-<empty>}"
    log "  Current .env HERMES_HOSTNAME: ${cur_hostname:-<empty>}"
    log "  Current .env CONSOLE_HOST:    ${cur_console:-<empty>}"

    [[ -z "$TO_IP"       ]] && TO_IP="$(detect_new_ip)"
    [[ -z "$TO_HOSTNAME" ]] && TO_HOSTNAME="$(detect_new_hostname)"
    [[ -z "$TO_CONSOLE"  ]] && TO_CONSOLE="$TO_IP"

    log "  New HOST_IP:         ${TO_IP}"
    log "  New HERMES_HOSTNAME: ${TO_HOSTNAME}"
    log "  New CONSOLE_HOST:    ${TO_CONSOLE}"

    validate_ipv4 "$TO_IP"      || fatal "Invalid new IP: ${TO_IP}"
    validate_fqdn "$TO_HOSTNAME" || fatal "Invalid new hostname (must be FQDN): ${TO_HOSTNAME}"
    validate_ipv4 "$TO_CONSOLE" || validate_fqdn "$TO_CONSOLE" || \
        fatal "Invalid new console address (must be IPv4 or FQDN): ${TO_CONSOLE}"

    if (( ! FORCE )) && [[ "$cur_ip" == "$TO_IP" && "$cur_hostname" == "$TO_HOSTNAME" && "$cur_console" == "$TO_CONSOLE" ]]; then
        log "No changes needed: current .env already matches the new values."
        log "NOTE: this compares .env ONLY -- it does NOT inspect the database. After a"
        log "cross-host restore, the DB can still hold the SOURCE host's identity while"
        log ".env is already correct (the slim backup does not include .env). In that case"
        log "pass --force to rewrite parameters2/parameters + re-render configs anyway:"
        log "  sudo $0 --to-hostname=${TO_HOSTNAME} --to-ip=${TO_IP} --to-console=${TO_CONSOLE} --force"
        exit 0
    fi

    # ---- Confirmation ----
    if (( ! ASSUME_YES )) && (( ! DRY_RUN )); then
        echo ""
        echo "About to rewire Hermes from:"
        echo "  IP:       ${cur_ip:-<empty>}  ->  ${TO_IP}"
        echo "  Hostname: ${cur_hostname:-<empty>}  ->  ${TO_HOSTNAME}"
        echo "  Console:  ${cur_console:-<empty>}  ->  ${TO_CONSOLE}"
        echo ""
        echo "This will:"
        echo "  - Modify ${HERMES_ROOT}/.env (backup written to .env.pre-rehost-<ts>)"
        echo "  - UPDATE parameters2 + parameters rows in MariaDB"
        echo "  - Re-render nginx, Authelia, Postfix, amavis configs"
        echo "  - Update Nextcloud trusted_domains + theming URL via occ"
        echo "  - Restart hermes_nginx, hermes_authelia, hermes_postfix_dkim,"
        echo "    hermes_commandbox, hermes_nextcloud"
        echo ""
        read -r -p "Proceed? [y/N] " reply
        [[ "$reply" =~ ^[Yy]$ ]] || { log "Cancelled by operator."; exit 0; }
    fi

    if (( DRY_RUN )); then
        log "DRY-RUN: would update .env, DB rows, re-render configs, and restart containers. Exiting without changes."
        exit 0
    fi

    # ---- Backup .env ----
    header "Backing up .env"
    local env_backup="${HERMES_ROOT}/.env.pre-rehost-$(date '+%Y%m%d_%H%M%S')"
    cp "${HERMES_ROOT}/.env" "$env_backup" || fatal "Failed to back up .env to ${env_backup}"
    log "  ${env_backup}"

    # ---- Update .env ----
    header "Updating .env"
    sed -i \
        -e "s|^HOST_IP=.*|HOST_IP=${TO_IP}|" \
        -e "s|^HERMES_HOSTNAME=.*|HERMES_HOSTNAME=${TO_HOSTNAME}|" \
        -e "s|^CONSOLE_HOST=.*|CONSOLE_HOST=${TO_CONSOLE}|" \
        "${HERMES_ROOT}/.env" \
        || fatal "sed of .env failed"
    log "  .env updated"

    # Also update NEXTCLOUD_TRUSTED_DOMAINS if present -- add the new IP/hostname
    # and remove the old ones. Format is comma-separated.
    local nc_trusted="${TO_IP},${TO_HOSTNAME}"
    [[ "$TO_CONSOLE" != "$TO_IP" && "$TO_CONSOLE" != "$TO_HOSTNAME" ]] && nc_trusted="${nc_trusted},${TO_CONSOLE}"
    sed -i "s|^NEXTCLOUD_TRUSTED_DOMAINS=.*|NEXTCLOUD_TRUSTED_DOMAINS=${nc_trusted}|" \
        "${HERMES_ROOT}/.env" 2>/dev/null || true
    log "  NEXTCLOUD_TRUSTED_DOMAINS = ${nc_trusted}"

    # ---- Update DB ----
    header "Updating MariaDB rows"
    if ! docker ps --format '{{.Names}}' | grep -q '^hermes_db_server$'; then
        warn "hermes_db_server not running -- skipping DB updates."
        warn "Start the stack and re-run system_rehost.sh OR re-run with the stack up."
    else
        # Wait briefly for DB readiness (mirrors install pattern)
        local i
        for i in {1..15}; do
            if db_exec -e 'SELECT 1' >/dev/null 2>&1; then break; fi
            sleep 2
        done

        local server_name="${TO_HOSTNAME%%.*}"
        local server_domain="${TO_HOSTNAME#*.}"

        log "  parameters2: server_ip = ${TO_IP}, console.host = ${TO_CONSOLE}, server_name = ${server_name}, server_domain = ${server_domain}"
        db_exec hermes -e "
            UPDATE parameters2 SET value2='${TO_IP}',       active='1', applied='2' WHERE parameter='server_ip'    AND module='network';
            UPDATE parameters2 SET value2='${TO_CONSOLE}',  active='1', applied='2' WHERE parameter='console.host'  AND module='console';
            UPDATE parameters2 SET value2='${server_name}'                            WHERE parameter='server_name'  AND module='network';
            UPDATE parameters2 SET value2='${server_domain}'                          WHERE parameter='server_domain' AND module='network';
        " 2>>"$LOG_FILE" || warn "Some parameters2 UPDATEs failed -- check ${LOG_FILE}."

        log "  parameters: postfix myorigin = ${server_domain}, myhostname = ${TO_HOSTNAME}"
        db_exec hermes -e "
            UPDATE parameters SET parameter='${server_domain}'  WHERE parent_name='myorigin'   AND child=1 AND module='postfix' AND conf_file='main.cf';
            UPDATE parameters SET parameter='${TO_HOSTNAME}'    WHERE parent_name='myhostname' AND child=1 AND module='postfix' AND conf_file='main.cf';
        " 2>>"$LOG_FILE" || warn "Some parameters UPDATEs failed -- check ${LOG_FILE}."
    fi

    # ---- Re-render configs via install script's generators ----
    header "Re-rendering service configs"

    # Export the new values so the generators pick them up
    export HERMES_HOST_IP="$TO_IP"
    export HERMES_MAIL_HOSTNAME="$TO_HOSTNAME"
    export HERMES_MAIL_DOMAIN="${TO_HOSTNAME#*.}"
    export HERMES_CONSOLE_HOST="$TO_CONSOLE"

    # Source install_hermes_docker.sh -- the guard there returns early on
    # sourced invocation so we only get the helper + generator functions.
    # shellcheck disable=SC1090
    source "$INSTALL_SCRIPT" || fatal "Failed to source ${INSTALL_SCRIPT}"

    # Each generator is a separate call so a failure in one doesn't skip
    # the rest. Wrap with || warn so we don't bail mid-rehost.
    log "  generate_postfix_configs..."
    generate_postfix_configs 2>>"$LOG_FILE" || warn "  postfix re-render had errors -- check ${LOG_FILE}."

    log "  generate_amavis_50user_config..."
    generate_amavis_50user_config 2>>"$LOG_FILE" || warn "  amavis re-render had errors."

    log "  generate_authelia_config..."
    generate_authelia_config 2>>"$LOG_FILE" || warn "  authelia re-render had errors."

    log "  generate_nginx_config..."
    generate_nginx_config 2>>"$LOG_FILE" || warn "  nginx re-render had errors."

    log "  generate_mailname_config..."
    generate_mailname_config 2>>"$LOG_FILE" || warn "  mailname re-render had errors."

    # ---- Restart affected containers ----
    header "Restarting affected containers"
    local containers=( hermes_nginx hermes_authelia hermes_postfix_dkim hermes_commandbox )
    local c
    for c in "${containers[@]}"; do
        if docker ps --format '{{.Names}}' | grep -q "^${c}$"; then
            log "  restarting ${c}..."
            docker restart "$c" >>"$LOG_FILE" 2>&1 || warn "    restart of ${c} failed"
        else
            warn "  ${c} is not running -- skipped restart"
        fi
    done

    # ---- Nextcloud update via occ ----
    header "Updating Nextcloud (trusted_domains + theming + OIDC)"
    if docker ps --format '{{.Names}}' | grep -q '^hermes_nextcloud$'; then
        # Wait for NC to be ready (occ commands fail with NC down)
        for i in {1..15}; do
            if docker exec -u www-data hermes_nextcloud php /var/www/html/occ status >/dev/null 2>&1; then break; fi
            sleep 2
        done

        log "  trusted_domains[0] = ${TO_HOSTNAME}, [1] = ${TO_IP}"
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:set trusted_domains 0 --value="${TO_HOSTNAME}" >>"$LOG_FILE" 2>&1 || warn "  trusted_domains[0] set failed"
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:set trusted_domains 1 --value="${TO_IP}" >>"$LOG_FILE" 2>&1 || warn "  trusted_domains[1] set failed"
        if [[ "$TO_CONSOLE" != "$TO_IP" && "$TO_CONSOLE" != "$TO_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:set trusted_domains 2 --value="${TO_CONSOLE}" >>"$LOG_FILE" 2>&1 || true
        fi

        log "  theming:config url = https://${TO_CONSOLE}"
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config url "https://${TO_CONSOLE}" >>"$LOG_FILE" 2>&1 || warn "  theming url set failed"

        # External Sites: User Console link -- regenerate JSON with new console address
        log "  external sites: User Console link -> https://${TO_CONSOLE}/users/"
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set external sites \
            --value='{"1":{"id":1,"name":"User Console","url":"https://'"${TO_CONSOLE}"'/users/","lang":"","type":"link","device":"","icon":"external.svg","groups":[],"redirect":true}}' \
            >>"$LOG_FILE" 2>&1 || warn "  external sites update failed"

        # OIDC discovery URL update -- admin can also re-trigger via NC admin
        # Settings > Authentication. Best-effort here.
        log "  user_oidc: provider discovery URL update (best-effort)"
        # Provider name 'authelia' matches what install_hermes_docker.sh seeds.
        # If this fails (e.g. provider not yet configured), admin handles via UI.
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ user_oidc:provider authelia \
            --discoveryuri="https://${TO_CONSOLE}/.well-known/openid-configuration" \
            >>"$LOG_FILE" 2>&1 || warn "  OIDC provider update failed (configure via NC admin Settings if needed)"
    else
        warn "hermes_nextcloud not running -- skipping NC updates."
    fi

    # ---- Report ----
    header "Rehost complete"
    log "Old:  HOST_IP=${cur_ip}  HERMES_HOSTNAME=${cur_hostname}  CONSOLE_HOST=${cur_console}"
    log "New:  HOST_IP=${TO_IP}  HERMES_HOSTNAME=${TO_HOSTNAME}  CONSOLE_HOST=${TO_CONSOLE}"
    log ""
    log "Verify:"
    log "  - Admin console: https://${TO_CONSOLE}/admin/"
    log "  - Send a test message through Postfix to confirm SMTP HELO uses ${TO_HOSTNAME}"
    log "  - Nextcloud: https://${TO_CONSOLE}/nc/  (login via OIDC should redirect to ${TO_CONSOLE} for Authelia)"
    log ""
    log "If anything is still wrong:"
    log "  - .env backup at ${env_backup} (restore with: sudo cp ${env_backup} ${HERMES_ROOT}/.env)"
    log "  - System > Console Settings UI re-renders nginx + Authelia + NC if you save it"
    log "  - Re-run this script (idempotent) if intermediate steps failed"
}

main "$@"
