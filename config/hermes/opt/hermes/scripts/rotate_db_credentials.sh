#!/bin/bash

# ============================================================================
# Hermes SEG — Database Credential Rotation Script
# ============================================================================
#
# Rotates database passwords for the hermes, ciphermail/djigzo, and syslog
# MariaDB users, updates all config files that contain them, and restarts
# services.
#
# This script runs on the Docker HOST, not inside a container. It uses
# docker exec to run MariaDB commands and accesses config files via the
# host volume mount paths.
#
# Designed to be called from the Hermes CLI management menu or run
# standalone. When called with --non-interactive, skips the menu and
# rotates all users (for scripted/automated use).
#
# Prerequisites:
#   - Docker containers running (hermes_db_server at minimum)
#   - MariaDB root password in /opt/hermes/creds/mysql_root_password
#   - Run from the Hermes SEG Docker root directory (where docker-compose.yml is)
#
# What it does (in order):
#   1. Regenerates config files from templates (Postfix, Ciphermail)
#   2. Sed-replaces credentials in live configs (Dovecot, Amavis, Syslog)
#   3. Updates the creds files with new passwords
#   4. Runs ALTER USER in MariaDB to change the actual DB passwords
#   5. Restarts all affected containers
#
# The order matters: configs are updated BEFORE the DB password changes,
# so if a later step fails, the old password is still valid and everything
# still works.
# ============================================================================

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

# Self-locate Hermes root by walking up from script location until we
# find docker-compose.yml. Robust to install path AND to wherever this
# script lives in the repo tree (currently config/hermes/opt/hermes/scripts/,
# 5 levels deep). Allow HERMES_ROOT env var to override for unusual setups.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]] && [[ ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "ERROR: Could not locate docker-compose.yml in any parent of $SCRIPT_DIR" >&2
        echo "Set HERMES_ROOT environment variable manually and retry." >&2
        exit 1
    fi
fi

# NOTE: /opt/hermes/creds is the path INSIDE the commandbox container
# (bind-mounted from the host). This script runs ON the host, so we must
# use the host path rooted at HERMES_ROOT, the same way install_hermes_docker.sh
# does at scripts/install_hermes_docker.sh:39.
CREDS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/creds"
CONF_FILES="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files"

# Host-side config paths (volume mounts)
POSTFIX_DIR="${HERMES_ROOT}/config/postfix-dkim/etc/postfix"
AMAVIS_50_USER="${HERMES_ROOT}/config/mail_filter/etc/amavis/conf.d/50-user"
DOVECOT_CONF="${HERMES_ROOT}/config/dovecot-2.4/conf/dovecot.conf"
DOVECOT_LUA="${HERMES_ROOT}/config/dovecot-2.4/conf/auth_app_passwords.lua"
CIPHERMAIL_CONN="${HERMES_ROOT}/config/ciphermail/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml"
CIPHERMAIL_CFG="${HERMES_ROOT}/config/ciphermail/usr/share/djigzo/conf/database/hibernate.cfg.xml"

# Syslog rsyslog mysql.conf — same credentials, 4 separate container mounts
SYSLOG_CONFS=(
    "${HERMES_ROOT}/config/postfix-dkim/etc/rsyslog.d/mysql.conf"
    "${HERMES_ROOT}/config/opendmarc/etc/rsyslog.d/mysql.conf"
    "${HERMES_ROOT}/config/mail_filter/etc/rsyslog.d/mysql.conf"
    "${HERMES_ROOT}/config/ldap/etc/rsyslog.d/mysql.conf"
)

# Flags
ROTATE_HERMES=false
ROTATE_CIPHERMAIL=false
ROTATE_SYSLOG=false
REGEN_ONLY=false
DRY_RUN=false
NON_INTERACTIVE=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ============================================================================
# FUNCTIONS
# ============================================================================

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step()  { echo -e "${CYAN}[STEP]${NC} $1"; }

generate_password() {
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32
}

# Test whether (user, password) authenticates against MariaDB.
# Returns 0 on success, non-zero on failure. Uses SELECT 1 — read-only.
test_auth() {
    local user="$1" pass="$2"
    docker exec hermes_db_server mysql -u "$user" -p"$pass" -e "SELECT 1" >/dev/null 2>&1
}

# Restore a single user to its old password, both in the DB and in the creds
# file. Called when a post-rotation auth test fails. Config-file backups
# (.bak.YYYYMMDD) are left in place — operator must restore those manually
# since the .bak names alone don't tell us which were touched in this run.
rollback_user() {
    local user="$1" old_pass="$2" creds_file="$3"
    log_warn "  Rolling back ${user} to old password..."
    if docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e \
        "ALTER USER '${user}'@'%' IDENTIFIED BY '${old_pass}'; FLUSH PRIVILEGES;" 2>/dev/null; then
        log_info "  ALTER USER rolled back for ${user}"
    else
        log_error "  ALTER USER rollback FAILED for ${user} — manual intervention required"
    fi
    if [[ -n "$creds_file" ]] && [[ -f "$creds_file" ]]; then
        echo -n "$old_pass" > "$creds_file"
        chmod 600 "$creds_file"
        log_info "  Restored ${creds_file} to old password"
    fi
    log_warn "  Config file changes (.bak.* siblings on disk) were NOT auto-restored."
    log_warn "  Run 'find ${HERMES_ROOT}/config -name \"*.bak.$(date +%Y%m%d)\"' to see them."
}

check_prerequisites() {
    # Check we're in the right directory
    if [[ ! -f "${HERMES_ROOT}/docker-compose.yml" ]]; then
        log_error "docker-compose.yml not found in ${HERMES_ROOT}"
        log_error "Run this script from the Hermes SEG Docker root directory"
        exit 1
    fi

    # Check MariaDB container is running
    if ! docker ps --format '{{.Names}}' | grep -q '^hermes_db_server$'; then
        log_error "hermes_db_server container is not running"
        exit 1
    fi

    # Check root password exists
    if [[ ! -f "${CREDS_DIR}/mysql_root_password" ]]; then
        log_error "MariaDB root password not found at ${CREDS_DIR}/mysql_root_password"
        exit 1
    fi

    # Check creds files exist for selected users
    if [[ "$ROTATE_HERMES" == true ]]; then
        for f in hermes_username hermes_password; do
            if [[ ! -f "${CREDS_DIR}/${f}" ]]; then
                log_error "Missing ${CREDS_DIR}/${f}"
                exit 1
            fi
        done
    fi

    if [[ "$ROTATE_CIPHERMAIL" == true ]]; then
        for f in ciphermail_username ciphermail_password; do
            if [[ ! -f "${CREDS_DIR}/${f}" ]]; then
                log_error "Missing ${CREDS_DIR}/${f}"
                exit 1
            fi
        done
    fi

    if [[ "$ROTATE_SYSLOG" == true ]]; then
        for f in syslog_username syslog_password; do
            if [[ ! -f "${CREDS_DIR}/${f}" ]]; then
                log_error "Missing ${CREDS_DIR}/${f}"
                exit 1
            fi
        done
    fi
}

# Regenerate a Postfix mysql-*.cf file from its .HERMES template
regenerate_postfix_mysql() {
    local template_name="$1"
    local output_file="${POSTFIX_DIR}/${template_name}.cf"
    local template_file="${CONF_FILES}/${template_name}.HERMES"

    if [[ ! -f "$template_file" ]]; then
        log_warn "Template not found: ${template_file} — skipping"
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would regenerate: ${output_file}"
        return
    fi

    # Backup existing
    if [[ -f "$output_file" ]]; then
        cp "$output_file" "${output_file}.bak.$(date +%Y%m%d)"
    fi

    # Template -> replace -> write
    sed -e "s/HERMES-USERNAME/${NEW_HERMES_USER}/g" \
        -e "s/HERMES-PASSWORD/${NEW_HERMES_PASS}/g" \
        "$template_file" > "$output_file"

    chmod 644 "$output_file"
}

show_menu() {
    echo ""
    echo -e "${BOLD}============================================${NC}"
    echo -e "${BOLD}  Hermes SEG — Database Credential Rotation${NC}"
    echo -e "${BOLD}============================================${NC}"
    echo ""
    echo "  Select which database credentials to rotate:"
    echo ""
    echo -e "  ${BOLD}1)${NC}  Rotate ALL database credentials"
    echo -e "      ${CYAN}hermes, ciphermail, syslog${NC}"
    echo ""
    echo -e "  ${BOLD}2)${NC}  Rotate Hermes credentials only"
    echo -e "      ${CYAN}Affects: Postfix, Amavis, Dovecot, Commandbox${NC}"
    echo ""
    echo -e "  ${BOLD}3)${NC}  Rotate Ciphermail credentials only"
    echo -e "      ${CYAN}Affects: Ciphermail (email encryption)${NC}"
    echo ""
    echo -e "  ${BOLD}4)${NC}  Rotate Syslog credentials only"
    echo -e "      ${CYAN}Affects: Postfix, OpenDMARC, Amavis, LDAP (rsyslog)${NC}"
    echo ""
    echo -e "  ${BOLD}5)${NC}  Dry run (show what would change without making changes)"
    echo ""
    echo -e "  ${BOLD}6)${NC}  Regenerate config files only (no password change)"
    echo -e "      ${CYAN}Rebuilds all config files using current credentials${NC}"
    echo ""
    echo -e "  ${BOLD}0)${NC}  Cancel and return"
    echo ""
}

# ============================================================================
# PARSE ARGUMENTS
# ============================================================================

for arg in "$@"; do
    case "$arg" in
        --non-interactive)
            NON_INTERACTIVE=true
            ROTATE_HERMES=true
            ROTATE_CIPHERMAIL=true
            ROTATE_SYSLOG=true
            ;;
        -h|--help)
            echo "Usage: $0 [--non-interactive]"
            echo ""
            echo "Interactive menu-driven database credential rotation."
            echo ""
            echo "Options:"
            echo "  --non-interactive   Skip menu, rotate all users (for scripted use)"
            echo "  -h, --help          Show this help"
            exit 0
            ;;
        *)
            log_error "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

# ============================================================================
# INTERACTIVE MENU
# ============================================================================

if [[ "$NON_INTERACTIVE" == false ]]; then
    show_menu

    read -p "  Enter selection [0-6]: " choice
    echo ""

    case "$choice" in
        1)
            ROTATE_HERMES=true
            ROTATE_CIPHERMAIL=true
            ROTATE_SYSLOG=true
            log_info "Selected: Rotate ALL credentials"
            ;;
        2)
            ROTATE_HERMES=true
            log_info "Selected: Rotate Hermes credentials only"
            ;;
        3)
            ROTATE_CIPHERMAIL=true
            log_info "Selected: Rotate Ciphermail credentials only"
            ;;
        4)
            ROTATE_SYSLOG=true
            log_info "Selected: Rotate Syslog credentials only"
            ;;
        5)
            ROTATE_HERMES=true
            ROTATE_CIPHERMAIL=true
            ROTATE_SYSLOG=true
            DRY_RUN=true
            log_info "Selected: Dry run (all credentials)"
            ;;
        6)
            ROTATE_HERMES=true
            ROTATE_CIPHERMAIL=true
            ROTATE_SYSLOG=true
            REGEN_ONLY=true
            log_info "Selected: Regenerate config files only (no password change)"
            ;;
        0|"")
            echo "  Cancelled."
            exit 0
            ;;
        *)
            log_error "Invalid selection: $choice"
            exit 1
            ;;
    esac
    echo ""
fi

# ============================================================================
# MAIN
# ============================================================================

check_prerequisites

MYSQL_ROOT_PASS=$(cat "${CREDS_DIR}/mysql_root_password")

# Read current usernames and generate new passwords (or use current for regen-only)
if [[ "$ROTATE_HERMES" == true ]]; then
    NEW_HERMES_USER=$(cat "${CREDS_DIR}/hermes_username" | tr -d '\n')
    OLD_HERMES_PASS=$(cat "${CREDS_DIR}/hermes_password" | tr -d '\n')
    if [[ "$REGEN_ONLY" == true ]]; then
        NEW_HERMES_PASS="$OLD_HERMES_PASS"
        log_info "Will regenerate configs for MariaDB user: ${NEW_HERMES_USER} (no password change)"
    else
        NEW_HERMES_PASS=$(generate_password)
        log_info "Will rotate password for MariaDB user: ${NEW_HERMES_USER}"
    fi
fi

if [[ "$ROTATE_CIPHERMAIL" == true ]]; then
    NEW_CIPHERMAIL_USER=$(cat "${CREDS_DIR}/ciphermail_username" | tr -d '\n')
    OLD_CIPHERMAIL_PASS=$(cat "${CREDS_DIR}/ciphermail_password" | tr -d '\n')
    if [[ "$REGEN_ONLY" == true ]]; then
        NEW_CIPHERMAIL_PASS="$OLD_CIPHERMAIL_PASS"
        log_info "Will regenerate configs for MariaDB user: ${NEW_CIPHERMAIL_USER} (no password change)"
    else
        NEW_CIPHERMAIL_PASS=$(generate_password)
        log_info "Will rotate password for MariaDB user: ${NEW_CIPHERMAIL_USER}"
    fi
fi

if [[ "$ROTATE_SYSLOG" == true ]]; then
    NEW_SYSLOG_USER=$(cat "${CREDS_DIR}/syslog_username" | tr -d '\n')
    OLD_SYSLOG_PASS=$(cat "${CREDS_DIR}/syslog_password" | tr -d '\n')
    if [[ "$REGEN_ONLY" == true ]]; then
        NEW_SYSLOG_PASS="$OLD_SYSLOG_PASS"
        log_info "Will regenerate configs for MariaDB user: ${NEW_SYSLOG_USER} (no password change)"
    else
        NEW_SYSLOG_PASS=$(generate_password)
        log_info "Will rotate password for MariaDB user: ${NEW_SYSLOG_USER}"
    fi
fi

if [[ "$DRY_RUN" == true ]]; then
    echo ""
    log_warn "DRY RUN — no changes will be made"
fi

# Final confirmation
if [[ "$DRY_RUN" == false ]]; then
    echo ""
    echo -e "  ${YELLOW}WARNING: This will change database passwords and restart services.${NC}"
    echo "  Mail flow will be briefly interrupted during container restarts."
    echo ""
    read -p "  Proceed with credential rotation? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Aborted."
        exit 0
    fi
fi
echo ""

# ============================================================================
# PRE-FLIGHT AUTH TESTS
# ============================================================================
# Verify the script CAN do its job before it tries to:
#   1. Root password works (otherwise we can't ALTER USER)
#   2. Each current service password works (otherwise system state is already
#      inconsistent — config files vs DB don't match — and rotating would
#      paper over that). Bail BEFORE touching any file.

log_info "Running pre-flight auth tests..."

if ! test_auth root "${MYSQL_ROOT_PASS}"; then
    log_error "Pre-flight: root authentication FAILED"
    log_error "Cannot proceed without working root credentials"
    log_error "Verify ${CREDS_DIR}/mysql_root_password is correct"
    exit 1
fi
log_info "  ✓ root authentication OK"

if [[ "$ROTATE_HERMES" == true ]]; then
    if ! test_auth "${NEW_HERMES_USER}" "${OLD_HERMES_PASS}"; then
        log_error "Pre-flight: current hermes password does not authenticate"
        log_error "System state is inconsistent (creds file vs DB don't match)"
        log_error "Aborting before any changes are made."
        exit 1
    fi
    log_info "  ✓ Current hermes credentials OK"
fi

if [[ "$ROTATE_CIPHERMAIL" == true ]]; then
    if ! test_auth "${NEW_CIPHERMAIL_USER}" "${OLD_CIPHERMAIL_PASS}"; then
        log_error "Pre-flight: current ciphermail password does not authenticate"
        log_error "System state is inconsistent. Aborting."
        exit 1
    fi
    log_info "  ✓ Current ciphermail credentials OK"
fi

if [[ "$ROTATE_SYSLOG" == true ]]; then
    if ! test_auth "${NEW_SYSLOG_USER}" "${OLD_SYSLOG_PASS}"; then
        log_error "Pre-flight: current syslog password does not authenticate"
        log_error "System state is inconsistent. Aborting."
        exit 1
    fi
    log_info "  ✓ Current syslog credentials OK"
fi

log_info "Pre-flight checks passed."
echo ""

# Calculate total steps based on what's selected
TOTAL_STEPS=1  # Always have restart step
[[ "$ROTATE_HERMES" == true ]] && TOTAL_STEPS=$((TOTAL_STEPS + 3))    # Postfix + Amavis + Dovecot
[[ "$ROTATE_CIPHERMAIL" == true ]] && TOTAL_STEPS=$((TOTAL_STEPS + 1)) # Ciphermail
[[ "$ROTATE_SYSLOG" == true ]] && TOTAL_STEPS=$((TOTAL_STEPS + 1))     # Syslog
TOTAL_STEPS=$((TOTAL_STEPS + 1))  # ALTER USER step
CURRENT_STEP=0

next_step() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    log_step "${CURRENT_STEP}/${TOTAL_STEPS} $1"
}

# ============================================================================
# REGENERATE CONFIG FILES
# ============================================================================

if [[ "$ROTATE_HERMES" == true ]]; then

    # --- POSTFIX mysql-*.cf ---
    next_step "Regenerating Postfix mysql-*.cf files from templates..."

    # Auto-discover Postfix mysql templates
    POSTFIX_COUNT=0
    for template_file in "${CONF_FILES}"/mysql-*.HERMES; do
        [[ ! -f "$template_file" ]] && continue
        template_name=$(basename "$template_file" .HERMES)
        regenerate_postfix_mysql "$template_name"
        POSTFIX_COUNT=$((POSTFIX_COUNT + 1))
    done

    if [[ "$DRY_RUN" == false ]]; then
        log_info "  Regenerated ${POSTFIX_COUNT} Postfix config files"
    fi

    # --- AMAVIS 50-user ---
    next_step "Updating Amavis 50-user credentials..."

    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would sed-replace credentials in: ${AMAVIS_50_USER}"
    elif [[ -f "$AMAVIS_50_USER" ]]; then
        cp "$AMAVIS_50_USER" "${AMAVIS_50_USER}.bak.$(date +%Y%m%d)"
        sed -i \
            -e "s/'${OLD_HERMES_PASS}'/'${NEW_HERMES_PASS}'/g" \
            "$AMAVIS_50_USER"
        log_info "  Updated Amavis 50-user"
    else
        log_warn "  ${AMAVIS_50_USER} not found — skipping"
    fi

    # --- DOVECOT dovecot.conf ---
    next_step "Updating Dovecot dovecot.conf credentials..."

    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would sed-replace credentials in: ${DOVECOT_CONF}"
    elif [[ -f "$DOVECOT_CONF" ]]; then
        cp "$DOVECOT_CONF" "${DOVECOT_CONF}.bak.$(date +%Y%m%d)"
        sed -i \
            -e "s/password = ${OLD_HERMES_PASS}/password = ${NEW_HERMES_PASS}/g" \
            "$DOVECOT_CONF"
        log_info "  Updated Dovecot dovecot.conf"
    else
        log_warn "  ${DOVECOT_CONF} not found — skipping"
    fi

    # --- DOVECOT auth_app_passwords.lua (#197 passdb lua script) ---
    # The Lua passdb script holds the same DB password as a string literal
    # (DB_PASS = "..."). Pattern match is anchored with the literal prefix
    # to avoid collateral matches.
    next_step "Updating Dovecot auth_app_passwords.lua credentials..."

    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would sed-replace credentials in: ${DOVECOT_LUA}"
    elif [[ -f "$DOVECOT_LUA" ]]; then
        cp "$DOVECOT_LUA" "${DOVECOT_LUA}.bak.$(date +%Y%m%d)"
        sed -i \
            -e "s|local DB_PASS = \"${OLD_HERMES_PASS}\"|local DB_PASS = \"${NEW_HERMES_PASS}\"|g" \
            "$DOVECOT_LUA"
        log_info "  Updated Dovecot auth_app_passwords.lua"
    else
        log_warn "  ${DOVECOT_LUA} not found — skipping"
    fi
fi

# --- SYSLOG rsyslog mysql.conf (4 container mounts) ---
if [[ "$ROTATE_SYSLOG" == true ]]; then
    next_step "Updating Syslog rsyslog mysql.conf files (4 containers)..."

    for syslog_conf in "${SYSLOG_CONFS[@]}"; do
        if [[ "$DRY_RUN" == true ]]; then
            echo "  Would sed-replace credentials in: ${syslog_conf}"
        elif [[ -f "$syslog_conf" ]]; then
            cp "$syslog_conf" "${syslog_conf}.bak.$(date +%Y%m%d)"
            sed -i \
                -e "s/${OLD_SYSLOG_PASS}/${NEW_SYSLOG_PASS}/g" \
                "$syslog_conf"
            log_info "  Updated $(echo "$syslog_conf" | grep -oP 'config/\K[^/]+')/rsyslog.d/mysql.conf"
        else
            log_warn "  ${syslog_conf} not found — skipping"
        fi
    done
fi

# --- CIPHERMAIL hibernate XML ---
if [[ "$ROTATE_CIPHERMAIL" == true ]]; then
    next_step "Regenerating Ciphermail hibernate XML files..."

    # hibernate.mysql.connection.xml
    TEMPLATE="${CONF_FILES}/hibernate.mysql.connection.HERMES"
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would regenerate: ${CIPHERMAIL_CONN}"
        echo "  Would regenerate: ${CIPHERMAIL_CFG}"
    elif [[ -f "$TEMPLATE" ]]; then
        if [[ -f "$CIPHERMAIL_CONN" ]]; then
            cp "$CIPHERMAIL_CONN" "${CIPHERMAIL_CONN}.bak.$(date +%Y%m%d)"
        fi
        sed -e "s/DJIGZO-USERNAME/${NEW_CIPHERMAIL_USER}/g" \
            -e "s/DJIGZO-PASSWORD/${NEW_CIPHERMAIL_PASS}/g" \
            "$TEMPLATE" > "$CIPHERMAIL_CONN"
        log_info "  Regenerated hibernate.mysql.connection.xml"
    else
        log_warn "  Template not found: ${TEMPLATE}"
    fi

    # hibernate.cfg.xml
    TEMPLATE="${CONF_FILES}/hibernate.mysql.cfg.HERMES"
    if [[ "$DRY_RUN" == false ]] && [[ -f "$TEMPLATE" ]]; then
        if [[ -f "$CIPHERMAIL_CFG" ]]; then
            cp "$CIPHERMAIL_CFG" "${CIPHERMAIL_CFG}.bak.$(date +%Y%m%d)"
        fi
        sed -e "s/DJIGZO-USERNAME/${NEW_CIPHERMAIL_USER}/g" \
            -e "s/DJIGZO-PASSWORD/${NEW_CIPHERMAIL_PASS}/g" \
            "$TEMPLATE" > "$CIPHERMAIL_CFG"
        log_info "  Regenerated hibernate.cfg.xml"
    fi
fi

# ============================================================================
# UPDATE CREDS FILES + ALTER USER IN MARIADB (skip for regen-only)
# ============================================================================

if [[ "$REGEN_ONLY" == true ]]; then
    log_info "Regen-only mode — skipping password changes and ALTER USER"
else

next_step "Updating credential files and MariaDB passwords..."

if [[ "$ROTATE_HERMES" == true ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would update: ${CREDS_DIR}/hermes_password"
        echo "  Would run: ALTER USER '${NEW_HERMES_USER}'@'%' IDENTIFIED BY '***'"
        echo "  Would verify new password authenticates"
    else
        echo -n "$NEW_HERMES_PASS" > "${CREDS_DIR}/hermes_password"
        chmod 600 "${CREDS_DIR}/hermes_password"
        docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e \
            "ALTER USER '${NEW_HERMES_USER}'@'%' IDENTIFIED BY '${NEW_HERMES_PASS}'; FLUSH PRIVILEGES;" 2>/dev/null
        # Post-rotation auth test — verify the new password actually works.
        # Catches: silent ALTER USER no-op (host pattern mismatch), grant
        # propagation lag, anything else that would only surface as
        # post-restart auth failures.
        if ! test_auth "${NEW_HERMES_USER}" "${NEW_HERMES_PASS}"; then
            log_error "  Post-rotation auth test FAILED for ${NEW_HERMES_USER}"
            rollback_user "${NEW_HERMES_USER}" "${OLD_HERMES_PASS}" "${CREDS_DIR}/hermes_password"
            exit 1
        fi
        log_info "  ✓ MariaDB password rotated and verified for user: ${NEW_HERMES_USER}"
    fi
fi

if [[ "$ROTATE_CIPHERMAIL" == true ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would update: ${CREDS_DIR}/ciphermail_password"
        echo "  Would run: ALTER USER '${NEW_CIPHERMAIL_USER}'@'%' IDENTIFIED BY '***'"
        echo "  Would verify new password authenticates"
    else
        echo -n "$NEW_CIPHERMAIL_PASS" > "${CREDS_DIR}/ciphermail_password"
        chmod 600 "${CREDS_DIR}/ciphermail_password"
        docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e \
            "ALTER USER '${NEW_CIPHERMAIL_USER}'@'%' IDENTIFIED BY '${NEW_CIPHERMAIL_PASS}'; FLUSH PRIVILEGES;" 2>/dev/null
        if ! test_auth "${NEW_CIPHERMAIL_USER}" "${NEW_CIPHERMAIL_PASS}"; then
            log_error "  Post-rotation auth test FAILED for ${NEW_CIPHERMAIL_USER}"
            rollback_user "${NEW_CIPHERMAIL_USER}" "${OLD_CIPHERMAIL_PASS}" "${CREDS_DIR}/ciphermail_password"
            exit 1
        fi
        log_info "  ✓ MariaDB password rotated and verified for user: ${NEW_CIPHERMAIL_USER}"
    fi
fi

if [[ "$ROTATE_SYSLOG" == true ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would update: ${CREDS_DIR}/syslog_password"
        echo "  Would run: ALTER USER '${NEW_SYSLOG_USER}'@'%' IDENTIFIED BY '***'"
        echo "  Would verify new password authenticates"
    else
        echo -n "$NEW_SYSLOG_PASS" > "${CREDS_DIR}/syslog_password"
        chmod 600 "${CREDS_DIR}/syslog_password"
        docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e \
            "ALTER USER '${NEW_SYSLOG_USER}'@'%' IDENTIFIED BY '${NEW_SYSLOG_PASS}'; FLUSH PRIVILEGES;" 2>/dev/null
        if ! test_auth "${NEW_SYSLOG_USER}" "${NEW_SYSLOG_PASS}"; then
            log_error "  Post-rotation auth test FAILED for ${NEW_SYSLOG_USER}"
            rollback_user "${NEW_SYSLOG_USER}" "${OLD_SYSLOG_PASS}" "${CREDS_DIR}/syslog_password"
            exit 1
        fi
        log_info "  ✓ MariaDB password rotated and verified for user: ${NEW_SYSLOG_USER}"
    fi
fi

# End of REGEN_ONLY skip block
fi

# ============================================================================
# RESTART SERVICES
# ============================================================================

next_step "Restarting services..."

if [[ "$DRY_RUN" == true ]]; then
    [[ "$ROTATE_HERMES" == true ]] && echo "  Would restart: hermes_postfix_dkim, hermes_mail_filter, hermes_dovecot, hermes_commandbox"
    [[ "$ROTATE_CIPHERMAIL" == true ]] && echo "  Would restart: hermes_ciphermail"
    [[ "$ROTATE_SYSLOG" == true ]] && echo "  Would restart: hermes_postfix_dkim, hermes_opendmarc, hermes_mail_filter, hermes_openldap"
else
    # Track which containers we've already restarted to avoid double-restart
    declare -A RESTARTED

    if [[ "$ROTATE_HERMES" == true ]]; then
        for ctr in hermes_postfix_dkim hermes_mail_filter hermes_dovecot hermes_commandbox; do
            docker container restart "$ctr" >/dev/null 2>&1 && log_info "  Restarted ${ctr}" || log_warn "  Failed to restart ${ctr}"
            RESTARTED[$ctr]=1
        done
    fi

    if [[ "$ROTATE_CIPHERMAIL" == true ]]; then
        docker container restart hermes_ciphermail >/dev/null 2>&1 && log_info "  Restarted hermes_ciphermail" || log_warn "  Failed to restart hermes_ciphermail"
        RESTARTED[hermes_ciphermail]=1
    fi

    if [[ "$ROTATE_SYSLOG" == true ]]; then
        for ctr in hermes_postfix_dkim hermes_opendmarc hermes_mail_filter hermes_openldap; do
            if [[ -z "${RESTARTED[$ctr]+x}" ]]; then
                docker container restart "$ctr" >/dev/null 2>&1 && log_info "  Restarted ${ctr}" || log_warn "  Failed to restart ${ctr}"
                RESTARTED[$ctr]=1
            else
                log_info "  ${ctr} already restarted — skipping"
            fi
        done
    fi
fi

# ============================================================================
# DONE
# ============================================================================

echo ""
if [[ "$DRY_RUN" == true ]]; then
    log_info "Dry run complete. No changes were made."
else
    log_info "Credential rotation complete!"
    echo ""
    echo "  Services restarted. Allow 30-60 seconds for all containers to"
    echo "  fully start before testing. Commandbox may take longer."
    echo ""
    echo "  Verify by logging into the admin UI and checking:"
    echo "    - Dashboard loads (hermes DB connection works)"
    echo "    - Send a test email (Postfix DB lookups work)"
    echo "    - Check Ciphermail admin at :8443 (Ciphermail DB works)"
    echo "    - Check System > Logs for syslog entries (rsyslog DB works)"
fi
echo ""
