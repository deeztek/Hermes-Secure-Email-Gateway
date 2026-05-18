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
# HERMES_ROOT is self-locating: derived from where this script lives, so the
# install works regardless of where the repo was cloned. Script lives at
# <HERMES_ROOT>/scripts/install_hermes_docker.sh, so two dirname's gets us
# the repo root. This also matches the future intent of #217 (self-locating
# install + update scripts so the admin isn't pinned to /opt/hermes-seg).
HERMES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/keys"
CREDS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/creds"
CONFIG_FILE="${HERMES_ROOT}/.hermes_install_config"
LOG_FILE="/var/log/hermes_install_$(date +%Y%m%d_%H%M%S).log"

# State directory — per-step completion markers + persisted user inputs.
# Lets the installer resume after a failure/cancel without re-asking for
# inputs and without re-running idempotent-but-time-consuming steps.
# Files inside:
#   <step>.done   = marker that <step> completed successfully
#   <step>.value  = persisted scalar value the step produced (e.g. the host IP)
STATE_DIR="${HERMES_ROOT}/.install-state"

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
    # Service-account password — 32 alphanumeric chars (~190 bits entropy).
    # Used for DB user passwords, LDAP admin/service, etc. — credentials
    # that are stored in config files and never typed by humans.
    #
    # No special characters by design: openssl rand -base64 never emits
    # !@#$%^&* anyway (only [A-Za-z0-9+/=]), and shell/SQL/CFML quoting
    # nightmares from specials > the marginal 7 bits of added entropy.
    # Per NIST SP 800-63B (5.1.1.2), length matters far more than
    # composition complexity for credentials of this length.
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32
}

generate_typeable_password() {
    # Human-typeable password — 16 alphanumeric chars (~95 bits entropy).
    # Used for the few credentials that an admin actually types into a
    # browser at least once: Nextcloud admin, Hermes bootstrap admin.
    # 95 bits is well above the NIST 64-bit floor for memorized secrets,
    # but 16 chars is short enough to read aloud or type accurately on
    # a phone. Replaced via UI/MFA shortly after first login anyway.
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 16
}

generate_alphanumeric() {
    # Generate alphanumeric only (for usernames, database names)
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c "$1"
}

generate_random_username() {
    # Compose a memorable-but-unique username as <word><4-digit-number>, e.g.
    #   apologise4567, paddle2814, wrench9012
    # (Same shape Bitwarden uses for its word+number identity generator.)
    #
    # The wordlist is pulled live from config/database/hermes_install.sql
    # (the source for the `random_words` DB table seed). This works in
    # phase 1 BEFORE the database has been created, since the file ships
    # in the repo. The digit suffix uses bash $RANDOM scaled to 1000-9999
    # for consistent width and ~1.8M combos with the 200-word seed list.
    #
    # If the wordlist read fails (e.g. script run from outside the repo),
    # falls back to a small inline word array so the install never wedges.
    local install_sql="${HERMES_ROOT}/config/database/hermes_install.sql"
    local word=""
    if [[ -f "$install_sql" ]] && command -v shuf >/dev/null 2>&1; then
        word=$(grep "INSERT IGNORE INTO \`random_words\`" "$install_sql" \
               | grep -oE "'[a-z]+'" \
               | tr -d "'" \
               | shuf -n 1)
    fi
    if [[ -z "$word" ]]; then
        local fallback=(falcon turbine glacier orbit summit ember rapid stellar nebula vector quartz beacon meadow tide forge)
        word="${fallback[$((RANDOM % ${#fallback[@]}))]}"
    fi
    echo "${word}$(( RANDOM % 9000 + 1000 ))"
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

derive_install_version() {
    # Returns the version string corresponding to this checkout, e.g. "v260119".
    # Sourced from the `updates/hermes-NNNNNN/` directory name so the value
    # auto-updates per release (no manual editing of the script at release
    # cut). Used by:
    #   - the banner displayed at the top of main()
    #   - the HERMES_DOCKER_IMG_VERSION substitution in .env, so the install
    #     pulls images that match the cloned source tree instead of :latest
    ls -1 "${HERMES_ROOT}/updates/" 2>/dev/null \
        | grep -oE 'hermes-[0-9]+' \
        | sort \
        | tail -1 \
        | sed 's/hermes-/v/'
}

validate_mount_point() {
    # Per #179: the admin is expected to pre-provision the mount point before
    # running the installer. This function VALIDATES — it does not create
    # directories. A missing path is a fatal error, not a recoverable warning,
    # because silent mkdir hides storage misconfiguration (e.g., admin forgot
    # to mount the volume; data ends up on the root filesystem).
    local path="$1"
    local name="$2"

    if [[ ! "$path" = /* ]]; then
        warn "${name} path must be absolute (start with /): ${path}"
        return 1
    fi

    if [[ ! -e "$path" ]]; then
        warn "${name} path does not exist: ${path}"
        warn "  Create and mount the volume first, then re-run the installer."
        return 1
    fi

    if [[ ! -d "$path" ]]; then
        warn "${name} path is not a directory: ${path}"
        return 1
    fi

    if [[ ! -w "$path" ]]; then
        warn "${name} directory is not writable by current user: ${path}"
        return 1
    fi

    # Soft warning if the directory has unexpected content (allow override).
    local entry_count
    entry_count=$(find "$path" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)
    if [[ "$entry_count" -gt 0 ]]; then
        warn "${name} directory is not empty: ${path} (${entry_count} entries)"
        warn "  Existing data will not be touched, but verify this is the right mount."
    fi

    return 0
}

validate_ipv4() {
    # Strict IPv4 dotted-quad validation. Returns 0 on valid, 1 otherwise.
    # IPv6 not supported in beta — bash regex is impractical and Hermes admins
    # essentially never install on IPv6-only hosts. Revisit if it becomes a need.
    local ip="$1"

    # Must be 4 numeric octets separated by dots.
    if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        return 1
    fi

    # Each octet must be 0-255. Reject leading-zero forms (e.g. "010") because
    # some libc resolvers interpret those as octal.
    local IFS='.'
    local -a octets
    read -ra octets <<< "$ip"
    for octet in "${octets[@]}"; do
        if [[ "$octet" =~ ^0[0-9]+ ]]; then
            return 1
        fi
        if (( octet < 0 || octet > 255 )); then
            return 1
        fi
    done

    # Reject pathological reserved/unusable addresses for a server install.
    case "$ip" in
        0.0.0.0|127.0.0.1|255.255.255.255)
            return 1 ;;
    esac

    return 0
}

prompt_host_ip() {
    # Required prompt — no default. Loops until a valid IPv4 is entered AND
    # explicitly confirmed. Stored value drives parameters2.server_ip,
    # Authelia config, and the post-install console URL.
    #
    # The wrong IP here is the single most catastrophic install-time mistake
    # (Authelia OIDC redirects fail, nginx vhost binds to the wrong addr,
    # admin can't even log in to fix it). The double-prompt + strong warning
    # is intentional friction.
    echo ""
    cat <<'EOF'
+------------------------------------------------------------------+
|  CRITICAL  — this IP determines how Authelia, nginx, and         |
|  authentication will be configured. If you enter the wrong one,  |
|  the system will be UNREACHABLE and you'll need to re-run this   |
|  installer with the WIPE option to recover.                      |
|                                                                  |
|  If unsure, check 'ip -4 addr show' in another terminal first.   |
+------------------------------------------------------------------+

EOF
    local ip confirm
    while true; do
        read -p "Host IP that will be used to access this server: " ip
        if ! validate_ipv4 "$ip"; then
            warn "Not a valid usable IPv4 address. Try again (e.g. 192.168.1.50)."
            continue
        fi
        read -p "Confirm ${ip} is correct? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            HERMES_HOST_IP="$ip"
            export HERMES_HOST_IP
            log "Host IP confirmed: ${HERMES_HOST_IP}"
            return 0
        fi
        echo "Not confirmed. Try again."
    done
}

# ============================================================================
# STATE TRACKING — per-step completion markers + persisted user inputs
# ============================================================================

state_init() {
    mkdir -p "$STATE_DIR" 2>/dev/null || true
}

state_mark_done() {
    # Record that <step> completed successfully.
    local step="$1"
    state_init
    touch "${STATE_DIR}/${step}.done"
}

state_is_done() {
    # Return 0 if <step> has its .done marker, non-zero otherwise.
    local step="$1"
    [[ -f "${STATE_DIR}/${step}.done" ]]
}

state_set_value() {
    # Persist a scalar value associated with <step> (e.g. an IP address).
    local step="$1"
    local value="$2"
    state_init
    printf '%s' "$value" > "${STATE_DIR}/${step}.value"
}

state_get_value() {
    # Read back a persisted scalar; empty string if not set.
    local step="$1"
    [[ -f "${STATE_DIR}/${step}.value" ]] && cat "${STATE_DIR}/${step}.value"
}

state_last_completed() {
    # Return the lexically-highest completed step name (without `.done`).
    # Step names are deliberately numbered (01-xxx, 02-yyy, ...) so lex sort
    # matches execution order.
    ls -1 "${STATE_DIR}"/*.done 2>/dev/null \
        | sed 's|.*/||;s/\.done$//' \
        | sort \
        | tail -1
}

wipe_install() {
    # Destructive: tears down everything the installer touched so a fresh
    # run starts from a clean slate. Stops + removes containers and volumes,
    # deletes credentials, deletes state markers, deletes generated config.
    # Leaves user-mounted storage paths (DATA_MOUNT etc.) ALONE — admin
    # provisioned those, admin removes them if they want a deeper reset.
    header "Wiping previous install"

    if [[ -f "${HERMES_ROOT}/docker-compose.yml" ]]; then
        log "Stopping + removing containers and volumes..."
        ( cd "$HERMES_ROOT" && docker compose down -v 2>>"$LOG_FILE" ) || true
    fi

    log "Removing install state markers..."
    rm -rf "$STATE_DIR" 2>/dev/null || true

    log "Removing credentials..."
    rm -rf "$CREDS_DIR" "$SECRETS_DIR" 2>/dev/null || true

    log "Removing generated config files..."
    rm -f "${HERMES_ROOT}/.env" \
          "${HERMES_ROOT}/docker-compose.override.yml" \
          "${CONFIG_FILE}" 2>/dev/null || true

    log "Wipe complete."
    echo ""
}

detect_previous_install() {
    # Called at the top of main() before any prompts. If state markers exist
    # from a prior (incomplete or completed) run, ask the admin what to do.
    if [[ ! -d "$STATE_DIR" ]] || [[ -z "$(ls -A "$STATE_DIR" 2>/dev/null)" ]]; then
        return 0
    fi

    local last_step
    last_step=$(state_last_completed)

    echo ""
    echo "+------------------------------------------------------------------+"
    echo "|  Previous install state detected at ${STATE_DIR}"
    [[ -n "$last_step" ]] && echo "|  Last completed step: ${last_step}"
    echo "+------------------------------------------------------------------+"
    echo ""
    echo "Options:"
    echo "  [1] Continue   — resume install (idempotent steps are safe to re-run)"
    echo "  [2] WIPE       — tear down EVERYTHING (containers, volumes, creds,"
    echo "                   state) and start completely fresh"
    echo "  [3] Cancel"
    echo ""
    local choice
    read -p "Choice [1]: " choice
    choice="${choice:-1}"

    case "$choice" in
        1)
            log "Resuming previous install."
            ;;
        2)
            echo ""
            echo "WARNING: this will permanently delete:"
            echo "  - Docker containers + named volumes (mail, db, ldap, etc.)"
            echo "  - All credentials in ${CREDS_DIR} and ${SECRETS_DIR}"
            echo "  - Install state markers in ${STATE_DIR}"
            echo "  - .env, docker-compose.override.yml, .hermes_install_config"
            echo ""
            echo "User-mounted storage directories will NOT be touched. If you"
            echo "want to wipe those too, you must rm -rf them manually before"
            echo "re-running."
            echo ""
            local confirm
            read -p "Type the word WIPE to confirm: " confirm
            if [[ "$confirm" == "WIPE" ]]; then
                wipe_install
            else
                echo "Wipe not confirmed. Exiting."
                exit 1
            fi
            ;;
        3)
            echo "Cancelled."
            exit 0
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
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
    echo "  3. NEXTCLOUD STORAGE (required)"
    echo "     - User file storage"
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
    echo "Mount points must ALREADY EXIST on the host (pre-provisioned by you)."
    echo "Subdirectories under each mount will be created by the installer."
    echo ""

    # Data mount point (required)
    while true; do
        DATA_MOUNT=$(prompt_with_default "System data path (databases, logs, quarantine)" "$DEFAULT_DATA_MOUNT")
        if validate_mount_point "$DATA_MOUNT" "System data"; then
            break
        fi
        echo "Please enter a path that already exists, is a directory, and is writable."
    done
    log "System data path: ${DATA_MOUNT}"

    # Vmail mount point (required)
    while true; do
        VMAIL_MOUNT=$(prompt_with_default "Email storage path (mailbox user mail)" "$DEFAULT_VMAIL_MOUNT")
        if validate_mount_point "$VMAIL_MOUNT" "Email storage"; then
            break
        fi
        echo "Please enter a path that already exists, is a directory, and is writable."
    done
    log "Email storage path: ${VMAIL_MOUNT}"

    # Nextcloud storage mount point (required — Nextcloud is part of every install)
    echo ""
    ENABLE_NEXTCLOUD="true"
    while true; do
        FILES_MOUNT=$(prompt_with_default "Nextcloud storage path" "$DEFAULT_FILES_MOUNT")
        if validate_mount_point "$FILES_MOUNT" "Nextcloud storage"; then
            break
        fi
        echo "Please enter a path that already exists, is a directory, and is writable."
    done
    log "Nextcloud storage path: ${FILES_MOUNT}"

    # Create subdirectories
    log "Creating storage subdirectories..."

    # Data subdirectories (one per `device:` line in docker-compose.yml's
    # `volumes:` section). Docker will NOT auto-create bind-mount source
    # paths -- a missing directory means the dependent container fails to
    # start with an obscure "bind source path does not exist" error. Keep
    # this list in lock-step with docker-compose.yml.
    mkdir -p "${DATA_MOUNT}/dbase"                      # db_data
    mkdir -p "${DATA_MOUNT}/amavis"                     # amavis_data
    mkdir -p "${DATA_MOUNT}/authelia/redis"             # authelia_redis
    mkdir -p "${DATA_MOUNT}/authelia/logs"              # authelia_logs
    mkdir -p "${DATA_MOUNT}/authelia/db"                # authelia_db
    mkdir -p "${DATA_MOUNT}/dovecot/logs"               # dovecot_logs
    mkdir -p "${DATA_MOUNT}/dovecot/sieve"              # dovecot_sieve
    mkdir -p "${DATA_MOUNT}/nginx/logs"                 # nginx_logs
    mkdir -p "${DATA_MOUNT}/commandbox/serverhome"      # commandbox_serverhome
    mkdir -p "${DATA_MOUNT}/ldap/data"                  # ldap_data
    mkdir -p "${DATA_MOUNT}/ldap/logs"                  # ldap_logs
    mkdir -p "${DATA_MOUNT}/postfix_dkim/logs"          # postfix_dkim_logs
    mkdir -p "${DATA_MOUNT}/postfix_dkim/queue"         # postfix_dkim_queue
    mkdir -p "${DATA_MOUNT}/openarc/logs"               # openarc_logs
    mkdir -p "${DATA_MOUNT}/dmarc/logs"                 # dmarc_logs
    mkdir -p "${DATA_MOUNT}/mail_filter/logs"           # mail_filter_logs
    mkdir -p "${DATA_MOUNT}/mail_filter/data/amavis"    # mail_filter_data_amavis
    mkdir -p "${DATA_MOUNT}/mail_filter/data/clamav"    # mail_filter_data_clamav
    mkdir -p "${DATA_MOUNT}/mail_filter/data/fangfrisch" # mail_filter_data_fangfrisch

    # Vmail subdirectory (email storage)
    mkdir -p "${VMAIL_MOUNT}/dovecot"                   # dovecot_mail

    # Nextcloud subdirectories
    # FILES_MOUNT is dedicated to Nextcloud storage, so no `nextcloud/` prefix
    # is needed — the mount point itself IS the Nextcloud root. Layout matches
    # the new docker-compose.yml device paths (${FILES_MOUNT}/app, /redis).
    mkdir -p "${FILES_MOUNT}/app"                       # nextcloud volume
    mkdir -p "${FILES_MOUNT}/redis"                     # nextcloud_redis volume

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
    # As of #179, volume mount remapping is env-var driven: docker-compose.yml
    # now uses ${DATA_MOUNT}/${VMAIL_MOUNT}/${FILES_MOUNT} in its volumes:
    # device: lines, and docker-compose substitutes them from .env at runtime.
    # This function writes those three variables to <repo>/.env (preserving
    # any unrelated variables already in the file). The legacy approach of
    # generating a docker-compose.override.yml with 22 volume redefinitions
    # has been retired and the function name kept only so the existing
    # --generate-override CLI flag still works.
    header "Writing Docker Compose .env"

    local ENV_FILE="${HERMES_ROOT}/.env"

    # Load config if not already set
    if [[ -z "${USE_DOCKER_VOLUMES:-}" ]]; then
        if ! load_config; then
            error "No configuration found. Run installation first."
        fi
    fi

    # Default-Docker-volumes mode is no longer supported with env-var
    # substitution (empty ${DATA_MOUNT} would resolve to '/dbase' which is
    # a real path on the host root filesystem -- dangerous). Custom mount
    # points are the only supported configuration.
    if [[ "${USE_DOCKER_VOLUMES}" == "true" ]]; then
        error "USE_DOCKER_VOLUMES=true is no longer supported. Re-run installer with custom mount points."
    fi

    if [[ -z "${DATA_MOUNT:-}" ]] || [[ -z "${VMAIL_MOUNT:-}" ]] || [[ -z "${FILES_MOUNT:-}" ]]; then
        error "All three mount points (DATA_MOUNT, VMAIL_MOUNT, FILES_MOUNT) must be set."
    fi

    log "Writing ${ENV_FILE}..."
    log "  DATA_MOUNT  = ${DATA_MOUNT}"
    log "  VMAIL_MOUNT = ${VMAIL_MOUNT}"
    log "  FILES_MOUNT = ${FILES_MOUNT}"

    # Bootstrap .env from .env.template if it doesn't exist. The template
    # holds defaults for everything docker-compose.yml references (IPV4SUBNET,
    # NCVERSION, AUTHELIAVERSION, LDAP_*, TIMEZONE, etc.). Without it, every
    # ${VAR} substitution resolves to empty -- which makes `docker compose
    # config` fail with errors like "extra_hosts: bad host name ''" because
    # the IP placeholder slots end up empty.
    local ENV_TEMPLATE="${HERMES_ROOT}/.env.template"
    if [[ ! -f "$ENV_FILE" ]]; then
        if [[ ! -f "$ENV_TEMPLATE" ]]; then
            error "Neither ${ENV_FILE} nor ${ENV_TEMPLATE} exist. Cannot proceed."
        fi
        log "Bootstrapping ${ENV_FILE} from .env.template..."
        cp "$ENV_TEMPLATE" "$ENV_FILE"
    fi

    # Substitute install-time placeholders with actual values. CONSOLE_HOST
    # and HERMES_HOSTNAME both get the IP initially -- admin can change
    # them to an FQDN later via the admin UI (System -> Console Settings).
    local ip="${HERMES_HOST_IP:-$(state_get_value "03-host-ip-confirmed")}"
    if [[ -n "$ip" ]]; then
        log "Substituting HOST_IP / CONSOLE_HOST / HERMES_HOSTNAME = ${ip}..."
        sed -i \
            -e "s|^HOST_IP=.*|HOST_IP=${ip}|" \
            -e "s|^CONSOLE_HOST=.*|CONSOLE_HOST=${ip}|" \
            -e "s|^HERMES_HOSTNAME=.*|HERMES_HOSTNAME=${ip}|" \
            -e "s|^NEXTCLOUD_TRUSTED_DOMAINS=.*|NEXTCLOUD_TRUSTED_DOMAINS=${ip}|" \
            "$ENV_FILE"
    fi

    # Substitute HERMES_DOCKER_IMG_VERSION so `docker compose pull` fetches
    # images matching this source tree's release (e.g. v260119) instead of
    # the .env.template default of "latest" -- which fails when no image has
    # been promoted to :latest in the registry yet.
    local img_version
    img_version=$(derive_install_version)
    if [[ -n "$img_version" ]]; then
        log "Substituting HERMES_DOCKER_IMG_VERSION = ${img_version}..."
        sed -i -e "s|^HERMES_DOCKER_IMG_VERSION=.*|HERMES_DOCKER_IMG_VERSION=${img_version}|" "$ENV_FILE"
    fi

    # Append the three mount-point vars (strip prior entries first so a
    # re-run is idempotent). Every other var in .env stays untouched.
    local tmp_env="${ENV_FILE}.tmp.$$"
    grep -vE '^(DATA_MOUNT|VMAIL_MOUNT|FILES_MOUNT)=' "$ENV_FILE" > "$tmp_env" || true
    {
        echo ""
        echo "# Storage mount points -- written by install_hermes_docker.sh on $(date)"
        echo "# These drive the device: paths in docker-compose.yml volumes."
        echo "DATA_MOUNT=${DATA_MOUNT}"
        echo "VMAIL_MOUNT=${VMAIL_MOUNT}"
        echo "FILES_MOUNT=${FILES_MOUNT}"
    } >> "$tmp_env"
    mv "$tmp_env" "$ENV_FILE"
    chmod 644 "$ENV_FILE"

    # Sweep any stale override file from the old approach. Docker Compose
    # auto-loads docker-compose.override.yml if present; leaving an old one
    # in place would mask the env-var-driven base compose.
    local old_override="${HERMES_ROOT}/docker-compose.override.yml"
    if [[ -f "$old_override" ]]; then
        log "Removing stale ${old_override} (volume remapping is now env-driven)..."
        rm -f "$old_override"
    fi

    # Validate the result
    log "Validating docker-compose configuration..."
    if command -v docker &> /dev/null; then
        if ( cd "$HERMES_ROOT" && docker compose config > /dev/null 2>&1 ); then
            log "  Docker Compose configuration is valid"
        else
            warn "  Docker Compose validation failed. Run: cd ${HERMES_ROOT} && docker compose config"
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
    # Generate every secret/credential the install pipeline needs. Each file
    # is gated by an existence check so re-runs are idempotent.
    #
    # Files are split between two directories:
    #   ${CREDS_DIR} = config/hermes/opt/hermes/creds/  (CFML/shell readable)
    #   ${SECRETS_DIR} = config/hermes/opt/hermes/keys/ (Docker-secret bind mounts)
    #
    # The exact filenames here MUST match what docker-compose.yml references
    # in its `secrets:` block at the top of the file -- a missing file or a
    # name mismatch causes `docker compose up` to bail out with
    # "bind source path does not exist".
    header "Generating Secrets"

    mkdir -p "$SECRETS_DIR" "$CREDS_DIR"
    chmod 700 "$SECRETS_DIR" "$CREDS_DIR"

    # ---- Local helpers ----
    # Write VALUE to TARGET only if TARGET doesn't exist. Always chmods 600.
    _ensure_secret() {
        local target="$1"
        local value="$2"
        if [[ ! -f "$target" ]]; then
            printf '%s' "$value" > "$target"
            chmod 600 "$target"
            log "  + $(basename "$target")"
        else
            log "  = $(basename "$target") (kept)"
        fi
    }

    # Source AUTHELIAVERSION from the .env that generate_compose_override
    # wrote moments earlier. Used to pull the Authelia image for the
    # argon2-hashed OIDC client secret further down.
    local AUTHELIA_VERSION
    AUTHELIA_VERSION=$(grep -E '^AUTHELIAVERSION=' "${HERMES_ROOT}/.env" 2>/dev/null         | cut -d= -f2 | tr -d '"' | tr -d "'")
    AUTHELIA_VERSION="${AUTHELIA_VERSION:-4.39.16}"

    # =========================================================================
    # CREDS_DIR  -- read by CFML, shell scripts, init flows
    # =========================================================================
    log "Generating creds/ files..."
    _ensure_secret "${CREDS_DIR}/mysql_root_password"      "$(generate_password)"
    _ensure_secret "${CREDS_DIR}/hermes_username"          "$(generate_random_username)"
    _ensure_secret "${CREDS_DIR}/hermes_password"          "$(generate_password)"
    _ensure_secret "${CREDS_DIR}/ciphermail_username"      "$(generate_random_username)"
    _ensure_secret "${CREDS_DIR}/ciphermail_password"      "$(generate_password)"
    _ensure_secret "${CREDS_DIR}/opendmarc_username"       "$(generate_random_username)"
    _ensure_secret "${CREDS_DIR}/opendmarc_password"       "$(generate_password)"
    _ensure_secret "${CREDS_DIR}/syslog_username"          "$(generate_random_username)"
    _ensure_secret "${CREDS_DIR}/syslog_password"          "$(generate_password)"

    # Nextcloud DB connection credentials (compose names these *_mysql_*)
    _ensure_secret "${CREDS_DIR}/nextcloud_mysql_username" "$(generate_random_username)"
    _ensure_secret "${CREDS_DIR}/nextcloud_mysql_password" "$(generate_password)"

    # Nextcloud admin account (human-typed for first login)
    _ensure_secret "${CREDS_DIR}/nextcloud_admin_username" "$(generate_random_username)"
    _ensure_secret "${CREDS_DIR}/nextcloud_admin_password" "$(generate_typeable_password)"

    # Nextcloud Redis (crypto secret)
    _ensure_secret "${CREDS_DIR}/nextcloud_redis_password" "$(generate_hex 32)"

    # CommandBox admin password (Docker secret)
    _ensure_secret "${CREDS_DIR}/cfadmin_password"         "$(generate_password)"

    # =========================================================================
    # SECRETS_DIR  -- bind-mounted as Docker secrets per docker-compose.yml
    # =========================================================================
    log "Generating keys/ files..."

    # Authelia DB credentials (compose binds the password but the username
    # lives alongside it for symmetry with the other DBs)
    _ensure_secret "${SECRETS_DIR}/authelia_username" "$(generate_random_username)"
    _ensure_secret "${SECRETS_DIR}/authelia_password" "$(generate_password)"

    # Authelia core crypto secrets (64 hex chars = 256 bits each)
    _ensure_secret "${SECRETS_DIR}/authelia_session_secret_file"                                   "$(generate_hex 32)"
    _ensure_secret "${SECRETS_DIR}/authelia_session_redis_password_file"                           "$(generate_hex 32)"
    _ensure_secret "${SECRETS_DIR}/authelia_storage_encryption_key_file"                          "$(generate_hex 32)"
    _ensure_secret "${SECRETS_DIR}/authelia_identity_validation_reset_password_jwt_secret_file"   "$(generate_hex 32)"
    _ensure_secret "${SECRETS_DIR}/authelia_identity_providers_oidc_hmac_secret_file"             "$(generate_hex 32)"

    # Authelia Duo MFA -- empty until admin enables Duo via the admin UI.
    # The files MUST exist (compose bind mount), but the value can be empty.
    _ensure_secret "${SECRETS_DIR}/authelia_duo_api_integration_key_file" ""
    _ensure_secret "${SECRETS_DIR}/authelia_duo_api_secret_key_file"      ""

    # LDAP passwords are dual-purpose:
    #   creds/<name>           -- read by initialize_ldap, CFML, helper scripts
    #   keys/<name>_file       -- read by Bitnami OpenLDAP container as Docker secret
    # Both files MUST hold the same value. Generate once, write to both.
    if [[ -f "${CREDS_DIR}/ldap_admin_password" ]]; then
        LDAP_ADMIN_PASS=$(cat "${CREDS_DIR}/ldap_admin_password")
    elif [[ -f "${SECRETS_DIR}/ldap_admin_password_file" ]]; then
        LDAP_ADMIN_PASS=$(cat "${SECRETS_DIR}/ldap_admin_password_file")
    else
        LDAP_ADMIN_PASS=$(generate_password)
    fi
    printf '%s' "$LDAP_ADMIN_PASS" > "${CREDS_DIR}/ldap_admin_password"
    printf '%s' "$LDAP_ADMIN_PASS" > "${SECRETS_DIR}/ldap_admin_password_file"
    chmod 600 "${CREDS_DIR}/ldap_admin_password" "${SECRETS_DIR}/ldap_admin_password_file"
    log "  + ldap_admin_password (creds/ + keys/ldap_admin_password_file)"

    if [[ -f "${CREDS_DIR}/ldap_service_password" ]]; then
        LDAP_USER_PASS=$(cat "${CREDS_DIR}/ldap_service_password")
    elif [[ -f "${SECRETS_DIR}/ldap_user_password_file" ]]; then
        LDAP_USER_PASS=$(cat "${SECRETS_DIR}/ldap_user_password_file")
    else
        LDAP_USER_PASS=$(generate_password)
    fi
    printf '%s' "$LDAP_USER_PASS" > "${CREDS_DIR}/ldap_service_password"
    printf '%s' "$LDAP_USER_PASS" > "${SECRETS_DIR}/ldap_user_password_file"
    chmod 600 "${CREDS_DIR}/ldap_service_password" "${SECRETS_DIR}/ldap_user_password_file"
    log "  + ldap_service_password (creds/ + keys/ldap_user_password_file)"

    # Authelia OIDC JWKS -- RSA 2048 private key in PEM format. Authelia
    # reads this as the signing key for ID tokens and OIDC userinfo. The
    # public half is exposed via /.well-known/jwks.json so clients can
    # verify signatures.
    if [[ ! -f "${SECRETS_DIR}/authelia_identity_providers_oidc_jwks_file" ]]; then
        log "  + authelia_identity_providers_oidc_jwks_file (generating RSA 2048 private key)"
        openssl genrsa -out "${SECRETS_DIR}/authelia_identity_providers_oidc_jwks_file" 2048 2>>"$LOG_FILE"
        chmod 600 "${SECRETS_DIR}/authelia_identity_providers_oidc_jwks_file"
    else
        log "  = authelia_identity_providers_oidc_jwks_file (kept)"
    fi

    # Authelia OIDC client secret PAIR (plain + argon2 digest)
    # Authelia stores OIDC client secrets as an argon2id hash; the matching
    # plain value is shared with Nextcloud's user_oidc app config so both
    # sides agree on what to validate against. The plain and digest MUST
    # derive from the same source secret. Hashing is delegated to the
    # Authelia container's own CLI to guarantee the digest format matches
    # what Authelia expects ($argon2id$v=19$m=...$p=...$<salt>$<hash>).
    local OIDC_PLAIN_FILE="${SECRETS_DIR}/authelia_identity_providers_oidc_clients_client_secret_plain_file"
    local OIDC_DIGEST_FILE="${SECRETS_DIR}/authelia_identity_providers_oidc_clients_client_secret_digest_file"
    local NC_OIDC_FILE="${CREDS_DIR}/nextcloud_oidc_secret"

    if [[ ! -f "$OIDC_PLAIN_FILE" ]] || [[ ! -f "$OIDC_DIGEST_FILE" ]]; then
        log "Generating Authelia OIDC client secret pair (plain + argon2 digest)"
        log "  Pulling authelia/authelia:${AUTHELIA_VERSION} for argon2 CLI..."
        if ! docker pull "authelia/authelia:${AUTHELIA_VERSION}" >> "$LOG_FILE" 2>&1; then
            error "Failed to pull authelia/authelia:${AUTHELIA_VERSION} (needed for OIDC client secret hashing)"
        fi

        local OIDC_PLAIN OIDC_DIGEST
        OIDC_PLAIN=$(generate_password)
        OIDC_DIGEST=$(docker run --rm "authelia/authelia:${AUTHELIA_VERSION}"             authelia crypto hash generate argon2 --password "$OIDC_PLAIN" 2>&1             | grep -oE '\$argon2id\$[^[:space:]]+'             | head -1)
        if [[ -z "$OIDC_DIGEST" ]]; then
            error "Failed to generate argon2 digest from authelia CLI (no \$argon2id\$... in output)"
        fi

        printf '%s' "$OIDC_PLAIN"  > "$OIDC_PLAIN_FILE"
        printf '%s' "$OIDC_DIGEST" > "$OIDC_DIGEST_FILE"
        printf '%s' "$OIDC_PLAIN"  > "$NC_OIDC_FILE"   # Nextcloud user_oidc uses the same plain secret
        chmod 600 "$OIDC_PLAIN_FILE" "$OIDC_DIGEST_FILE" "$NC_OIDC_FILE"
        log "  + authelia_identity_providers_oidc_clients_client_secret_plain_file"
        log "  + authelia_identity_providers_oidc_clients_client_secret_digest_file"
        log "  + nextcloud_oidc_secret (matches Authelia plain)"
    else
        log "  = OIDC client secret pair (kept)"
        # Keep Nextcloud's copy in sync if it drifted
        if [[ ! -f "$NC_OIDC_FILE" ]]; then
            cp "$OIDC_PLAIN_FILE" "$NC_OIDC_FILE"
            chmod 600 "$NC_OIDC_FILE"
            log "  + nextcloud_oidc_secret (copied from Authelia plain)"
        fi
    fi

    log "Secrets generation completed"
}

# ============================================================================
# RENDER RSYSLOG MYSQL CONFIGS
# ============================================================================

generate_rsyslog_configs() {
    # Renders the per-container rsyslog->MySQL configs from committed
    # `mysql.conf.template` files, substituting the generated Syslog DB
    # user + password into each.
    #
    # The rendered files are gitignored (they contain DB credentials) and
    # bind-mounted as FILE bind mounts by docker-compose.yml in 4 containers:
    #
    #   ./config/postfix-dkim/etc/rsyslog.d/mysql.conf   (hermes_postfix_dkim)
    #   ./config/opendmarc/etc/rsyslog.d/mysql.conf      (hermes_opendmarc)
    #   ./config/mail_filter/etc/rsyslog.d/mysql.conf    (hermes_mail_filter)
    #   ./config/ldap/etc/rsyslog.d/mysql.conf           (hermes_ldap)
    #
    # If any of these source files are missing at `docker compose up` time,
    # Docker silently creates an empty directory at the source path and
    # then the bind mount fails with "not a directory" because the dest
    # inside the container is a file. So this MUST run before containers
    # start. Linked: #179
    #
    # Not state-guarded -- the function is fast, idempotent, and re-running
    # it on a `git pull` lets template-logic changes land cleanly. Same
    # rationale as generate_compose_override.
    header "Rendering rsyslog Configs"

    local syslog_user syslog_pass
    syslog_user=$(cat "${CREDS_DIR}/syslog_username")
    syslog_pass=$(cat "${CREDS_DIR}/syslog_password")

    if [[ -z "$syslog_user" || -z "$syslog_pass" ]]; then
        error "Syslog credentials missing in ${CREDS_DIR}/ -- run generate_secrets first"
    fi

    # Generators emit alphanumeric only ([A-Za-z0-9] for passwords, [a-z0-9]
    # for usernames), so sed substitution is safe without escaping.
    _render_rsyslog_conf() {
        local template="$1"
        local target="$2"
        if [[ ! -f "$template" ]]; then
            error "rsyslog template missing: $template"
            return 1
        fi
        # Recover from the "Docker auto-created empty dir at file bind-mount
        # source" failure mode: if a prior `docker compose up` ran with this
        # file missing, Docker silently created a directory at $target, and
        # `sed > "$target"` would then fail with "Is a directory". Strip
        # anything sitting at the target path before writing.
        [[ -e "$target" ]] && rm -rf "$target"
        sed -e "s|__SYSLOG_USER__|${syslog_user}|g" \
            -e "s|__SYSLOG_PASS__|${syslog_pass}|g" \
            "$template" > "$target"
        chmod 644 "$target"
        log "  + $(echo "$target" | sed "s|^${HERMES_ROOT}/||")"
    }

    _render_rsyslog_conf \
        "${HERMES_ROOT}/config/postfix-dkim/etc/rsyslog.d/mysql.conf.template" \
        "${HERMES_ROOT}/config/postfix-dkim/etc/rsyslog.d/mysql.conf"
    _render_rsyslog_conf \
        "${HERMES_ROOT}/config/opendmarc/etc/rsyslog.d/mysql.conf.template" \
        "${HERMES_ROOT}/config/opendmarc/etc/rsyslog.d/mysql.conf"
    _render_rsyslog_conf \
        "${HERMES_ROOT}/config/mail_filter/etc/rsyslog.d/mysql.conf.template" \
        "${HERMES_ROOT}/config/mail_filter/etc/rsyslog.d/mysql.conf"
    _render_rsyslog_conf \
        "${HERMES_ROOT}/config/ldap/etc/rsyslog.d/mysql.conf.template" \
        "${HERMES_ROOT}/config/ldap/etc/rsyslog.d/mysql.conf"

    log "rsyslog configs rendered"
}

# ============================================================================
# RENDER AMAVIS 50-USER CONFIG
# ============================================================================

generate_amavis_50user_config() {
    # Renders config/mail_filter/etc/amavis/conf.d/50-user from the committed
    # 50-user.HERMES template. Same file-bind-mount-missing failure mode as
    # the rsyslog configs (#179): docker-compose.yml bind-mounts this as a
    # FILE, but it's gitignored (contains DB creds post-substitution), so a
    # fresh clone has nothing at the source path and `docker compose up`
    # silently creates an empty dir there, then bails with "not a directory".
    #
    # The CFML page admin/2/inc/update_amavis_config_files.cfm re-renders
    # the file from DB values whenever an admin saves spam/network settings;
    # this install-time render just produces a valid amavis config that
    # boots cleanly with hermes_install.sql's seed-row defaults.
    #
    # Placeholders substituted (matched against committed 50-user.HERMES):
    #   SERVER-NAME / SERVER-DOMAIN  -- split from HERMES_HOSTNAME in .env
    #   HERMES-USERNAME / HERMES-PASSWORD  -- from generate_secrets() creds/
    #   sa-spam-subject-tag          -- `[SUSPECTED SPAM]` (spam_settings seed)
    #   final-virus-destiny          -- `D_BOUNCE`         (spam_settings seed)
    #   final-banned-destiny         -- `D_BOUNCE`         (spam_settings seed)
    #   final-spam-destiny           -- `D_DISCARD`        (spam_settings seed)
    #   final-bad-header-destiny     -- `D_DISCARD`        (spam_settings seed)
    #   FILE-RULES-GO-HERE           -- empty (no banned-file rules yet)
    #
    # Not state-guarded -- same rationale as generate_rsyslog_configs.
    # Linked: #179
    header "Rendering amavis 50-user Config"

    local template="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/50-user.HERMES"
    local target="${HERMES_ROOT}/config/mail_filter/etc/amavis/conf.d/50-user"

    if [[ ! -f "$template" ]]; then
        error "50-user template missing: $template"
    fi

    local hermes_user hermes_pass hermes_hostname
    hermes_user=$(cat "${CREDS_DIR}/hermes_username")
    hermes_pass=$(cat "${CREDS_DIR}/hermes_password")
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")

    if [[ -z "$hermes_user" || -z "$hermes_pass" ]]; then
        error "hermes DB credentials missing in ${CREDS_DIR}/ -- run generate_secrets first"
    fi
    if [[ -z "$hermes_hostname" ]]; then
        error "HERMES_HOSTNAME missing from .env -- run generate_compose_override first"
    fi

    # Split hostname into name + domain: smtp.example.com -> smtp / example.com
    local server_name server_domain
    server_name="${hermes_hostname%%.*}"
    server_domain="${hermes_hostname#*.}"

    # Recover from Docker's empty-dir-at-missing-source failure mode.
    [[ -e "$target" ]] && rm -rf "$target"

    # Credentials and hostname are alphanumeric+dots, safe for sed without escaping.
    # Placeholder defaults match hermes_install.sql spam_settings seed rows so
    # admin sees consistent values whether they save via UI or never log in.
    sed -e "s|SERVER-NAME|${server_name}|g" \
        -e "s|SERVER-DOMAIN|${server_domain}|g" \
        -e "s|HERMES-USERNAME|${hermes_user}|g" \
        -e "s|HERMES-PASSWORD|${hermes_pass}|g" \
        -e "s|sa-spam-subject-tag|[SUSPECTED SPAM]|g" \
        -e "s|final-virus-destiny|D_BOUNCE|g" \
        -e "s|final-banned-destiny|D_BOUNCE|g" \
        -e "s|final-spam-destiny|D_DISCARD|g" \
        -e "s|final-bad-header-destiny|D_DISCARD|g" \
        -e "s|FILE-RULES-GO-HERE||g" \
        "$template" > "$target"
    chmod 644 "$target"
    log "  + config/mail_filter/etc/amavis/conf.d/50-user"
    log "amavis 50-user config rendered (host=${server_name}.${server_domain})"
}

# ============================================================================
# RENDER CIPHERMAIL HIBERNATE CONFIGS
# ============================================================================

generate_ciphermail_hibernate_configs() {
    # Renders the two Hibernate XML configs CipherMail's Tomcat reads at
    # startup, from their committed .HERMES templates. Both are bind-mounted
    # as FILES by docker-compose.yml, both are gitignored (contain DB creds),
    # so on a fresh clone they trip the same "not a directory" failure as
    # the rsyslog and amavis configs.
    #
    # Each template has exactly two placeholders: DJIGZO-USERNAME and
    # DJIGZO-PASSWORD, mapped to the random ciphermail DB credentials
    # generate_secrets() writes to creds/ciphermail_{username,password}.
    # create_databases() later creates the matching djigzo DB user.
    #
    # Not state-guarded -- same rationale as the other render functions.
    # Linked: #179
    header "Rendering CipherMail Hibernate Configs"

    local cfg_template="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/hibernate.mysql.cfg.HERMES"
    local conn_template="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/hibernate.mysql.connection.HERMES"
    local target_dir="${HERMES_ROOT}/config/ciphermail/usr/share/djigzo/conf/database"
    local cfg_target="${target_dir}/hibernate.cfg.xml"
    local conn_target="${target_dir}/hibernate.mysql.connection.xml"

    if [[ ! -f "$cfg_template" ]]; then
        error "hibernate.mysql.cfg.HERMES template missing: $cfg_template"
    fi
    if [[ ! -f "$conn_template" ]]; then
        error "hibernate.mysql.connection.HERMES template missing: $conn_template"
    fi

    local ciphermail_user ciphermail_pass
    ciphermail_user=$(cat "${CREDS_DIR}/ciphermail_username")
    ciphermail_pass=$(cat "${CREDS_DIR}/ciphermail_password")

    if [[ -z "$ciphermail_user" || -z "$ciphermail_pass" ]]; then
        error "ciphermail DB credentials missing in ${CREDS_DIR}/ -- run generate_secrets first"
    fi

    # Target dir is not present on fresh clones (no tracked files inside).
    mkdir -p "$target_dir"

    _render_hibernate_conf() {
        local template="$1"
        local target="$2"
        [[ -e "$target" ]] && rm -rf "$target"
        sed -e "s|DJIGZO-USERNAME|${ciphermail_user}|g" \
            -e "s|DJIGZO-PASSWORD|${ciphermail_pass}|g" \
            "$template" > "$target"
        chmod 644 "$target"
        log "  + $(echo "$target" | sed "s|^${HERMES_ROOT}/||")"
    }

    _render_hibernate_conf "$cfg_template"  "$cfg_target"
    _render_hibernate_conf "$conn_template" "$conn_target"

    log "CipherMail Hibernate configs rendered"
}

# ============================================================================
# CREATE DATABASES
# ============================================================================

create_databases() {
    # ------------------------------------------------------------------
    # Creates the 6 databases Hermes needs + per-db users + grants, then
    # imports schemas/seeds for the three that ship them:
    #
    #   hermes     -- needs schema + sanitized seed data (config/database/hermes_install.sql)
    #   opendmarc  -- needs empty schema (config/database/opendmarc_schema.sql)
    #   Syslog     -- needs empty schema (config/database/syslog_schema.sql)
    #   authelia   -- Authelia auto-creates its tables on first startup
    #   djigzo     -- Ciphermail/Hibernate auto-creates its tables on first startup
    #   nextcloud  -- Nextcloud auto-creates its tables on first startup
    #
    # After schemas land, applies updates/hermes-260119/sql/schema_updates.sql
    # which is idempotent (CREATE TABLE IF NOT EXISTS / INSERT IGNORE / etc.)
    # so it's a near-no-op on fresh installs and a full delta on upgrades.
    # Linked: #179
    # ------------------------------------------------------------------
    header "Creating Databases"

    # ---- Read all credentials up front so we fail early if any are missing ----
    MYSQL_ROOT_PASS=$(cat "${CREDS_DIR}/mysql_root_password")
    HERMES_DB_USER=$(cat "${CREDS_DIR}/hermes_username")
    HERMES_DB_PASS=$(cat "${CREDS_DIR}/hermes_password")
    AUTHELIA_DB_USER=$(cat "${SECRETS_DIR}/authelia_username")
    AUTHELIA_DB_PASS=$(cat "${SECRETS_DIR}/authelia_password")
    OPENDMARC_DB_USER=$(cat "${CREDS_DIR}/opendmarc_username")
    OPENDMARC_DB_PASS=$(cat "${CREDS_DIR}/opendmarc_password")
    SYSLOG_DB_USER=$(cat "${CREDS_DIR}/syslog_username")
    SYSLOG_DB_PASS=$(cat "${CREDS_DIR}/syslog_password")
    CIPHERMAIL_DB_USER=$(cat "${CREDS_DIR}/ciphermail_username")
    CIPHERMAIL_DB_PASS=$(cat "${CREDS_DIR}/ciphermail_password")
    NEXTCLOUD_DB_USER=$(cat "${CREDS_DIR}/nextcloud_username")
    NEXTCLOUD_DB_PASS=$(cat "${CREDS_DIR}/nextcloud_password")

    # ---- Wait for MariaDB to be ready ----
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

    # ---- Create one DB + user + grants ----
    # NOTE: backtick-quoting `Syslog` is REQUIRED — case-sensitive on Linux
    # and rsyslog's mysql template writes to exactly that mixed-case name.
    _create_db_user() {
        local dbname="$1"
        local user="$2"
        local pass="$3"
        local collation="${4:-utf8mb4_unicode_ci}"

        log "Creating database '${dbname}' (user '${user}')..."
        docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "
            CREATE DATABASE IF NOT EXISTS \`${dbname}\` CHARACTER SET utf8mb4 COLLATE ${collation};
            CREATE USER IF NOT EXISTS '${user}'@'%' IDENTIFIED BY '${pass}';
            GRANT ALL PRIVILEGES ON \`${dbname}\`.* TO '${user}'@'%';
        " 2>> "$LOG_FILE"
    }

    _create_db_user hermes    "$HERMES_DB_USER"     "$HERMES_DB_PASS"
    _create_db_user authelia  "$AUTHELIA_DB_USER"   "$AUTHELIA_DB_PASS"   utf8mb4_unicode_520_ci
    _create_db_user opendmarc "$OPENDMARC_DB_USER"  "$OPENDMARC_DB_PASS"
    _create_db_user Syslog    "$SYSLOG_DB_USER"     "$SYSLOG_DB_PASS"
    _create_db_user djigzo    "$CIPHERMAIL_DB_USER" "$CIPHERMAIL_DB_PASS"
    _create_db_user nextcloud "$NEXTCLOUD_DB_USER"  "$NEXTCLOUD_DB_PASS"

    docker exec hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" -e "FLUSH PRIVILEGES;" 2>> "$LOG_FILE"
    log "All 6 databases + users + grants created"

    # ---- Import one SQL file into a target DB ----
    _import_sql() {
        local sql_file="$1"
        local target_db="$2"
        local label="$3"

        if [[ ! -f "$sql_file" ]]; then
            error "${label} file not found: ${sql_file}"
            return 1
        fi
        log "Importing ${label} into '${target_db}'..."
        if ! docker exec -i hermes_db_server mysql -u root -p"${MYSQL_ROOT_PASS}" "$target_db" \
                < "$sql_file" 2>> "$LOG_FILE"; then
            error "Failed to import ${label} (see $LOG_FILE for details)"
            return 1
        fi
        log "  ✓ ${label} imported"
    }

    # ---- Schema + sanitized seed for `hermes` ----
    _import_sql \
        "${HERMES_ROOT}/config/database/hermes_install.sql" \
        "hermes" \
        "hermes_install.sql (schema + seed)"

    # ---- Empty schemas for opendmarc + Syslog ----
    # Both are app/runtime-populated (opendmarc reports + rsyslog SystemEvents);
    # pre-creating the table structure ensures the apps don't race on first start.
    _import_sql \
        "${HERMES_ROOT}/config/database/opendmarc_schema.sql" \
        "opendmarc" \
        "opendmarc_schema.sql"

    _import_sql \
        "${HERMES_ROOT}/config/database/syslog_schema.sql" \
        "Syslog" \
        "syslog_schema.sql"

    # ---- Apply hermes schema_updates.sql (idempotent deltas + release stamp) ----
    # Path is parameterized off the version subdir so it picks up future
    # versions automatically — at release-cut time, the install script will be
    # editing a new copy under updates/hermes-260120/ etc.
    local schema_updates="${HERMES_ROOT}/updates/hermes-260119/sql/schema_updates.sql"
    _import_sql "$schema_updates" "hermes" "schema_updates.sql"

    log "Database initialization completed"
}

# ============================================================================
# SEED INSTALL-SPECIFIC VALUES
# ============================================================================

seed_install_specific_values() {
    # Writes install-time-known values into the seeded DB so the admin UI
    # shows correct defaults on first login. The IP came from the
    # 03-host-ip-confirmed step. Mirrors what the legacy installer did
    # for parameters2.console.host + parameters2.server_ip.
    header "Seeding install-specific values"

    local ip
    ip=$(state_get_value "03-host-ip-confirmed")
    if [[ -z "$ip" ]]; then
        ip="${HERMES_HOST_IP:-}"
    fi
    if [[ -z "$ip" ]]; then
        warn "Host IP not in state and HERMES_HOST_IP not set — skipping"
        return 0
    fi

    local pass
    pass=$(cat "${CREDS_DIR}/mysql_root_password")

    log "Writing parameters2.server_ip = ${ip}..."
    docker exec hermes_db_server mysql -u root -p"${pass}" hermes -e "
        UPDATE parameters2 SET value2='${ip}', active='1', applied='2'
         WHERE parameter='server_ip' AND module='console';
    " 2>>"$LOG_FILE"

    log "Writing parameters2.console.host = ${ip} (admin can change to FQDN via UI later)..."
    docker exec hermes_db_server mysql -u root -p"${pass}" hermes -e "
        UPDATE parameters2 SET value2='${ip}', active='1', applied='2'
         WHERE parameter='console.host' AND module='console';
    " 2>>"$LOG_FILE"

    log "Install-specific values seeded"
}

# ============================================================================
# WRITE INSTALL SUMMARY
# ============================================================================

write_install_summary() {
    # Writes a single-file credential + access summary to /opt/hermes/INSTALL_SUMMARY.txt
    # (chmod 600, root-only). Also prints a condensed version to the console.
    # This is the last user-facing output of a successful install — admins
    # MUST save the contents before logging out of their install session.
    local ip
    ip=$(state_get_value "03-host-ip-confirmed")
    [[ -z "$ip" ]] && ip="${HERMES_HOST_IP:-<not-set>}"

    local summary="${HERMES_ROOT}/INSTALL_SUMMARY.txt"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S %Z')

    # Build the summary as one document. Defensive: each `cat` lookup is
    # `2>/dev/null || echo "<not-generated>"` so a missing cred file doesn't
    # break the summary write.
    {
        cat <<EOF
================================================================================
                      HERMES SEG INSTALL SUMMARY
                  Generated: ${timestamp}
================================================================================

ACCESS
------
Console URL:        https://${ip}/   (snake-oil cert; browser will warn)
Admin login:        $(state_get_value "04-admin-username" 2>/dev/null || echo "admin")

MARIADB
-------
Root password:      $(cat "${CREDS_DIR}/mysql_root_password" 2>/dev/null || echo "<not-generated>")
hermes user/pw:     $(cat "${CREDS_DIR}/hermes_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/hermes_password" 2>/dev/null || echo "?")
opendmarc user/pw:  $(cat "${CREDS_DIR}/opendmarc_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/opendmarc_password" 2>/dev/null || echo "?")
syslog user/pw:     $(cat "${CREDS_DIR}/syslog_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/syslog_password" 2>/dev/null || echo "?")
ciphermail user/pw: $(cat "${CREDS_DIR}/ciphermail_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/ciphermail_password" 2>/dev/null || echo "?")
nextcloud user/pw:  $(cat "${CREDS_DIR}/nextcloud_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/nextcloud_password" 2>/dev/null || echo "?")

AUTHELIA
--------
DB user/pw:         $(cat "${SECRETS_DIR}/authelia_username" 2>/dev/null || echo "?") / $(cat "${SECRETS_DIR}/authelia_password" 2>/dev/null || echo "?")
JWT secret:         $(cat "${SECRETS_DIR}/authelia_jwt_secret" 2>/dev/null || echo "<not-generated>")
Session secret:     $(cat "${SECRETS_DIR}/authelia_session_secret" 2>/dev/null || echo "<not-generated>")
Storage enc key:    $(cat "${SECRETS_DIR}/authelia_storage_encryption_key_file" 2>/dev/null || echo "<not-generated>")

LDAP
----
Admin password:     $(cat "${CREDS_DIR}/ldap_admin_password" 2>/dev/null || echo "<not-generated>")
Service password:   $(cat "${CREDS_DIR}/ldap_service_password" 2>/dev/null || echo "<not-generated>")

NEXTCLOUD
---------
Admin user/pw:      $(cat "${CREDS_DIR}/nextcloud_admin_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/nextcloud_admin_password" 2>/dev/null || echo "?")
OIDC secret:        $(cat "${CREDS_DIR}/nextcloud_oidc_secret" 2>/dev/null || echo "<not-generated>")
Redis password:     $(cat "${CREDS_DIR}/nextcloud_redis_password" 2>/dev/null || echo "<not-generated>")

NEXT STEPS (in admin UI)
------------------------
1. Log in at https://${ip}/   (snake-oil cert — accept the browser warning)
2. System  -> Console Settings: change console host from IP to FQDN if needed
3. System  -> SSL Certificates: install your real cert (Let's Encrypt or imported)
4. Email Server -> Domains: add your first domain
5. DNS records to set up at your registrar: A/AAAA, MX, SPF, DKIM, DMARC

RECOVERY
--------
If https://${ip}/ does NOT load, the most likely cause is that the host IP
you entered was wrong. Re-run the installer and pick option [2] (WIPE) to
start over with a fresh IP.

    cd ${HERMES_ROOT}
    ./scripts/install_hermes_docker.sh    # pick option [2] when prompted

LOG FILES
---------
Install log:        ${LOG_FILE}
State markers:      ${STATE_DIR}/

================================================================================
EOF
    } > "$summary"

    chmod 600 "$summary" 2>/dev/null || true

    # Console summary — condensed
    echo ""
    echo "================================================================================"
    echo "                INSTALL COMPLETE   -   SAVE THESE NOW"
    echo "================================================================================"
    echo "Console URL:      https://${ip}/   (snake-oil; expect browser warning)"
    echo "Admin login:      $(state_get_value "04-admin-username" 2>/dev/null || echo "admin")"
    echo "Admin password:   (in INSTALL_SUMMARY.txt below)"
    echo ""
    echo "Full credential summary written to:"
    echo "  ${summary}   (chmod 600, root only)"
    echo ""
    echo "If https://${ip}/ does NOT load, the IP was wrong. Re-run this installer"
    echo "and select [2] WIPE to start over."
    echo "================================================================================"
    echo ""
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
    # Banner version self-derives from `updates/hermes-NNNNNN/` — see
    # derive_install_version() for details.
    local install_version
    install_version=$(derive_install_version)
    install_version="${install_version:-unknown}"

    echo "         Secure Email Gateway - Docker Installation"
    echo "                      Version ${install_version}"
    echo ""
    echo "============================================================"
    echo ""

    # Detect any previous install BEFORE asking the admin to confirm — they
    # need a chance to wipe + restart rather than blindly continuing.
    detect_previous_install

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

    # ---- Phase 1 steps. Each is wrapped with a state guard so a re-run
    # skips work that already completed successfully. The underlying actions
    # are also internally idempotent (file existence checks, IF NOT EXISTS
    # on DB ops, etc.) — the state guards are belt-and-suspenders.
    if state_is_done "01-preflight"; then
        log "Skip: preflight checks already passed"
    else
        preflight_checks
        state_mark_done "01-preflight"
    fi

    if state_is_done "02-mounts-configured"; then
        log "Skip: storage mount points already configured"
        load_config
    else
        configure_mount_points
        state_mark_done "02-mounts-configured"
    fi

    if state_is_done "03-host-ip-confirmed"; then
        HERMES_HOST_IP=$(state_get_value "03-host-ip-confirmed")
        export HERMES_HOST_IP
        log "Skip: host IP already confirmed (${HERMES_HOST_IP})"
    else
        prompt_host_ip
        state_set_value "03-host-ip-confirmed" "$HERMES_HOST_IP"
        state_mark_done "03-host-ip-confirmed"
    fi

    # generate_compose_override is intentionally NOT state-guarded. It's
    # idempotent (every sed is a no-op when the value is already correct)
    # and re-runs in seconds. Skipping it on re-runs was an actual bug:
    # when the script ships a new substitution (e.g. HERMES_DOCKER_IMG_VERSION
    # was added after some testers had already run the script), the state
    # guard prevented the new substitution from applying on a `git pull`
    # re-run, leaving stale values in .env. Always run it.
    generate_compose_override
    state_mark_done "04-compose-rendered"

    if state_is_done "05-secrets-generated"; then
        log "Skip: credentials already generated"
    else
        generate_secrets
        state_mark_done "05-secrets-generated"
    fi

    # The next 3 render steps are intentionally NOT state-guarded -- same
    # rationale as generate_compose_override. They're fast and idempotent,
    # and MUST run before `docker compose up` since these files are
    # file-bind-mounted by containers. Missing source files make Docker
    # create empty dirs at the source path that then fail bind-mount with
    # "not a directory".
    generate_rsyslog_configs
    generate_amavis_50user_config
    generate_ciphermail_hibernate_configs

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

        # Resolve HERMES_HOST_IP from state (set during phase 1). The --init-db
        # path is sometimes invoked manually by users who already ran phase 1
        # and started containers — the IP MUST already be persisted in state.
        if [[ -z "${HERMES_HOST_IP:-}" ]]; then
            HERMES_HOST_IP=$(state_get_value "03-host-ip-confirmed")
            export HERMES_HOST_IP
        fi
        if [[ -z "$HERMES_HOST_IP" ]]; then
            error "Host IP not in state. Run phase 1 first: ./install_hermes_docker.sh"
        fi
        log "Resolved host IP from state: ${HERMES_HOST_IP}"

        if state_is_done "06-databases-created"; then
            log "Skip: databases already created"
        else
            create_databases
            state_mark_done "06-databases-created"
        fi

        if state_is_done "07-install-values-seeded"; then
            log "Skip: install-specific values already seeded"
        else
            seed_install_specific_values
            state_mark_done "07-install-values-seeded"
        fi

        if state_is_done "08-authelia-configured"; then
            log "Skip: Authelia already configured"
        else
            configure_authelia_mysql
            state_mark_done "08-authelia-configured"
        fi

        if state_is_done "09-ldap-initialized"; then
            log "Skip: LDAP already initialized"
        else
            initialize_ldap
            state_mark_done "09-ldap-initialized"
        fi

        if state_is_done "10-nextcloud-configured"; then
            log "Skip: Nextcloud already configured"
            NC_SKIP=1
        else
            NC_SKIP=0
        fi

        if [[ "$NC_SKIP" -eq 0 ]]; then
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

        # Install third-party apps from the app store
        log "  Installing Nextcloud apps from app store..."
        for app in user_oidc mail calendar contacts external; do
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ app:install "$app" --force >> "$LOG_FILE" 2>&1 \
                && log "    Installed: $app" \
                || log "    WARNING: $app install failed (may already be installed)"
        done

        # Enable core apps that ship with NC. These aren't in the app
        # store so app:install would fail — app:enable is the correct
        # command. The user-enumeration settings configured further
        # down depend on files_sharing being on.
        log "  Enabling core Nextcloud apps..."
        for app in files_sharing; do
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ app:enable "$app" >> "$LOG_FILE" 2>&1 \
                && log "    Enabled: $app" \
                || log "    WARNING: Failed to enable $app (may already be enabled)"
        done

        # Disable unwanted default apps
        for app in dashboard photos; do
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ app:disable "$app" >> "$LOG_FILE" 2>&1 \
                && log "    Disabled: $app" \
                || log "    WARNING: Failed to disable $app"
        done

        # Theming — Hermes branding applied on every fresh install.
        # Colors match the admin UI: sidebar dark (#343A40) + Hermes logo orange.
        # Background image is reset so background_color drives the header bar
        # (NC samples an uploaded image for header color; without one, the
        # background_color setting is used directly).
        log "  Configuring Nextcloud theming..."
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config name "Hermes SEG" >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config logo /img/hermes_logo_new_orange2.png >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config slogan "Secure Email Gateway and Server" >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config primary_color '#343A40' >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config background_color '#343A40' >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config background --reset >> "$LOG_FILE" 2>&1
        if [[ -n "$NC_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config url "https://${NC_HOSTNAME}" >> "$LOG_FILE" 2>&1
        fi
        log "  Theming configured"

        # Cross-domain isolation for multi-tenant setups.
        # Each mailbox domain gets its own NC group (created by
        # mailbox_domain_add_action.cfm) and each user is only in their
        # domain's group. Restricting share-dialog / Contacts-app user
        # enumeration to shared groups therefore isolates users by
        # domain. The "full_match" exception lets a user type an exact
        # email from another domain if they deliberately want to share
        # cross-domain, so the restriction isn't absolute — just the
        # default autocomplete scope.
        log "  Configuring Nextcloud cross-domain isolation..."
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
            config:app:set core shareapi_allow_share_dialog_user_enumeration --value=yes >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
            config:app:set core shareapi_restrict_user_enumeration_to_group --value=yes >> "$LOG_FILE" 2>&1
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
            config:app:set core shareapi_restrict_user_enumeration_full_match --value=yes >> "$LOG_FILE" 2>&1 \
            && log "  User enumeration restricted to same-domain groups (full email match allowed for cross-domain shares)" \
            || log "  WARNING: Failed to set user enumeration restrictions"

        # External Sites: "User Console" link in NC top menu
        if [[ -n "$NC_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set external sites \
                --value='{"1":{"id":1,"name":"User Console","url":"https://'"${NC_HOSTNAME}"'/users/","lang":"","type":"link","device":"","icon":"external.svg","groups":[],"redirect":true}}' >> "$LOG_FILE" 2>&1 \
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
                --group-provisioning=0 \
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

            state_mark_done "10-nextcloud-configured"
        fi  # end NC_SKIP gate

        if state_is_done "11-creds-injected"; then
            log "Skip: DB credentials already injected into config files"
        else
            log "Injecting database credentials into config files..."
            if [[ -x "${HERMES_ROOT}/config/hermes/opt/hermes/scripts/rotate_db_credentials.sh" ]]; then
                "${HERMES_ROOT}/config/hermes/opt/hermes/scripts/rotate_db_credentials.sh" --non-interactive >> "$LOG_FILE" 2>&1 \
                    && log "  Database credentials injected into all config files" \
                    || log "  WARNING: Credential injection failed - run rotate_db_credentials.sh manually"
            else
                log "  WARNING: rotate_db_credentials.sh not found - skipping credential injection"
            fi
            state_mark_done "11-creds-injected"
        fi

        state_mark_done "99-completed"
        log "Database initialization completed"
        write_install_summary
        ;;
    --generate-secrets)
        # Only generate secrets (and re-render anything that derives from them)
        touch "$LOG_FILE"
        generate_secrets
        generate_rsyslog_configs
        generate_amavis_50user_config
        generate_ciphermail_hibernate_configs
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
    --wipe)
        # Non-interactive wipe entrypoint. Useful when the detect_previous_install
        # wizard didn't fire (e.g., state dir cleared but containers/volumes
        # still around, or non-tty stdin swallowed the prompt). Still requires
        # confirmation -- destructive operations should never be one-keystroke.
        touch "$LOG_FILE"
        echo ""
        echo "WARNING: this will permanently delete:"
        echo "  - Docker containers + named volumes (mail, db, ldap, etc.)"
        echo "  - All credentials in ${CREDS_DIR} and ${SECRETS_DIR}"
        echo "  - Install state markers in ${STATE_DIR}"
        echo "  - .env, docker-compose.override.yml, .hermes_install_config"
        echo ""
        echo "User-mounted storage directories will NOT be touched. If you"
        echo "want to wipe those too, you must rm -rf them manually before"
        echo "re-running."
        echo ""
        read -p "Type the word WIPE to confirm: " confirm
        if [[ "$confirm" == "WIPE" ]]; then
            wipe_install
            echo "Wipe complete. Re-run the installer to start fresh."
        else
            echo "Wipe not confirmed. Exiting."
            exit 1
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
        echo "Recovery:"
        echo "  --wipe               Tear down EVERYTHING (containers, volumes,"
        echo "                       creds, state) and start fresh"
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
