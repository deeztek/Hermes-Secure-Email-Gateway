#!/bin/bash
# ============================================================================
# Hermes SEG - Legacy to Docker Migration Script
# ============================================================================
#
# This script migrates a legacy (non-Docker) Hermes SEG installation to Docker.
# It processes backups created by the legacy system_backup.sh script.
#
# Prerequisites:
#   - Docker and Docker Compose installed
#   - Hermes SEG Docker repository cloned to /opt/hermes-seg
#   - Legacy backup file (hermes-system-*.tar.gz)
#   - MySQL root password from the legacy system
#
# Usage:
#   ./migrate_legacy_to_docker.sh -B /path/to/hermes-system-backup.tar.gz -R 'mysql_root_password'
#
# Flags:
#   -B = Path to the legacy backup file (hermes-system-*.tar.gz)
#   -R = MySQL root password (will be used for the new Docker MariaDB)
#   -D = Docker Hermes root (default: /opt/hermes-seg)
#   -M = Data mount point (default: /mnt/data)
#   -V = Vmail mount point (default: /mnt/vmail)
#
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Defaults
HERMES_ROOT="/opt/hermes-seg"
DATA_MOUNT="/mnt/data"
ARCHIVE_MOUNT="/mnt/archive"  # #260: Amavis quarantine tier
VMAIL_MOUNT="/mnt/vmail"
TEMP_DIR="/tmp/hermes_migration_$$"
LOG_FILE="/var/log/hermes_migration_$(date +%Y%m%d_%H%M%S).log"

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
    echo "" | tee -a "$LOG_FILE"
    echo -e "${BLUE}============================================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}  $1${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}============================================================${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        log "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT

# ============================================================================
# PARSE ARGUMENTS
# ============================================================================

while getopts B:R:D:M:A:V: flag
do
    case "${flag}" in
        B) BACKUP_FILE=${OPTARG};;
        R) MYSQL_ROOT_PASS=${OPTARG};;
        D) HERMES_ROOT=${OPTARG};;
        M) DATA_MOUNT=${OPTARG};;
        A) ARCHIVE_MOUNT=${OPTARG};;
        V) VMAIL_MOUNT=${OPTARG};;
    esac
done

# ============================================================================
# VALIDATE INPUTS
# ============================================================================

header "Hermes SEG Legacy to Docker Migration"

# Check root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root"
fi

# Validate backup file
if [[ -z "${BACKUP_FILE}" ]]; then
    error "Backup file path (-B) is required"
fi

if [[ ! -f "${BACKUP_FILE}" ]]; then
    error "Backup file not found: ${BACKUP_FILE}"
fi

# Validate MySQL root password
if [[ -z "${MYSQL_ROOT_PASS}" ]]; then
    echo ""
    echo "Enter the MySQL root password for the Docker MariaDB instance."
    echo "This will be used to restore databases and create new ones."
    echo ""
    read -s -p "MySQL root password: " MYSQL_ROOT_PASS
    echo ""
    if [[ -z "${MYSQL_ROOT_PASS}" ]]; then
        error "MySQL root password is required"
    fi
fi

# Validate Hermes root
if [[ ! -d "${HERMES_ROOT}" ]]; then
    error "Hermes Docker root not found: ${HERMES_ROOT}"
fi

if [[ ! -f "${HERMES_ROOT}/docker-compose.yml" ]]; then
    error "docker-compose.yml not found in ${HERMES_ROOT}"
fi

log "Backup file:   ${BACKUP_FILE}"
log "Hermes root:   ${HERMES_ROOT}"
log "Data mount:    ${DATA_MOUNT}"
log "Archive mount: ${ARCHIVE_MOUNT}"
log "Vmail mount:   ${VMAIL_MOUNT}"
log "Log file:      ${LOG_FILE}"

# ============================================================================
# CONFIRM MIGRATION
# ============================================================================

echo ""
echo -e "${YELLOW}WARNING: This migration will:${NC}"
echo "  1. Extract the legacy backup to a temporary location"
echo "  2. Restore databases to the Docker MariaDB container"
echo "  3. Copy configuration files to Docker volume paths"
echo "  4. Create new databases (authelia, nextcloud) for Docker services"
echo "  5. Migrate Authelia users from YAML to LDAP"
echo ""
echo -e "${YELLOW}This assumes Docker containers are RUNNING.${NC}"
echo ""
read -p "Continue with migration? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    log "Migration cancelled by user"
    exit 0
fi

# ============================================================================
# CHECK DOCKER CONTAINERS
# ============================================================================

header "Checking Docker Containers"

# Check if MariaDB container is running
if ! docker ps --format '{{.Names}}' | grep -q "^hermes_db_server$"; then
    error "hermes_db_server container is not running. Start Docker stack first: docker compose up -d"
fi

# Check if we can connect to MariaDB
log "Testing MariaDB connection..."
if ! docker exec hermes_db_server mysqladmin ping -u root -p"${MYSQL_ROOT_PASS}" --silent 2>/dev/null; then
    error "Cannot connect to MariaDB. Check the root password."
fi
log "MariaDB connection successful"

# ============================================================================
# EXTRACT BACKUP
# ============================================================================

header "Extracting Legacy Backup"

mkdir -p "$TEMP_DIR"
log "Extracting to: ${TEMP_DIR}"

tar -xzf "${BACKUP_FILE}" -C "${TEMP_DIR}" >> "$LOG_FILE" 2>&1

# Verify extraction
if [[ ! -d "${TEMP_DIR}/opt/hermes" ]]; then
    error "Backup extraction failed - /opt/hermes not found in backup"
fi

log "Backup extracted successfully"

# List what was extracted
log "Contents extracted:"
ls -la "${TEMP_DIR}/" >> "$LOG_FILE" 2>&1

# ============================================================================
# RESTORE DATABASES
# ============================================================================

header "Restoring Legacy Databases"

# Database files should be in the root of the extracted archive (from dbbkup)
DB_DIR="${TEMP_DIR}"

# Find database dumps - they might be in root or in a dbbkup subdirectory
if [[ -f "${TEMP_DIR}/hermes.sql" ]]; then
    DB_DIR="${TEMP_DIR}"
elif [[ -f "${TEMP_DIR}/dbbkup/hermes.sql" ]]; then
    DB_DIR="${TEMP_DIR}/dbbkup"
else
    # Search for the SQL files
    HERMES_SQL=$(find "${TEMP_DIR}" -name "hermes.sql" -type f 2>/dev/null | head -1)
    if [[ -n "$HERMES_SQL" ]]; then
        DB_DIR=$(dirname "$HERMES_SQL")
    else
        error "Could not locate database dumps in backup"
    fi
fi

log "Database dumps found in: ${DB_DIR}"

# Restore Hermes database
if [[ -f "${DB_DIR}/hermes.sql" ]]; then
    log "Restoring hermes database..."
    docker exec -i hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" < "${DB_DIR}/hermes.sql" >> "$LOG_FILE" 2>&1
    log "hermes database restored"
else
    warn "hermes.sql not found - skipping"
fi

# Restore Ciphermail database (djigzo)
if [[ -f "${DB_DIR}/djigzo.sql" ]]; then
    log "Restoring djigzo (Ciphermail) database..."
    docker exec -i hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" < "${DB_DIR}/djigzo.sql" >> "$LOG_FILE" 2>&1
    log "djigzo database restored"
else
    warn "djigzo.sql not found - skipping"
fi

# Restore OpenDMARC database
if [[ -f "${DB_DIR}/opendmarc.sql" ]]; then
    log "Restoring opendmarc database..."
    docker exec -i hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" < "${DB_DIR}/opendmarc.sql" >> "$LOG_FILE" 2>&1
    log "opendmarc database restored"
else
    warn "opendmarc.sql not found - skipping"
fi

# Restore Syslog database
if [[ -f "${DB_DIR}/Syslog.sql" ]]; then
    log "Restoring Syslog database..."
    docker exec -i hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" < "${DB_DIR}/Syslog.sql" >> "$LOG_FILE" 2>&1
    log "Syslog database restored"
else
    warn "Syslog.sql not found - skipping"
fi

# ============================================================================
# CREATE NEW DATABASES (Docker-only services)
# ============================================================================

header "Creating New Databases for Docker Services"

# Read credentials from secrets directory
SECRETS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/keys"
CREDS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/creds"

# Create Authelia database
log "Creating Authelia database..."
AUTHELIA_USER="authelia"
if [[ -f "${SECRETS_DIR}/authelia_username" ]]; then
    AUTHELIA_USER=$(cat "${SECRETS_DIR}/authelia_username")
fi

AUTHELIA_PASS=""
if [[ -f "${SECRETS_DIR}/authelia_password" ]]; then
    AUTHELIA_PASS=$(cat "${SECRETS_DIR}/authelia_password")
else
    # Generate a new password
    AUTHELIA_PASS=$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)
    echo -n "$AUTHELIA_PASS" > "${SECRETS_DIR}/authelia_password"
    chmod 600 "${SECRETS_DIR}/authelia_password"
    log "Generated new Authelia database password"
fi

docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "
    CREATE DATABASE IF NOT EXISTS authelia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
    CREATE USER IF NOT EXISTS '${AUTHELIA_USER}'@'%' IDENTIFIED BY '${AUTHELIA_PASS}';
    GRANT ALL PRIVILEGES ON authelia.* TO '${AUTHELIA_USER}'@'%';
" >> "$LOG_FILE" 2>&1
log "Authelia database created"

# Create Nextcloud database
log "Creating Nextcloud database..."
NEXTCLOUD_USER="nextcloud"
if [[ -f "${CREDS_DIR}/nextcloud_mysql_username" ]]; then
    NEXTCLOUD_USER=$(cat "${CREDS_DIR}/nextcloud_mysql_username")
fi

NEXTCLOUD_PASS=""
if [[ -f "${CREDS_DIR}/nextcloud_mysql_password" ]]; then
    NEXTCLOUD_PASS=$(cat "${CREDS_DIR}/nextcloud_mysql_password")
else
    # Generate a new password
    NEXTCLOUD_PASS=$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)
    echo -n "$NEXTCLOUD_PASS" > "${CREDS_DIR}/nextcloud_mysql_password"
    chmod 600 "${CREDS_DIR}/nextcloud_mysql_password"
    log "Generated new Nextcloud database password"
fi

docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "
    CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${NEXTCLOUD_USER}'@'%' IDENTIFIED BY '${NEXTCLOUD_PASS}';
    GRANT ALL PRIVILEGES ON nextcloud.* TO '${NEXTCLOUD_USER}'@'%';
" >> "$LOG_FILE" 2>&1
log "Nextcloud database created"

# Flush privileges
docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "FLUSH PRIVILEGES;" >> "$LOG_FILE" 2>&1

# ============================================================================
# COPY CONFIGURATION FILES
# ============================================================================

header "Copying Configuration Files"

# Map legacy paths to Docker paths
# /opt/hermes/ -> ./config/hermes/opt/hermes/
if [[ -d "${TEMP_DIR}/opt/hermes" ]]; then
    log "Copying /opt/hermes..."

    # Keys directory (be careful not to overwrite generated secrets)
    if [[ -d "${TEMP_DIR}/opt/hermes/keys" ]]; then
        # Backup existing keys first
        if [[ -d "${HERMES_ROOT}/config/hermes/opt/hermes/keys" ]]; then
            cp -a "${HERMES_ROOT}/config/hermes/opt/hermes/keys" "${HERMES_ROOT}/config/hermes/opt/hermes/keys.docker-backup"
        fi
        # Copy legacy keys
        cp -a "${TEMP_DIR}/opt/hermes/keys/"* "${HERMES_ROOT}/config/hermes/opt/hermes/keys/" 2>/dev/null || true
    fi

    # Creds directory
    if [[ -d "${TEMP_DIR}/opt/hermes/creds" ]]; then
        if [[ -d "${HERMES_ROOT}/config/hermes/opt/hermes/creds" ]]; then
            cp -a "${HERMES_ROOT}/config/hermes/opt/hermes/creds" "${HERMES_ROOT}/config/hermes/opt/hermes/creds.docker-backup"
        fi
        cp -a "${TEMP_DIR}/opt/hermes/creds/"* "${HERMES_ROOT}/config/hermes/opt/hermes/creds/" 2>/dev/null || true
    fi

    # SSL certificates
    if [[ -d "${TEMP_DIR}/opt/hermes/ssl" ]]; then
        mkdir -p "${HERMES_ROOT}/config/hermes/opt/hermes/ssl"
        cp -a "${TEMP_DIR}/opt/hermes/ssl/"* "${HERMES_ROOT}/config/hermes/opt/hermes/ssl/" 2>/dev/null || true
    fi

    log "/opt/hermes copied"
fi

# /etc/postfix/ -> ./config/postfix-dkim/etc/postfix/
if [[ -d "${TEMP_DIR}/etc/postfix" ]]; then
    log "Copying /etc/postfix..."
    cp -a "${TEMP_DIR}/etc/postfix/"* "${HERMES_ROOT}/config/postfix-dkim/etc/postfix/" 2>/dev/null || true
    log "/etc/postfix copied"
fi

# /etc/amavis/ -> ./config/mail_filter/etc/amavis/
if [[ -d "${TEMP_DIR}/etc/amavis" ]]; then
    log "Copying /etc/amavis..."
    cp -a "${TEMP_DIR}/etc/amavis/"* "${HERMES_ROOT}/config/mail_filter/etc/amavis/" 2>/dev/null || true
    log "/etc/amavis copied"
fi

# /etc/letsencrypt/ -> ./config/certbot/conf/
if [[ -d "${TEMP_DIR}/etc/letsencrypt" ]]; then
    log "Copying /etc/letsencrypt..."
    mkdir -p "${HERMES_ROOT}/config/certbot/conf"
    cp -a "${TEMP_DIR}/etc/letsencrypt/"* "${HERMES_ROOT}/config/certbot/conf/" 2>/dev/null || true
    log "/etc/letsencrypt copied"
fi

# /var/www/html/ -> ./config/hermes/var/www/html/
# Note: We DON'T copy the web files - Docker has its own version
# Only copy custom files if they exist
if [[ -d "${TEMP_DIR}/var/www/html/custom" ]]; then
    log "Copying custom web files..."
    mkdir -p "${HERMES_ROOT}/config/hermes/var/www/html/custom"
    cp -a "${TEMP_DIR}/var/www/html/custom/"* "${HERMES_ROOT}/config/hermes/var/www/html/custom/" 2>/dev/null || true
fi

# /etc/spamassassin/ -> ./config/mail_filter/etc/spamassassin/
if [[ -d "${TEMP_DIR}/etc/spamassassin" ]]; then
    log "Copying /etc/spamassassin..."
    cp -a "${TEMP_DIR}/etc/spamassassin/"* "${HERMES_ROOT}/config/mail_filter/etc/spamassassin/" 2>/dev/null || true
    log "/etc/spamassassin copied"
fi

# /etc/clamav/ -> ./config/mail_filter/etc/clamav/
if [[ -d "${TEMP_DIR}/etc/clamav" ]]; then
    log "Copying /etc/clamav..."
    cp -a "${TEMP_DIR}/etc/clamav/"* "${HERMES_ROOT}/config/mail_filter/etc/clamav/" 2>/dev/null || true
    log "/etc/clamav copied"
fi

# ============================================================================
# MIGRATE AUTHELIA USERS TO LDAP
# ============================================================================

header "Migrating Authelia Users to LDAP"

echo ""
echo -e "${YELLOW}IMPORTANT - Two-Factor Authentication Devices:${NC}"
echo ""
echo "  The legacy system used SQLite for Authelia storage."
echo "  Docker uses MySQL. Migrating storage backends affects 2FA devices:"
echo ""
echo "  | 2FA Method  | Storage Location  | Preserved? |"
echo "  |-------------|-------------------|------------|"
echo "  | Duo Push    | Duo cloud servers | YES        |"
echo "  | TOTP        | Authelia database | NO         |"
echo "  | WebAuthn    | Authelia database | NO         |"
echo ""
echo "  Users with TOTP (Google Authenticator, etc.) or WebAuthn (hardware keys)"
echo "  will need to re-register their devices after migration."
echo ""
echo "  Duo Push users are not affected - their enrollment is stored on Duo's servers."
echo ""

AUTHELIA_USERS_FILE="${TEMP_DIR}/etc/authelia/users_database.yml"

if [[ -f "$AUTHELIA_USERS_FILE" ]]; then
    log "Found Authelia users file: ${AUTHELIA_USERS_FILE}"

    # Check if LDAP container is running
    if docker ps --format '{{.Names}}' | grep -q "^hermes_ldap$\|^hermes_openldap$"; then
        log "LDAP container is running"

        # Parse the users_database.yml and create LDAP entries
        # This is a simplified parser - for production, use a proper YAML parser

        warn "User migration requires manual steps:"
        echo ""
        echo "  1. Review the Authelia users file at:"
        echo "     ${AUTHELIA_USERS_FILE}"
        echo ""
        echo "  2. For each user, create an LDAP entry using the admin console:"
        echo "     - Go to System > Users > Add User"
        echo "     - The Argon2 password hash can be migrated by prefixing with {ARGON2}"
        echo ""
        echo "  3. Or use the following commands to migrate users manually:"
        echo ""

        # Extract usernames from the file (basic parsing)
        if command -v python3 &> /dev/null; then
            python3 -c "
import yaml
import sys

try:
    with open('${AUTHELIA_USERS_FILE}', 'r') as f:
        data = yaml.safe_load(f)

    if 'users' in data:
        for username, info in data['users'].items():
            print(f'  User: {username}')
            print(f'    Email: {info.get(\"email\", \"N/A\")}')
            print(f'    Display: {info.get(\"displayname\", \"N/A\")}')
            print(f'    Groups: {\", \".join(info.get(\"groups\", []))}')
            print()
except Exception as e:
    print(f'  Could not parse users file: {e}')
" 2>/dev/null || warn "Could not parse users file (install python3-yaml for detailed parsing)"
        else
            warn "Install python3 with PyYAML for automatic user parsing"
            echo "  Users file contents:"
            head -50 "$AUTHELIA_USERS_FILE"
        fi

    else
        warn "LDAP container is not running - skipping user migration"
    fi
else
    log "No Authelia users file found in backup - skipping user migration"
fi

# ============================================================================
# SET PERMISSIONS
# ============================================================================

header "Setting Permissions"

# Set ownership for config directories
chown -R root:root "${HERMES_ROOT}/config/postfix-dkim/etc/postfix/" 2>/dev/null || true
chown -R root:root "${HERMES_ROOT}/config/mail_filter/etc/amavis/" 2>/dev/null || true
chmod 600 "${HERMES_ROOT}/config/hermes/opt/hermes/keys/"* 2>/dev/null || true
chmod 600 "${HERMES_ROOT}/config/hermes/opt/hermes/creds/"* 2>/dev/null || true

log "Permissions set"

# ============================================================================
# STORE MYSQL ROOT PASSWORD
# ============================================================================

header "Storing MySQL Root Password"

# Store the MySQL root password in credentials directory
echo -n "${MYSQL_ROOT_PASS}" > "${CREDS_DIR}/mysql_root_password"
chmod 600 "${CREDS_DIR}/mysql_root_password"
log "MySQL root password stored in ${CREDS_DIR}/mysql_root_password"

# ============================================================================
# SUMMARY
# ============================================================================

header "Migration Complete"

echo ""
echo -e "${GREEN}Migration completed successfully!${NC}"
echo ""
echo "Summary:"
echo "  - Databases restored: hermes, djigzo, opendmarc, Syslog"
echo "  - New databases created: authelia, nextcloud"
echo "  - Configuration files copied to Docker paths"
echo ""
echo "Next steps:"
echo "  1. Review the configuration files in ${HERMES_ROOT}/config/"
echo "  2. Migrate Authelia users to LDAP (see notes above)"
echo "  3. Restart all Docker containers:"
echo "     cd ${HERMES_ROOT} && docker compose down && docker compose up -d"
echo "  4. Check logs for any errors:"
echo "     docker compose logs -f"
echo ""
echo -e "${YELLOW}2FA Device Notes:${NC}"
echo "  - Duo Push users: No action needed (enrollment stored on Duo servers)"
echo "  - TOTP users: Must re-register authenticator app on next login"
echo "  - WebAuthn users: Must re-register hardware keys on next login"
echo ""
echo "Log file: ${LOG_FILE}"
echo ""

# ============================================================================
# OPTIONAL: MIGRATE ARCHIVE BACKUP
# ============================================================================

echo ""
read -p "Do you have an archive backup (hermes-archive-*.tar.gz) to restore? (y/N): " RESTORE_ARCHIVE

if [[ "$RESTORE_ARCHIVE" =~ ^[Yy]$ ]]; then
    read -p "Enter path to archive backup: " ARCHIVE_FILE

    if [[ -f "$ARCHIVE_FILE" ]]; then
        header "Restoring Archive Backup"

        # Post-#260 the Amavis quarantine archive lives on its own tier
        # (ARCHIVE_MOUNT, default /mnt/archive), not under DATA_MOUNT.
        # Legacy backups still contain the literal path /mnt/data/amavis,
        # so extract to / and then move into the new ARCHIVE_MOUNT location.
        log "Extracting archive to ${ARCHIVE_MOUNT}/amavis..."
        mkdir -p "${ARCHIVE_MOUNT}/amavis"

        # Extract the archive - it contains /mnt/data/amavis
        tar -xzf "$ARCHIVE_FILE" -C "/" >> "$LOG_FILE" 2>&1

        # Move legacy-pathed extracted content into the new ARCHIVE_MOUNT.
        if [[ -d "/mnt/data/amavis" ]] && [[ "${ARCHIVE_MOUNT}/amavis" != "/mnt/data/amavis" ]]; then
            mv /mnt/data/amavis/* "${ARCHIVE_MOUNT}/amavis/" 2>/dev/null || true
            rm -rf /mnt/data/amavis
        fi

        log "Archive restored to ${ARCHIVE_MOUNT}/amavis"
    else
        warn "Archive file not found: ${ARCHIVE_FILE}"
    fi
fi

echo ""
log "Migration script completed"
