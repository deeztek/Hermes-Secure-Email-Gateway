#!/bin/bash
#
# Hermes SEG Docker Installation Script
#
# This script initializes a new Hermes SEG installation on Docker.
# It handles:
#   - Secret/password generation
#   - Database creation (hermes, authelia)
#   - Initial configuration
#   - Container startup
#
# Prerequisites:
#   - Linux host (any distribution)
#   - Docker Engine 24.0+
#   - Docker Compose v2
#   - Git
#   - Minimum 4GB RAM, 50GB disk
#
# Tested on: Ubuntu 22.04, Debian 12, Rocky Linux 9, Alma Linux 9
#
# Usage (run as root):
#   ./install_hermes_docker.sh
#
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
HERMES_ROOT="/opt/hermes-seg"
SECRETS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/keys"
CREDS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/creds"
CONFIG_FILE="${HERMES_ROOT}/.hermes_install_config"
LOG_FILE="/var/log/hermes_install_$(date +%Y%m%d_%H%M%S).log"

# Default mount points (can be customized during installation)
DEFAULT_DATA_MOUNT="/mnt/data"       # Databases, logs, quarantine, LDAP, configs
DEFAULT_VMAIL_MOUNT="/mnt/vmail"     # Dovecot email storage (mailbox users)
DEFAULT_FILES_MOUNT="/mnt/files"     # Nextcloud files (optional)

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

header() {
    echo -e "\n${BLUE}============================================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE} $1${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}============================================================${NC}\n" | tee -a "$LOG_FILE"
}

generate_password() {
    # Generate a secure random password (32 chars, alphanumeric + special)
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9!@#$%^&*' | head -c 32
}

generate_alphanumeric() {
    # Generate alphanumeric only (for usernames, database names)
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c "$1"
}

generate_hex() {
    # Generate hex string (for JWT secrets, encryption keys)
    openssl rand -hex "$1"
}

prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local result
    read -p "${prompt} [${default}]: " result
    echo "${result:-$default}"
}

validate_mount_point() {
    local path="$1"
    local name="$2"

    # Check if path is absolute
    if [[ ! "$path" = /* ]]; then
        warn "${name} path must be absolute (start with /)"
        return 1
    fi

    # Check if parent directory exists
    local parent_dir=$(dirname "$path")
    if [[ ! -d "$parent_dir" ]]; then
        warn "Parent directory ${parent_dir} does not exist for ${name}"
        return 1
    fi

    # Create directory if it doesn't exist
    if [[ ! -d "$path" ]]; then
        log "Creating ${name} directory: ${path}"
        mkdir -p "$path"
        if [[ $? -ne 0 ]]; then
            warn "Failed to create ${name} directory: ${path}"
            return 1
        fi
    fi

    # Check write permissions
    if [[ ! -w "$path" ]]; then
        warn "${name} directory is not writable: ${path}"
        return 1
    fi

    return 0
}

# ============================================================================
# MOUNT POINT CONFIGURATION
# ============================================================================

configure_mount_points() {
    header "Storage Configuration"

    echo "Hermes SEG stores significant amounts of data across three categories:"
    echo ""
    echo "  1. SYSTEM DATA (required)"
    echo "     - Databases (MariaDB, LDAP)"
    echo "     - Email quarantine and virus signatures"
    echo "     - Logs, session data, and configuration"
    echo ""
    echo "  2. EMAIL STORAGE (required)"
    echo "     - Mailbox user email (can grow very large)"
    echo "     - Separate mount allows independent quota/backup management"
    echo ""
    echo "  3. NEXTCLOUD FILES (optional)"
    echo "     - User file storage (if Nextcloud webmail is enabled)"
    echo "     - Can grow very large depending on usage"
    echo ""
    echo "You have two options:"
    echo ""
    echo "  1) Use CUSTOM mount points (RECOMMENDED)"
    echo "     Mount external storage (e.g., /mnt/data, /mnt/vmail, /mnt/files)"
    echo "     Better for production, easier backups, survives Docker reinstall"
    echo ""
    echo "  2) Use DEFAULT Docker volumes (NOT RECOMMENDED)"
    echo "     Data stored in /var/lib/docker/volumes"
    echo "     Harder to manage, tied to Docker installation"
    echo ""

    read -p "Use custom mount points? (Y/n): " USE_CUSTOM
    if [[ "$USE_CUSTOM" =~ ^[Nn]$ ]]; then
        warn "Using default Docker volumes. This is NOT recommended for production."
        warn "Data will be stored in /var/lib/docker/volumes and may be lost if Docker is reinstalled."
        echo ""
        read -p "Are you sure you want to use default Docker volumes? (y/N): " CONFIRM_DEFAULT
        if [[ ! "$CONFIRM_DEFAULT" =~ ^[Yy]$ ]]; then
            log "Returning to custom mount point configuration..."
        else
            USE_DOCKER_VOLUMES="true"
            DATA_MOUNT=""
            VMAIL_MOUNT=""
            FILES_MOUNT=""
            ENABLE_NEXTCLOUD="false"
            save_config
            log "Configured to use default Docker volumes"
            return
        fi
    fi

    # Custom mount points
    echo ""
    echo "Enter custom storage paths. Press Enter to accept defaults."
    echo "Directories will be created if they don't exist."
    echo ""

    # Data mount point (required)
    while true; do
        DATA_MOUNT=$(prompt_with_default "System data path (databases, logs, quarantine)" "$DEFAULT_DATA_MOUNT")
        if validate_mount_point "$DATA_MOUNT" "System data"; then
            break
        fi
        echo "Please enter a valid path or ensure the parent directory exists."
    done
    log "System data path: ${DATA_MOUNT}"

    # Vmail mount point (required)
    while true; do
        VMAIL_MOUNT=$(prompt_with_default "Email storage path (mailbox user mail)" "$DEFAULT_VMAIL_MOUNT")
        if validate_mount_point "$VMAIL_MOUNT" "Email storage"; then
            break
        fi
        echo "Please enter a valid path or ensure the parent directory exists."
    done
    log "Email storage path: ${VMAIL_MOUNT}"

    # Nextcloud files mount point (optional)
    echo ""
    read -p "Enable Nextcloud file storage? (Y/n): " ENABLE_NC
    if [[ "$ENABLE_NC" =~ ^[Nn]$ ]]; then
        ENABLE_NEXTCLOUD="false"
        FILES_MOUNT=""
        log "Nextcloud file storage: disabled"
    else
        ENABLE_NEXTCLOUD="true"
        while true; do
            FILES_MOUNT=$(prompt_with_default "Nextcloud files path" "$DEFAULT_FILES_MOUNT")
            if validate_mount_point "$FILES_MOUNT" "Nextcloud files"; then
                break
            fi
            echo "Please enter a valid path or ensure the parent directory exists."
        done
        log "Nextcloud files path: ${FILES_MOUNT}"
    fi

    # Create subdirectories
    log "Creating storage subdirectories..."

    # Data subdirectories (matching docker-compose.yml volume names)
    mkdir -p "${DATA_MOUNT}/dbase"                      # db_data
    mkdir -p "${DATA_MOUNT}/amavis"                     # amavis_data
    mkdir -p "${DATA_MOUNT}/authelia/redis"             # authelia_redis
    mkdir -p "${DATA_MOUNT}/authelia/logs"              # authelia_logs
    mkdir -p "${DATA_MOUNT}/authelia/db"                # authelia_db
    mkdir -p "${DATA_MOUNT}/dovecot/logs"               # dovecot_logs
    mkdir -p "${DATA_MOUNT}/nginx/logs"                 # nginx_logs
    mkdir -p "${DATA_MOUNT}/commandbox/serverhome"      # commandbox_serverhome
    mkdir -p "${DATA_MOUNT}/openldap"                   # openldap_data
    mkdir -p "${DATA_MOUNT}/ldap/data"                  # ldap_data
    mkdir -p "${DATA_MOUNT}/ldap/logs"                  # ldap_logs
    mkdir -p "${DATA_MOUNT}/postfix_dkim/logs"          # postfix_dkim_logs
    mkdir -p "${DATA_MOUNT}/postfix_dkim/queue"         # postfix_dkim_queue
    mkdir -p "${DATA_MOUNT}/dmarc/logs"                 # dmarc_logs
    mkdir -p "${DATA_MOUNT}/mail_filter/logs"           # mail_filter_logs
    mkdir -p "${DATA_MOUNT}/mail_filter/data/amavis"    # mail_filter_data_amavis
    mkdir -p "${DATA_MOUNT}/mail_filter/data/clamav"    # mail_filter_data_clamav
    mkdir -p "${DATA_MOUNT}/mail_filter/data/fangfrisch" # mail_filter_data_fangfrisch

    # Vmail subdirectory (email storage)
    mkdir -p "${VMAIL_MOUNT}/dovecot"                   # dovecot_mail

    # Nextcloud subdirectories (if enabled)
    if [[ "${ENABLE_NEXTCLOUD}" == "true" ]]; then
        mkdir -p "${FILES_MOUNT}/nextcloud/app"         # nextcloud
        mkdir -p "${FILES_MOUNT}/nextcloud/redis"       # nextcloud_redis
    fi

    # Set permissions
    chmod 755 "${DATA_MOUNT}"
    chmod 755 "${VMAIL_MOUNT}"
    # MySQL needs specific ownership (will be set by container)
    chmod 750 "${DATA_MOUNT}/dbase"

    if [[ "${ENABLE_NEXTCLOUD}" == "true" ]]; then
        chmod 755 "${FILES_MOUNT}"
    fi

    USE_DOCKER_VOLUMES="false"

    # Save configuration
    save_config

    log "Storage configuration completed"
}

save_config() {
    log "Saving installation configuration..."
    cat > "$CONFIG_FILE" << EOF
# Hermes SEG Installation Configuration
# Generated: $(date)
# DO NOT EDIT MANUALLY - regenerate with install script

USE_DOCKER_VOLUMES="${USE_DOCKER_VOLUMES:-false}"
DATA_MOUNT="${DATA_MOUNT}"
VMAIL_MOUNT="${VMAIL_MOUNT}"
FILES_MOUNT="${FILES_MOUNT}"
ENABLE_NEXTCLOUD="${ENABLE_NEXTCLOUD:-false}"
HERMES_ROOT="${HERMES_ROOT}"
EOF
    chmod 600 "$CONFIG_FILE"
    log "Configuration saved to ${CONFIG_FILE}"
}

load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        log "Loaded existing configuration from ${CONFIG_FILE}"
        return 0
    fi
    return 1
}

# ============================================================================
# GENERATE DOCKER COMPOSE OVERRIDE
# ============================================================================

generate_compose_override() {
    header "Generating Docker Compose Override"

    local OVERRIDE_FILE="${HERMES_ROOT}/docker-compose.override.yml"

    # Load config if not already set
    if [[ -z "${USE_DOCKER_VOLUMES:-}" ]]; then
        if ! load_config; then
            error "No configuration found. Run installation first."
        fi
    fi

    # If using default Docker volumes, create minimal override
    if [[ "${USE_DOCKER_VOLUMES}" == "true" ]]; then
        if [[ -f "$OVERRIDE_FILE" ]]; then
            log "Removing existing docker-compose.override.yml (using default Docker volumes)"
            rm -f "$OVERRIDE_FILE"
        fi

        # Create a minimal override with just a comment
        cat > "$OVERRIDE_FILE" << EOF
# Hermes SEG Docker Compose Override
# Generated by install_hermes_docker.sh on $(date)
#
# CONFIGURATION: Using default Docker volumes
# Data is stored in /var/lib/docker/volumes
#
# WARNING: This is NOT recommended for production use.
# To switch to custom mount points, run:
#   ./scripts/install_hermes_docker.sh --configure-storage
#
# No volume overrides - using defaults from docker-compose.yml
EOF
        chmod 644 "$OVERRIDE_FILE"
        log "Using default Docker volumes (no mount point overrides)"
        warn "Data will be stored in /var/lib/docker/volumes"
        return
    fi

    # Custom mount points
    if [[ -z "${DATA_MOUNT:-}" ]] || [[ -z "${VMAIL_MOUNT:-}" ]]; then
        error "Mount points not configured. Run --configure-storage first."
    fi

    log "Generating docker-compose.override.yml..."
    log "  System data:  ${DATA_MOUNT}"
    log "  Email storage: ${VMAIL_MOUNT}"
    if [[ "${ENABLE_NEXTCLOUD}" == "true" ]]; then
        log "  Nextcloud files: ${FILES_MOUNT}"
    else
        log "  Nextcloud files: disabled"
    fi

    # Build the override file
    cat > "$OVERRIDE_FILE" << EOF
# Hermes SEG Docker Compose Override
# Generated by install_hermes_docker.sh on $(date)
#
# This file overrides the volume mount points in docker-compose.yml.
# Docker Compose automatically merges this with the main compose file.
#
# DO NOT EDIT docker-compose.yml directly - modify this override file.
# Regenerate with: ./scripts/install_hermes_docker.sh --generate-override
#
# MOUNT POINT CONFIGURATION:
#   System data:    ${DATA_MOUNT}
#   Email storage:  ${VMAIL_MOUNT}
#   Nextcloud files: ${ENABLE_NEXTCLOUD:-false} ${FILES_MOUNT:-"(disabled)"}

# Override all named volumes to use custom bind mounts
volumes:
  # ============================================================================
  # SYSTEM DATA VOLUMES (${DATA_MOUNT})
  # ============================================================================

  # Database
  db_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/dbase

  # Amavis (mail filter quarantine)
  amavis_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/amavis

  # Authelia (authentication)
  authelia_redis:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/authelia/redis

  authelia_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/authelia/logs

  authelia_db:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/authelia/db

  # Dovecot logs (NOT mail storage)
  dovecot_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/dovecot/logs

  # Nginx logs
  nginx_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/nginx/logs

  # CommandBox (CFML server)
  commandbox_serverhome:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/commandbox/serverhome

  # OpenLDAP
  openldap_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/openldap

  # LDAP (legacy)
  ldap_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/ldap/data

  ldap_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/ldap/logs

  # Postfix DKIM
  postfix_dkim_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/postfix_dkim/logs

  postfix_dkim_queue:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/postfix_dkim/queue

  # DMARC
  dmarc_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/dmarc/logs

  # Mail filter (Amavis, ClamAV, Fangfrisch)
  mail_filter_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/mail_filter/logs

  mail_filter_data_amavis:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/mail_filter/data/amavis

  mail_filter_data_clamav:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/mail_filter/data/clamav

  mail_filter_data_fangfrisch:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_MOUNT}/mail_filter/data/fangfrisch

  # ============================================================================
  # EMAIL STORAGE VOLUME (${VMAIL_MOUNT})
  # ============================================================================

  # Dovecot mail storage (mailbox user emails)
  dovecot_mail:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${VMAIL_MOUNT}/dovecot
EOF

    # Add Nextcloud volumes if enabled
    if [[ "${ENABLE_NEXTCLOUD}" == "true" ]] && [[ -n "${FILES_MOUNT:-}" ]]; then
        cat >> "$OVERRIDE_FILE" << EOF

  # ============================================================================
  # NEXTCLOUD FILES VOLUME (${FILES_MOUNT})
  # ============================================================================

  # Nextcloud application
  nextcloud:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${FILES_MOUNT}/nextcloud/app

  # Nextcloud Redis cache
  nextcloud_redis:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${FILES_MOUNT}/nextcloud/redis
EOF
    fi

    chmod 644 "$OVERRIDE_FILE"
    log "Generated: ${OVERRIDE_FILE}"

    # Validate the override file
    log "Validating docker-compose configuration..."
    if command -v docker &> /dev/null; then
        cd "$HERMES_ROOT"
        if docker compose config > /dev/null 2>&1; then
            log "Docker Compose configuration is valid"
        else
            warn "Docker Compose configuration validation failed. Check override file."
        fi
    fi
}

# ============================================================================
# PRE-FLIGHT CHECKS
# ============================================================================

preflight_checks() {
    header "Pre-flight Checks"

    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use sudo)"
    fi
    log "Running as root: OK"

    # Check Docker
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker Engine first."
    fi
    DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+' | head -1)
    log "Docker version: $DOCKER_VERSION"

    # Check Docker Compose
    if ! docker compose version &> /dev/null; then
        error "Docker Compose v2 is not installed."
    fi
    COMPOSE_VERSION=$(docker compose version --short)
    log "Docker Compose version: $COMPOSE_VERSION"

    # Check Git
    if ! command -v git &> /dev/null; then
        error "Git is not installed. Please install git first."
    fi
    log "Git: OK"

    # Check available memory
    TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
    if [[ $TOTAL_MEM -lt 4 ]]; then
        warn "System has less than 4GB RAM. Hermes SEG may not perform optimally."
    else
        log "Memory: ${TOTAL_MEM}GB available"
    fi

    # Check disk space
    AVAILABLE_DISK=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')
    if [[ $AVAILABLE_DISK -lt 50 ]]; then
        warn "Less than 50GB disk space available. Consider expanding storage."
    else
        log "Disk space: ${AVAILABLE_DISK}GB available"
    fi

    log "Pre-flight checks completed"
}

# ============================================================================
# GENERATE SECRETS
# ============================================================================

generate_secrets() {
    header "Generating Secrets"

    mkdir -p "$SECRETS_DIR"
    mkdir -p "$CREDS_DIR"
    chmod 700 "$SECRETS_DIR" "$CREDS_DIR"

    # MariaDB root password
    if [[ ! -f "${CREDS_DIR}/mysql_root_password" ]]; then
        MYSQL_ROOT_PASS=$(generate_password)
        echo -n "$MYSQL_ROOT_PASS" > "${CREDS_DIR}/mysql_root_password"
        chmod 600 "${CREDS_DIR}/mysql_root_password"
        log "Generated MySQL root password"
    else
        log "MySQL root password already exists, skipping"
    fi

    # Hermes database credentials
    if [[ ! -f "${CREDS_DIR}/hermes_username" ]]; then
        HERMES_DB_USER=$(prompt_with_default "Hermes database username" "hermes")
        echo -n "$HERMES_DB_USER" > "${CREDS_DIR}/hermes_username"
        chmod 600 "${CREDS_DIR}/hermes_username"
        log "Created Hermes database username: $HERMES_DB_USER"
    else
        log "Hermes database username already exists, skipping"
    fi

    if [[ ! -f "${CREDS_DIR}/hermes_password" ]]; then
        HERMES_DB_PASS=$(generate_password)
        echo -n "$HERMES_DB_PASS" > "${CREDS_DIR}/hermes_password"
        chmod 600 "${CREDS_DIR}/hermes_password"
        log "Generated Hermes database password"
    else
        log "Hermes database password already exists, skipping"
    fi

    # Authelia database credentials (in keys/ for Authelia container access)
    if [[ ! -f "${SECRETS_DIR}/authelia_username" ]]; then
        AUTHELIA_DB_USER=$(prompt_with_default "Authelia database username" "authelia")
        echo -n "$AUTHELIA_DB_USER" > "${SECRETS_DIR}/authelia_username"
        chmod 600 "${SECRETS_DIR}/authelia_username"
        log "Created Authelia database username: $AUTHELIA_DB_USER"
    else
        log "Authelia database username already exists, skipping"
    fi

    if [[ ! -f "${SECRETS_DIR}/authelia_password" ]]; then
        AUTHELIA_DB_PASS=$(generate_password)
        echo -n "$AUTHELIA_DB_PASS" > "${SECRETS_DIR}/authelia_password"
        chmod 600 "${SECRETS_DIR}/authelia_password"
        log "Generated Authelia database password"
    else
        log "Authelia database password already exists, skipping"
    fi

    # Authelia JWT secret (64 bytes hex)
    if [[ ! -f "${SECRETS_DIR}/authelia_jwt_secret" ]]; then
        JWT_SECRET=$(generate_hex 64)
        echo -n "$JWT_SECRET" > "${SECRETS_DIR}/authelia_jwt_secret"
        chmod 600 "${SECRETS_DIR}/authelia_jwt_secret"
        log "Generated Authelia JWT secret"
    else
        log "Authelia JWT secret already exists, skipping"
    fi

    # Authelia session secret (64 bytes hex)
    if [[ ! -f "${SECRETS_DIR}/authelia_session_secret" ]]; then
        SESSION_SECRET=$(generate_hex 64)
        echo -n "$SESSION_SECRET" > "${SECRETS_DIR}/authelia_session_secret"
        chmod 600 "${SECRETS_DIR}/authelia_session_secret"
        log "Generated Authelia session secret"
    else
        log "Authelia session secret already exists, skipping"
    fi

    # Authelia storage encryption key (64 bytes hex)
    if [[ ! -f "${SECRETS_DIR}/authelia_storage_encryption_key_file" ]]; then
        STORAGE_KEY=$(generate_hex 64)
        echo -n "$STORAGE_KEY" > "${SECRETS_DIR}/authelia_storage_encryption_key_file"
        chmod 600 "${SECRETS_DIR}/authelia_storage_encryption_key_file"
        log "Generated Authelia storage encryption key"
    else
        log "Authelia storage encryption key already exists, skipping"
    fi

    # LDAP admin password
    if [[ ! -f "${CREDS_DIR}/ldap_admin_password" ]]; then
        LDAP_ADMIN_PASS=$(generate_password)
        echo -n "$LDAP_ADMIN_PASS" > "${CREDS_DIR}/ldap_admin_password"
        chmod 600 "${CREDS_DIR}/ldap_admin_password"
        log "Generated LDAP admin password"
    else
        log "LDAP admin password already exists, skipping"
    fi

    # LDAP service account password (hermes-ldap-user)
    if [[ ! -f "${CREDS_DIR}/ldap_service_password" ]]; then
        LDAP_SVC_PASS=$(generate_password)
        echo -n "$LDAP_SVC_PASS" > "${CREDS_DIR}/ldap_service_password"
        chmod 600 "${CREDS_DIR}/ldap_service_password"
        log "Generated LDAP service account password"
    else
        log "LDAP service account password already exists, skipping"
    fi

    # Duo API secret key (placeholder - user must configure)
    if [[ ! -f "${SECRETS_DIR}/authelia_duo_api_secret" ]]; then
        echo -n "CONFIGURE_ME" > "${SECRETS_DIR}/authelia_duo_api_secret"
        chmod 600 "${SECRETS_DIR}/authelia_duo_api_secret"
        log "Created Duo API secret placeholder (requires manual configuration)"
    fi

    # Ciphermail database credentials
    if [[ ! -f "${CREDS_DIR}/ciphermail_username" ]]; then
        CIPHERMAIL_DB_USER=$(prompt_with_default "Ciphermail database username" "ciphermail")
        echo -n "$CIPHERMAIL_DB_USER" > "${CREDS_DIR}/ciphermail_username"
        chmod 600 "${CREDS_DIR}/ciphermail_username"
        log "Created Ciphermail database username: $CIPHERMAIL_DB_USER"
    else
        log "Ciphermail database username already exists, skipping"
    fi

    if [[ ! -f "${CREDS_DIR}/ciphermail_password" ]]; then
        CIPHERMAIL_DB_PASS=$(generate_password)
        echo -n "$CIPHERMAIL_DB_PASS" > "${CREDS_DIR}/ciphermail_password"
        chmod 600 "${CREDS_DIR}/ciphermail_password"
        log "Generated Ciphermail database password"
    else
        log "Ciphermail database password already exists, skipping"
    fi

    # Nextcloud admin credentials
    if [[ ! -f "${CREDS_DIR}/nextcloud_admin_username" ]]; then
        NC_ADMIN_USER=$(prompt_with_default "Nextcloud admin username" "ncadmin")
        echo -n "$NC_ADMIN_USER" > "${CREDS_DIR}/nextcloud_admin_username"
        chmod 600 "${CREDS_DIR}/nextcloud_admin_username"
        log "Created Nextcloud admin username: $NC_ADMIN_USER"
    else
        log "Nextcloud admin username already exists, skipping"
    fi

    if [[ ! -f "${CREDS_DIR}/nextcloud_admin_password" ]]; then
        NC_ADMIN_PASS=$(generate_password)
        echo -n "$NC_ADMIN_PASS" > "${CREDS_DIR}/nextcloud_admin_password"
        chmod 600 "${CREDS_DIR}/nextcloud_admin_password"
        log "Generated Nextcloud admin password"
    else
        log "Nextcloud admin password already exists, skipping"
    fi

    # Nextcloud database credentials
    if [[ ! -f "${CREDS_DIR}/nextcloud_username" ]]; then
        NC_DB_USER=$(prompt_with_default "Nextcloud database username" "nextcloud")
        echo -n "$NC_DB_USER" > "${CREDS_DIR}/nextcloud_username"
        chmod 600 "${CREDS_DIR}/nextcloud_username"
        log "Created Nextcloud database username: $NC_DB_USER"
    else
        log "Nextcloud database username already exists, skipping"
    fi

    if [[ ! -f "${CREDS_DIR}/nextcloud_password" ]]; then
        NC_DB_PASS=$(generate_password)
        echo -n "$NC_DB_PASS" > "${CREDS_DIR}/nextcloud_password"
        chmod 600 "${CREDS_DIR}/nextcloud_password"
        log "Generated Nextcloud database password"
    else
        log "Nextcloud database password already exists, skipping"
    fi

    # Nextcloud Redis password
    if [[ ! -f "${CREDS_DIR}/nextcloud_redis_password" ]]; then
        NC_REDIS_PASS=$(generate_password)
        echo -n "$NC_REDIS_PASS" > "${CREDS_DIR}/nextcloud_redis_password"
        chmod 600 "${CREDS_DIR}/nextcloud_redis_password"
        log "Generated Nextcloud Redis password"
    else
        log "Nextcloud Redis password already exists, skipping"
    fi

    # Nextcloud OIDC secret (for Authelia integration)
    if [[ ! -f "${CREDS_DIR}/nextcloud_oidc_secret" ]]; then
        NC_OIDC_SECRET=$(generate_hex 32)
        echo -n "$NC_OIDC_SECRET" > "${CREDS_DIR}/nextcloud_oidc_secret"
        chmod 600 "${CREDS_DIR}/nextcloud_oidc_secret"
        log "Generated Nextcloud OIDC secret"
    else
        log "Nextcloud OIDC secret already exists, skipping"
    fi

    # OpenDMARC database credentials
    if [[ ! -f "${CREDS_DIR}/opendmarc_username" ]]; then
        DMARC_DB_USER=$(prompt_with_default "OpenDMARC database username" "opendmarc")
        echo -n "$DMARC_DB_USER" > "${CREDS_DIR}/opendmarc_username"
        chmod 600 "${CREDS_DIR}/opendmarc_username"
        log "Created OpenDMARC database username: $DMARC_DB_USER"
    else
        log "OpenDMARC database username already exists, skipping"
    fi

    if [[ ! -f "${CREDS_DIR}/opendmarc_password" ]]; then
        DMARC_DB_PASS=$(generate_password)
        echo -n "$DMARC_DB_PASS" > "${CREDS_DIR}/opendmarc_password"
        chmod 600 "${CREDS_DIR}/opendmarc_password"
        log "Generated OpenDMARC database password"
    else
        log "OpenDMARC database password already exists, skipping"
    fi

    # Syslog database credentials
    if [[ ! -f "${CREDS_DIR}/syslog_username" ]]; then
        SYSLOG_DB_USER=$(prompt_with_default "Syslog database username" "syslog")
        echo -n "$SYSLOG_DB_USER" > "${CREDS_DIR}/syslog_username"
        chmod 600 "${CREDS_DIR}/syslog_username"
        log "Created Syslog database username: $SYSLOG_DB_USER"
    else
        log "Syslog database username already exists, skipping"
    fi

    if [[ ! -f "${CREDS_DIR}/syslog_password" ]]; then
        SYSLOG_DB_PASS=$(generate_password)
        echo -n "$SYSLOG_DB_PASS" > "${CREDS_DIR}/syslog_password"
        chmod 600 "${CREDS_DIR}/syslog_password"
        log "Generated Syslog database password"
    else
        log "Syslog database password already exists, skipping"
    fi

    log "Secrets generation completed"
}

# ============================================================================
# CREATE DATABASES
# ============================================================================

create_databases() {
    header "Creating Databases"

    # Read credentials
    MYSQL_ROOT_PASS=$(cat "${CREDS_DIR}/mysql_root_password")
    HERMES_DB_USER=$(cat "${CREDS_DIR}/hermes_username")
    HERMES_DB_PASS=$(cat "${CREDS_DIR}/hermes_password")
    AUTHELIA_DB_USER=$(cat "${SECRETS_DIR}/authelia_username")
    AUTHELIA_DB_PASS=$(cat "${SECRETS_DIR}/authelia_password")

    # Wait for MariaDB to be ready
    log "Waiting for MariaDB to be ready..."
    for i in {1..30}; do
        if docker exec hermes_db_server mysqladmin ping -u root -p"${MYSQL_ROOT_PASS}" --silent 2>/dev/null; then
            log "MariaDB is ready"
            break
        fi
        if [[ $i -eq 30 ]]; then
            error "MariaDB did not become ready in time"
        fi
        sleep 2
    done

    # Create Hermes database and user
    log "Creating Hermes database..."
    docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "
        CREATE DATABASE IF NOT EXISTS hermes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${HERMES_DB_USER}'@'%' IDENTIFIED BY '${HERMES_DB_PASS}';
        GRANT ALL PRIVILEGES ON hermes.* TO '${HERMES_DB_USER}'@'%';
    " 2>> "$LOG_FILE"
    log "Hermes database created"

    # Create Authelia database and user
    log "Creating Authelia database..."
    docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "
        CREATE DATABASE IF NOT EXISTS authelia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
        CREATE USER IF NOT EXISTS '${AUTHELIA_DB_USER}'@'%' IDENTIFIED BY '${AUTHELIA_DB_PASS}';
        GRANT ALL PRIVILEGES ON authelia.* TO '${AUTHELIA_DB_USER}'@'%';
        FLUSH PRIVILEGES;
    " 2>> "$LOG_FILE"
    log "Authelia database created"

    # Import Hermes schema
    if [[ -f "${HERMES_ROOT}/config/database/hermes_schema.sql" ]]; then
        log "Importing Hermes database schema..."
        docker exec -i hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" hermes < "${HERMES_ROOT}/config/database/hermes_schema.sql" 2>> "$LOG_FILE"
        log "Hermes schema imported"
    else
        warn "Hermes schema file not found, skipping import"
    fi

    log "Database creation completed"
}

# ============================================================================
# CONFIGURE AUTHELIA FOR MYSQL
# ============================================================================

configure_authelia_mysql() {
    header "Verifying Authelia MySQL Configuration"

    AUTHELIA_CONFIG="${HERMES_ROOT}/config/authelia/configuration.yml"

    if [[ ! -f "$AUTHELIA_CONFIG" ]]; then
        warn "Authelia configuration file not found: $AUTHELIA_CONFIG"
        warn "The template should be copied during installation"
        return 1
    fi

    # Verify MySQL is configured (template should already have this)
    if grep -q "mysql:" "$AUTHELIA_CONFIG"; then
        log "Authelia MySQL storage configured (via template)"
    else
        error "Authelia configuration missing MySQL storage block"
        error "Check that config/authelia/configuration.yml has the correct storage section"
        return 1
    fi

    # Verify required secret files exist
    local missing_secrets=0
    for secret_file in authelia_username authelia_password authelia_storage_encryption_key_file; do
        if [[ ! -f "${SECRETS_DIR}/${secret_file}" ]]; then
            warn "Missing secret file: ${SECRETS_DIR}/${secret_file}"
            missing_secrets=1
        fi
    done

    if [[ $missing_secrets -eq 1 ]]; then
        error "Run --generate-secrets first to create missing secret files"
        return 1
    fi

    log "Authelia MySQL configuration verified"
    log "  Database: authelia (created in MariaDB)"
    log "  Username: $(cat ${SECRETS_DIR}/authelia_username)"
    log "  Secrets: ${SECRETS_DIR}/authelia_*"
}

# ============================================================================
# INITIALIZE LDAP
# ============================================================================

initialize_ldap() {
    header "Initializing LDAP Directory"

    # Wait for OpenLDAP to be ready
    log "Waiting for OpenLDAP to be ready..."
    for i in {1..30}; do
        if docker exec hermes_openldap ldapsearch -x -H ldap://localhost -b "" -s base "(objectclass=*)" 2>/dev/null | grep -q "namingContexts"; then
            log "OpenLDAP is ready"
            break
        fi
        if [[ $i -eq 30 ]]; then
            error "OpenLDAP did not become ready in time"
        fi
        sleep 2
    done

    # Check if base structure already exists
    LDAP_ADMIN_PASS=$(cat "${CREDS_DIR}/ldap_admin_password")
    if docker exec hermes_openldap ldapsearch -x -H ldap://localhost -D "cn=admin,dc=hermes,dc=local" -w "$LDAP_ADMIN_PASS" -b "ou=users,dc=hermes,dc=local" "(objectClass=*)" 2>/dev/null | grep -q "ou=users"; then
        log "LDAP base structure already exists"
        return
    fi

    log "Creating LDAP base structure..."
    # The base structure should be created by the LDAP container's seed data
    # This is a placeholder for any additional initialization

    log "LDAP initialization completed"
}

# ============================================================================
# MAIN INSTALLATION
# ============================================================================

main() {
    clear
    echo ""
    echo "  _   _                               ____  _____ ____ "
    echo " | | | | ___ _ __ _ __ ___   ___  ___/ ___|| ____/ ___|"
    echo " | |_| |/ _ \\ '__| '_ \` _ \\ / _ \\/ __\\___ \\|  _|| |  _ "
    echo " |  _  |  __/ |  | | | | | |  __/\\__ \\___) | |__| |_| |"
    echo " |_| |_|\\___|_|  |_| |_| |_|\\___||___/____/|_____\\____|"
    echo ""
    echo "         Secure Email Gateway - Docker Installation"
    echo "                      Version 2.6.0"
    echo ""
    echo "============================================================"
    echo ""

    # Confirm installation
    read -p "This will install Hermes SEG. Continue? (y/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi

    # Start logging
    touch "$LOG_FILE"
    log "Installation started at $(date)"
    log "Log file: $LOG_FILE"

    # Run installation steps
    preflight_checks
    configure_mount_points
    generate_compose_override
    generate_secrets

    # Note: The following steps require containers to be running
    # They should be called after 'docker compose up -d'

    header "Next Steps"
    echo ""
    echo "Phase 1 complete. To finish installation:"
    echo ""
    echo "1. Start the containers:"
    echo "   cd ${HERMES_ROOT}"
    echo "   docker compose up -d"
    echo ""
    echo "2. Wait for containers to initialize (about 60 seconds)"
    echo ""
    echo "3. Run database initialization (as root):"
    echo "   ./scripts/install_hermes_docker.sh --init-db"
    echo ""
    echo "4. Access the admin console:"
    echo "   https://YOUR_SERVER_IP/admin/"
    echo ""
    if [[ "${USE_DOCKER_VOLUMES}" != "true" ]]; then
        echo "Storage Configuration:"
        echo "   System data:    ${DATA_MOUNT}"
        echo "   Email storage:  ${VMAIL_MOUNT}"
        if [[ "${ENABLE_NEXTCLOUD}" == "true" ]]; then
            echo "   Nextcloud files: ${FILES_MOUNT}"
        else
            echo "   Nextcloud files: disabled"
        fi
        echo ""
    fi
    echo "Log file: ${LOG_FILE}"
    echo "============================================================"
    echo ""

    log "Installation phase 1 completed"
}

# ============================================================================
# COMMAND LINE HANDLING
# ============================================================================

case "${1:-}" in
    --init-db)
        # Initialize databases and configure services (run after containers are up)
        touch "$LOG_FILE"
        log "Database initialization started at $(date)"
        create_databases
        configure_authelia_mysql
        initialize_ldap

        # Nextcloud post-install configuration
        log "Configuring Nextcloud..."

        # Read hostname from .env (needed for theming URL and OIDC discovery)
        NC_HOSTNAME=""
        if [[ -f "${HERMES_ROOT}/.env" ]]; then
            NC_HOSTNAME=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
        fi

        # Default app
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:set defaultapp --value="mail,calendar,contacts,dashboard" >> "$LOG_FILE" 2>&1 \
            && log "  Set default app to Mail" \
            || log "  WARNING: Failed to set default app (Nextcloud may not be ready yet)"

        # Install apps
        log "  Installing Nextcloud apps..."
        for app in user_oidc mail calendar contacts external; do
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ app:install "$app" --force >> "$LOG_FILE" 2>&1 \
                && log "    Installed: $app" \
                || log "    WARNING: $app install failed (may already be installed)"
        done

        # Disable unwanted default apps
        for app in dashboard photos; do
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ app:disable "$app" >> "$LOG_FILE" 2>&1 \
                && log "    Disabled: $app" \
                || log "    WARNING: Failed to disable $app"
        done

        # Theming
        log "  Configuring Nextcloud theming..."
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config name "Hermes SEG" >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config logo /img/hermes_logo_new_orange2.png >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config slogan "Secure Email Gateway and Server" >> "$LOG_FILE" 2>&1
        if [[ -n "$NC_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config url "https://${NC_HOSTNAME}" >> "$LOG_FILE" 2>&1
        fi
        log "  Theming configured"

        # External Sites: "User Console" link in NC top menu
        if [[ -n "$NC_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set external sites \
                --value='{"1":{"id":1,"name":"User Console","url":"https://'"${NC_HOSTNAME}"'/users/","lang":"","type":"link","device":"","icon":"external.svg","groups":[],"redirect":false}}' >> "$LOG_FILE" 2>&1 \
                && log "  External Sites: User Console link configured" \
                || log "  WARNING: Failed to set External Sites link"
        fi

        # OIDC provider registration (user_oidc)
        log "  Configuring OIDC provider..."
        OIDC_CLIENT_SECRET=""
        if [[ -f "${SECRETS_DIR}/authelia_identity_providers_oidc_clients_client_secret_plain_file" ]]; then
            OIDC_CLIENT_SECRET=$(cat "${SECRETS_DIR}/authelia_identity_providers_oidc_clients_client_secret_plain_file")
        fi

        if [[ -n "$OIDC_CLIENT_SECRET" ]] && [[ -n "$NC_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ user_oidc:provider Hermes_SEG \
                --clientid="Hermes_SEG_Webmail" \
                --clientsecret="$OIDC_CLIENT_SECRET" \
                --discoveryuri="https://${NC_HOSTNAME}/.well-known/openid-configuration" \
                --endsessionendpointuri="https://${NC_HOSTNAME}/logout" \
                --unique-uid=0 \
                --mapping-uid="preferred_username" \
                --mapping-display-name="name" \
                --mapping-email="email" \
                --mapping-groups="groups" \
                --group-provisioning=1 \
                --check-bearer=1 >> "$LOG_FILE" 2>&1 \
                && log "  Registered OIDC provider: Hermes_SEG" \
                || log "  WARNING: Failed to register OIDC provider"

            # Auto-redirect enabled by default (allow_multiple_user_backends=0)
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set --type=string --value=0 user_oidc allow_multiple_user_backends >> "$LOG_FILE" 2>&1 \
                && log "  OIDC auto-redirect enabled" \
                || log "  WARNING: Failed to set OIDC auto-redirect"
        else
            log "  WARNING: Skipping OIDC provider registration (missing client secret or hostname)"
            [[ -z "$OIDC_CLIENT_SECRET" ]] && log "    - OIDC client secret not found at ${SECRETS_DIR}/authelia_identity_providers_oidc_clients_client_secret_plain_file"
            [[ -z "$NC_HOSTNAME" ]] && log "    - HERMES_HOSTNAME not found in ${HERMES_ROOT}/.env"
        fi

        # Inject database credentials into config files
        log "Injecting database credentials into config files..."
        if [[ -x "${HERMES_ROOT}/config/hermes/opt/hermes/scripts/rotate_db_credentials.sh" ]]; then
            "${HERMES_ROOT}/config/hermes/opt/hermes/scripts/rotate_db_credentials.sh" --non-interactive >> "$LOG_FILE" 2>&1 \
                && log "  Database credentials injected into all config files" \
                || log "  WARNING: Credential injection failed — run rotate_db_credentials.sh manually"
        else
            log "  WARNING: rotate_db_credentials.sh not found — skipping credential injection"
        fi

        log "Database initialization completed"
        ;;
    --generate-secrets)
        # Only generate secrets
        touch "$LOG_FILE"
        generate_secrets
        ;;
    --configure-storage)
        # Configure storage mount points
        touch "$LOG_FILE"
        log "Storage configuration started at $(date)"
        configure_mount_points
        generate_compose_override
        log "Storage configuration completed"
        echo ""
        echo "Storage configured. Restart containers to apply changes:"
        echo "  docker compose down && docker compose up -d"
        echo ""
        ;;
    --generate-override)
        # Regenerate docker-compose.override.yml from saved config
        touch "$LOG_FILE"
        if ! load_config; then
            error "No configuration found. Run --configure-storage first."
        fi
        generate_compose_override
        ;;
    --show-config)
        # Display current configuration
        if [[ -f "$CONFIG_FILE" ]]; then
            source "$CONFIG_FILE"
            echo "Current Hermes SEG Configuration:"
            echo "=================================="
            echo ""
            if [[ "${USE_DOCKER_VOLUMES}" == "true" ]]; then
                echo "Storage Mode: Default Docker volumes (NOT RECOMMENDED)"
                echo "  Data location: /var/lib/docker/volumes"
            else
                echo "Storage Mode: Custom mount points (RECOMMENDED)"
                echo "  System data:    ${DATA_MOUNT:-not set}"
                echo "  Email storage:  ${VMAIL_MOUNT:-not set}"
                if [[ "${ENABLE_NEXTCLOUD}" == "true" ]]; then
                    echo "  Nextcloud files: ${FILES_MOUNT:-not set}"
                else
                    echo "  Nextcloud files: disabled"
                fi
            fi
            echo ""
            echo "Installation root: ${HERMES_ROOT}"
            echo ""
            if [[ -f "${HERMES_ROOT}/docker-compose.override.yml" ]]; then
                echo "Override file: ${HERMES_ROOT}/docker-compose.override.yml (exists)"
            else
                echo "Override file: not generated"
            fi
        else
            echo "No configuration found. Run installation first."
        fi
        ;;
    --help|-h)
        echo "Hermes SEG Docker Installation Script"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Installation:"
        echo "  (none)               Run full installation (phase 1)"
        echo "  --init-db            Initialize databases (phase 2, after containers up)"
        echo ""
        echo "Configuration:"
        echo "  --configure-storage  Configure storage mount points"
        echo "  --generate-override  Regenerate docker-compose.override.yml"
        echo "  --generate-secrets   Generate secrets only"
        echo "  --show-config        Display current configuration"
        echo ""
        echo "Help:"
        echo "  --help, -h           Show this help message"
        echo ""
        echo "Storage Mount Points:"
        echo "  The installer configures three separate storage locations:"
        echo "    - System data:     Databases, logs, quarantine, LDAP (default: /mnt/data)"
        echo "    - Email storage:   Mailbox user emails (default: /mnt/vmail)"
        echo "    - Nextcloud files: User file storage (optional, default: /mnt/files)"
        echo ""
        echo "Typical installation flow (run as root):"
        echo "  1. ./install_hermes_docker.sh              # Phase 1: setup"
        echo "  2. docker compose up -d                    # Start containers"
        echo "  3. ./install_hermes_docker.sh --init-db    # Phase 2: databases"
        echo ""
        ;;
    "")
        main
        ;;
    *)
        error "Unknown option: $1. Use --help for usage."
        ;;
esac
