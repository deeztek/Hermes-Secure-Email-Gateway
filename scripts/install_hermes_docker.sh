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

# Install log location — kept ALONGSIDE the install script (under HERMES_ROOT)
# rather than /var/log/. Reasons:
#   - Self-locating script principle (#217): admin not pinned to a specific
#     host directory layout, so log location follows the script too.
#   - Easier to ship to support / attach to a bug report (one tar of the
#     repo dir captures both code state + logs).
#   - Doesn't require root just to read past logs.
# Gitignored so log files never get accidentally committed.
LOG_DIR="${HERMES_ROOT}/install-logs"
mkdir -p "$LOG_DIR" 2>/dev/null || true
LOG_FILE="${LOG_DIR}/hermes_install_$(date +%Y%m%d_%H%M%S).log"

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
# DNS FORWARDER CONFIGURATION
# ============================================================================
# Hermes ships an internal unbound resolver. Recursive resolution against the
# public root servers is the most "private" mode but fragile -- many networks
# (corporate, restrictive home, cloud) block egress to anything other than an
# approved DNS resolver. Forward mode (forwarding to a known-good upstream)
# Just Works everywhere. We default to forward mode at install time so the
# bootstrap is reliable; admin can switch to recursive via System > DNS
# Resolver in the admin UI once the system is up if they want the privacy
# tradeoff.

_detect_host_resolver() {
    # Return the host's actual upstream DNS server. systemd-resolved publishes
    # the real upstream at /run/systemd/resolve/resolv.conf; /etc/resolv.conf
    # often points at the systemd stub 127.0.0.53 which is useless as a
    # container forwarder. Skip any 127.x.x.x address.
    local candidates=() ip
    if [[ -r /run/systemd/resolve/resolv.conf ]]; then
        while read -r ip; do candidates+=("$ip"); done < <(
            grep '^nameserver' /run/systemd/resolve/resolv.conf 2>/dev/null | awk '{print $2}'
        )
    fi
    if [[ ${#candidates[@]} -eq 0 ]] && [[ -r /etc/resolv.conf ]]; then
        while read -r ip; do candidates+=("$ip"); done < <(
            grep '^nameserver' /etc/resolv.conf 2>/dev/null | awk '{print $2}'
        )
    fi
    for ip in "${candidates[@]}"; do
        if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [[ ! "$ip" =~ ^127\. ]]; then
            echo "$ip"
            return 0
        fi
    done
    return 1
}

prompt_dns_forwarders() {
    # Interactive prompt only -- state-guarded by `03b-dns-forwarders-configured`
    # so the admin isn't re-asked on re-runs. The CSV of forwarders is saved
    # as the state value; render_unbound_forward_conf() reads it back later.
    header "DNS Resolver Configuration"

    cat <<EOF

Hermes uses an internal unbound DNS resolver (hermes_unbound) for ALL
container DNS lookups -- commandbox pulling Lucee, Postfix MX queries,
SpamAssassin RBL lookups, Authelia/Nextcloud upgrade checks, etc.

Unbound is configured in FORWARD mode by default for install-time
reliability. Queries are forwarded to an upstream DNS server you specify
below. This works in every network environment, including restrictive
ones that block direct outbound DNS to the public root servers.

RECOMMENDED FOLLOW-UP: once your install is up and verified, switch to
RECURSIVE mode via System > DNS Resolver in the admin UI. Recursive
resolution is more private (no third-party sees your queries) and avoids
upstream rate-limiting on DNSBL lookups -- but requires your network
to allow outbound UDP/TCP 53 to the public DNS root servers.

EOF

    local detected
    detected=$(_detect_host_resolver || true)
    local default="${detected:-1.1.1.1}"

    if [[ -n "$detected" ]]; then
        echo "Detected host's upstream DNS server: ${detected}"
    else
        echo "Could not auto-detect host's upstream DNS server."
    fi
    echo ""
    echo "Enter upstream DNS server IP(s). For multiple servers, separate"
    echo "with commas (e.g. 192.168.1.1, 192.168.1.2)."
    echo ""

    local admin_dns
    while true; do
        read -p "Upstream DNS [${default}]: " admin_dns
        admin_dns="${admin_dns:-${default}}"

        # Validate each IP
        local -a forwarders=() invalid=0
        local p
        IFS=',' read -ra parts <<< "$admin_dns"
        for p in "${parts[@]}"; do
            p="$(echo "$p" | xargs)"   # trim
            [[ -z "$p" ]] && continue
            if [[ "$p" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                forwarders+=("$p")
            else
                echo "  Invalid IP: ${p}"
                invalid=1
            fi
        done

        if [[ $invalid -eq 0 ]] && [[ ${#forwarders[@]} -gt 0 ]]; then
            state_set_value "03b-dns-forwarders-configured" "${admin_dns}"
            log "DNS forwarders: ${forwarders[*]}"
            return 0
        fi
        echo "Please enter at least one valid IPv4 address."
    done
}

render_unbound_forward_conf() {
    # Always runs (not state-guarded). Reads the CSV from state and renders
    # config/unbound/conf.d/forward.conf. Fast + idempotent; needs to run
    # every time so that if the file gets deleted (manual cleanup, branch
    # switch, lost bind-mount source) the next install re-creates it
    # without forcing the admin through the prompt again.
    local admin_dns
    admin_dns=$(state_get_value "03b-dns-forwarders-configured")
    if [[ -z "$admin_dns" ]]; then
        error "DNS forwarders state missing -- run prompt_dns_forwarders first"
    fi

    local -a forwarders=()
    local p
    IFS=',' read -ra parts <<< "$admin_dns"
    for p in "${parts[@]}"; do
        p="$(echo "$p" | xargs)"
        [[ -z "$p" ]] && continue
        forwarders+=("$p")
    done

    local forward_conf="${HERMES_ROOT}/config/unbound/conf.d/forward.conf"
    mkdir -p "$(dirname "$forward_conf")"
    {
        echo "# Unbound DNS Resolver - Upstream Forwarders"
        echo "# Hermes SEG Docker Platform"
        echo "#"
        echo "# Generated by install_hermes_docker.sh on $(date)"
        echo "# Mode: FORWARD (admin can switch to RECURSIVE via UI)"
        echo ""
        echo "forward-zone:"
        echo '    name: "."'
        echo "    forward-tls-upstream: no"
        local fwd
        for fwd in "${forwarders[@]}"; do
            echo "    forward-addr: ${fwd}"
        done
    } > "$forward_conf"
    log "Rendered config/unbound/conf.d/forward.conf"
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
    # Then offers a second prompt to also wipe user-mounted storage paths
    # (DATA_MOUNT / VMAIL_MOUNT / FILES_MOUNT) -- separately gated since
    # those contain real data and might be a shared filesystem.
    header "Wiping previous install"

    # Read mount paths BEFORE deleting .env / CONFIG_FILE so the optional
    # mount-content wipe knows what to clear. Three-tier lookup:
    #   1. .env  (canonical at runtime)
    #   2. .hermes_install_config  (saved during prompt_mount_points)
    #   3. DEFAULT_*_MOUNT  (fallback so the prompt still works even on a
    #      chain of repeated --wipe runs that deleted the config files
    #      from a prior wipe -- otherwise we'd silently skip the
    #      mount-content prompt and leave /mnt/data populated)
    # The mount-content prompt later filters to paths that actually exist
    # as directories, so a wrong fallback default just means an empty
    # offer, not a wrong wipe.
    local data_mount="" vmail_mount="" files_mount=""
    if [[ -f "${HERMES_ROOT}/.env" ]]; then
        data_mount=$(grep -E '^DATA_MOUNT='  "${HERMES_ROOT}/.env" 2>/dev/null | cut -d= -f2- | tr -d '"' | tr -d "'")
        vmail_mount=$(grep -E '^VMAIL_MOUNT=' "${HERMES_ROOT}/.env" 2>/dev/null | cut -d= -f2- | tr -d '"' | tr -d "'")
        files_mount=$(grep -E '^FILES_MOUNT=' "${HERMES_ROOT}/.env" 2>/dev/null | cut -d= -f2- | tr -d '"' | tr -d "'")
    fi
    if [[ -f "${CONFIG_FILE}" ]]; then
        # shellcheck disable=SC1090
        source "${CONFIG_FILE}" 2>/dev/null || true
        data_mount="${data_mount:-${DATA_MOUNT:-}}"
        vmail_mount="${vmail_mount:-${VMAIL_MOUNT:-}}"
        files_mount="${files_mount:-${FILES_MOUNT:-}}"
    fi
    # Final fallback: the documented defaults.
    data_mount="${data_mount:-${DEFAULT_DATA_MOUNT}}"
    vmail_mount="${vmail_mount:-${DEFAULT_VMAIL_MOUNT}}"
    files_mount="${files_mount:-${DEFAULT_FILES_MOUNT}}"

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

    # Rendered service config files (output of generate_rsyslog_configs,
    # generate_amavis_50user_config, generate_ciphermail_hibernate_configs).
    # All are gitignored, all contain install-time credentials. Wiping them
    # forces a fresh render with fresh creds on the next install. `rm -rf`
    # also handles the case where Docker auto-created an empty directory at
    # the bind-mount source path because the file was missing -- those dirs
    # would otherwise block the next render from writing a file there.
    log "Removing rendered service config files..."
    rm -rf "${HERMES_ROOT}/config/postfix-dkim/etc/rsyslog.d/mysql.conf" \
           "${HERMES_ROOT}/config/opendmarc/etc/rsyslog.d/mysql.conf" \
           "${HERMES_ROOT}/config/mail_filter/etc/rsyslog.d/mysql.conf" \
           "${HERMES_ROOT}/config/ldap/etc/rsyslog.d/mysql.conf" \
           "${HERMES_ROOT}/config/mail_filter/etc/amavis/conf.d/50-user" \
           "${HERMES_ROOT}/config/ciphermail/usr/share/djigzo/conf/database/hibernate.cfg.xml" \
           "${HERMES_ROOT}/config/ciphermail/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" \
           "${HERMES_ROOT}/config/authelia/configuration.yml" \
           "${HERMES_ROOT}/config/postfix-dkim/etc/postfix/main.cf" \
           "${HERMES_ROOT}/config/nginx/etc/nginx/sites-available/hermes-ssl.conf" \
           "${HERMES_ROOT}/config/nginx/etc/nginx/snippets/auth.conf" \
           "${HERMES_ROOT}/config/mail_filter/etc/spamassassin/local.cf" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/KeyTable" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/SigningTable" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/TrustedHosts" \
           "${HERMES_ROOT}/config/commandbox/serverhome/WEB-INF/lucee-server/context/password.txt" \
           "${HERMES_ROOT}/config/common/etc/mailname" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/ssl/bootstrap_hermes.pem" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/ssl/bootstrap_hermes.chain.pem" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/ssl/bootstrap_hermes.bundle.pem" \
           "${HERMES_ROOT}/config/hermes/opt/hermes/ssl/bootstrap_hermes.key" \
           "${HERMES_ROOT}/config/dovecot-2.4/conf/dovecot.conf" \
           "${HERMES_ROOT}/config/dovecot-2.4/conf/auth_app_passwords.lua" \
           2>/dev/null || true
    # Postfix mysql-*.cf files: glob-deleted (count varies per release).
    find "${HERMES_ROOT}/config/postfix-dkim/etc/postfix" -maxdepth 1 -name 'mysql-*.cf' -type f -delete 2>/dev/null || true

    # Postfix lookup tables + compiled .db files: gitignored admin data,
    # may contain prior-install info. Clear so fresh install starts clean.
    # generate_postfix_main_cf() touches empty placeholders + CFML populates
    # via the UI / on save.
    local pf_dir="${HERMES_ROOT}/config/postfix-dkim/etc/postfix"
    rm -f "${pf_dir}"/{transport,transport.BACK,virtual,bcc_maps,tls_policy,sender_access,relay_domains,relay_recipients,networks,amavis_senderbypass,postscreen_access.cidr,regexp_header_checks,relay_passwd,sasl_passwd} 2>/dev/null || true
    find "$pf_dir" -maxdepth 1 -name '*.db' -type f -delete 2>/dev/null || true

    # CFML scratch dir: tmp/<random>_<purpose> files written at runtime
    find "${HERMES_ROOT}/config/hermes/opt/hermes/tmp" -mindepth 1 -maxdepth 1 \
        -not -name '.gitkeep' -delete 2>/dev/null || true

    # nginx per-mailbox-domain configs: CFML's mailbox-domains feature
    # generates <random>_hermes-mailbox-ssl.conf files into sites-available
    # whenever admin adds a mailbox domain. Wipe must clear these too or
    # they survive across installs and confuse future tests.
    find "${HERMES_ROOT}/config/nginx/etc/nginx/sites-available" -maxdepth 1 \
        -name '*_hermes-mailbox-ssl.conf' -type f -delete 2>/dev/null || true

    # nginx sites-enabled: clear everything EXCEPT .gitkeep (the tracked
    # placeholder that keeps the directory in the repo). install script
    # re-creates the hermes-ssl.conf symlink; any per-domain enables get
    # re-rendered by CFML if their corresponding mailbox domain still
    # exists in the DB (which a full wipe also clears).
    find "${HERMES_ROOT}/config/nginx/etc/nginx/sites-enabled" -mindepth 1 -maxdepth 1 \
        -not -name '.gitkeep' -delete 2>/dev/null || true

    # ---- Second-stage prompt: also wipe mount-point CONTENTS? ----
    # Leaving stale data behind breaks fresh-install testing -- the new
    # install generates new random DB creds but the persisted DB files
    # still expect the OLD ones, so containers silently fail to auth.
    # Gated by a separate WIPE-DATA confirmation because it's user data.
    # The mount directories themselves are preserved (admin owns them).
    local any_mount=0
    [[ -n "$data_mount"  && -d "$data_mount"  ]] && any_mount=1
    [[ -n "$vmail_mount" && -d "$vmail_mount" ]] && any_mount=1
    [[ -n "$files_mount" && -d "$files_mount" ]] && any_mount=1

    if [[ "$any_mount" -eq 1 ]]; then
        echo ""
        echo "============================================================"
        echo " Mount-point contents (user data)"
        echo "============================================================"
        echo ""
        echo "These directories hold real data from the previous install:"
        [[ -n "$data_mount"  && -d "$data_mount"  ]] && echo "  ${data_mount}   ($(find "$data_mount"  -mindepth 1 -maxdepth 1 2>/dev/null | wc -l) entries) -- databases / logs / quarantine / LDAP"
        [[ -n "$vmail_mount" && -d "$vmail_mount" ]] && echo "  ${vmail_mount}  ($(find "$vmail_mount" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l) entries) -- mailbox email storage"
        [[ -n "$files_mount" && -d "$files_mount" ]] && echo "  ${files_mount}  ($(find "$files_mount" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l) entries) -- Nextcloud files"
        echo ""
        echo "Leaving them in place will cause the next install to fail auth"
        echo "against persisted DB files (new random creds vs old stored"
        echo "hashes). For fresh-install testing, wipe them too."
        echo ""
        echo "The mount directories themselves are kept; only their CONTENTS"
        echo "are removed."
        echo ""
        echo "  [1] Skip — keep mount-point contents (default)"
        echo "  [2] Wipe mount-point contents"
        echo ""
        local confirm_data
        read -p "Choice [1]: " confirm_data
        if [[ "$confirm_data" == "2" ]]; then
            for mnt in "$data_mount" "$vmail_mount" "$files_mount"; do
                [[ -z "$mnt" ]] && continue
                [[ ! -d "$mnt" ]] && continue
                log "  Wiping contents of ${mnt}"
                # `find ... -mindepth 1 -delete` removes everything inside the
                # mount dir while leaving the mount dir itself in place. Safer
                # than `rm -rf "${mnt}"/*` which misses dotfiles and can choke
                # on argument-list-too-long.
                find "$mnt" -mindepth 1 -delete 2>>"$LOG_FILE" || true
            done
            log "Mount-point contents wiped."
        else
            log "Mount-point contents kept (admin choice)."
        fi
    fi

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
            echo "  - Rendered service configs (rsyslog x4, amavis 50-user,"
            echo "    ciphermail hibernate x2, authelia configuration.yml,"
            echo "    postfix main.cf + mysql-*.cf, nginx hermes-ssl.conf,"
            echo "    SpamAssassin local.cf, OpenDKIM tables, CommandBox"
            echo "    password.txt, /etc/mailname, bootstrap self-signed cert)"
            echo ""
            echo "After confirming, you will get a SECOND prompt asking whether"
            echo "to also wipe the contents of user-mounted storage (DATA_MOUNT"
            echo "/ VMAIL_MOUNT / FILES_MOUNT — typically /mnt/data, /mnt/vmail,"
            echo "/mnt/files). Required for fresh-install testing; skip if you"
            echo "want to preserve mail/files."
            echo ""
            echo "  [1] Cancel (default)"
            echo "  [2] Yes, wipe everything"
            echo ""
            local wipe_choice
            read -p "Choice [1]: " wipe_choice
            case "${wipe_choice:-1}" in
                2) wipe_install ;;
                *) echo "Wipe not confirmed. Exiting."; exit 1 ;;
            esac
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

prompt_mount_points() {
    # Interactive prompts only -- state-guarded by `02-mounts-configured`
    # so the admin isn't re-asked on re-runs. The actual filesystem
    # provisioning (mkdir/touch) lives in provision_mount_dirs() and
    # runs unconditionally; see [[feedback-state-guards-only-for-slow-steps]].
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
    echo "You'll be asked for three storage paths. These can be:"
    echo ""
    echo "  * Dedicated MOUNT POINTS on separate drives (recommended for"
    echo "    production -- better backup story, survives Docker reinstall,"
    echo "    independent quota / capacity management per category)"
    echo ""
    echo "  * Or just ORDINARY DIRECTORIES on the existing drive if you're"
    echo "    testing or running a single-drive setup (e.g. mkdir -p"
    echo "    /mnt/data /mnt/vmail /mnt/files -- no fstab entries needed)"
    echo ""
    echo "All three paths must ALREADY EXIST on the host before continuing."
    echo "Subdirectories under each path are created automatically."
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

    # Persist the admin's choices so re-runs (and load_config) can recover them.
    save_config

    log "Storage paths captured"
}

provision_mount_dirs() {
    # Always runs (not state-guarded). mkdir/touch are fast + idempotent;
    # state-guarding them was a real footgun -- if a prior install completed
    # but the admin later wiped `${DATA_MOUNT}/*` manually, the state marker
    # would skip this and `docker compose up` would die on "bind source path
    # does not exist". See [[feedback-state-guards-only-for-slow-steps]].
    #
    # Requires DATA_MOUNT / VMAIL_MOUNT / FILES_MOUNT to be set -- either
    # by prompt_mount_points() running just before, or by load_config()
    # reading them from .hermes_install_config on a re-run.
    if [[ -z "${DATA_MOUNT:-}" || -z "${VMAIL_MOUNT:-}" || -z "${FILES_MOUNT:-}" ]]; then
        error "Mount paths missing -- run without --init-db or check ${CONFIG_FILE}"
    fi

    log "Provisioning storage subdirectories under ${DATA_MOUNT} / ${VMAIL_MOUNT} / ${FILES_MOUNT}..."

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

    # Nextcloud subdirectories. FILES_MOUNT is dedicated to Nextcloud, so
    # no `nextcloud/` prefix -- the mount point itself IS the Nextcloud root.
    mkdir -p "${FILES_MOUNT}/app"                       # nextcloud volume
    mkdir -p "${FILES_MOUNT}/redis"                     # nextcloud_redis volume

    # Pre-create empty log-file placeholders that fail2ban globs at startup.
    # If the glob matches zero files, fail2ban exits 255. On a fresh install
    # this races against Authelia/Dovecot creating their own log files.
    touch "${DATA_MOUNT}/authelia/logs/authelia.log"
    touch "${DATA_MOUNT}/dovecot/logs/dovecot-info.log"

    log "Storage subdirectories provisioned"
}

save_config() {
    log "Saving installation configuration..."
    cat > "$CONFIG_FILE" << EOF
# Hermes SEG Installation Configuration
# Generated: $(date)
# DO NOT EDIT MANUALLY - regenerate with install script

DATA_MOUNT="${DATA_MOUNT}"
VMAIL_MOUNT="${VMAIL_MOUNT}"
FILES_MOUNT="${FILES_MOUNT}"
ENABLE_NEXTCLOUD="${ENABLE_NEXTCLOUD:-false}"
HERMES_ROOT="${HERMES_ROOT}"
EOF
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
    if [[ -z "${DATA_MOUNT:-}" ]]; then
        if ! load_config; then
            error "No configuration found. Run installation first."
        fi
    fi

    # All three mount points are required -- empty ${DATA_MOUNT} in compose
    # substitution would resolve to '/dbase' (a real root path), which is
    # dangerous. prompt_mount_points / load_config are the only paths that set these.
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

    # Outbound DNS reachability — Hermes runs an internal unbound resolver
    # (hermes_unbound) that performs FULL RECURSIVE resolution against the
    # public DNS root servers. This requires outbound UDP/53 + TCP/53 to be
    # OPEN at the host firewall AND any upstream perimeter (corporate
    # firewall, cloud security group, ISP NAT). Without it:
    #   - commandbox can't download Lucee from forgebox.io (install fatal)
    #   - Postfix can't do MX lookups (mail flow broken)
    #   - SpamAssassin/Amavis RBL queries fail
    # Test now from the host before we commit to anything else. If this
    # fails the install will fail later in --init-db with a clearer error,
    # but we surface it here so the admin can fix it before generating
    # secrets / rendering configs.
    log "Checking outbound DNS reachability (UDP 53 to public resolvers)..."
    if command -v dig &>/dev/null; then
        if dig +time=3 +tries=1 @1.1.1.1 www.forgebox.io >/dev/null 2>&1; then
            log "Outbound DNS: OK (UDP/53 reachable)"
        else
            warn "Outbound DNS test to 1.1.1.1 failed. UDP/TCP port 53 MUST"
            warn "be open outbound at the host firewall and the network"
            warn "perimeter, or the install will fail when commandbox tries"
            warn "to download Lucee. If your network blocks 53, you can"
            warn "enable upstream forwarders in"
            warn "config/unbound/conf.d/forward.conf after this script finishes."
        fi
    elif command -v nslookup &>/dev/null; then
        if nslookup -timeout=3 www.forgebox.io 1.1.1.1 >/dev/null 2>&1; then
            log "Outbound DNS: OK (UDP/53 reachable)"
        else
            warn "Outbound DNS test to 1.1.1.1 failed -- see above"
        fi
    else
        warn "Neither dig nor nslookup available -- can't pre-verify outbound DNS"
    fi

    log "Pre-flight checks completed"
}

# ============================================================================
# PREFLIGHT DNS CHECK (phase 2 / --init-db)
# ============================================================================
# All Hermes containers route DNS through hermes_unbound at ${IPV4SUBNET}.117.
# If unbound isn't running, or can't perform recursive resolution, every
# container that needs external DNS (commandbox downloading Lucee from
# forgebox.io, Authelia/Nextcloud reaching update repos, postfix doing
# MX lookups, etc.) fails. The failures are often opaque ("Temporary
# failure in name resolution", "Unknown host") and the user wastes time
# chasing the symptom container instead of the root cause.
#
# Run this BEFORE any --init-db work so the user gets a clean,
# actionable error instead of an opaque failure deep in the install.
preflight_dns_check() {
    header "Preflight: DNS Resolver Health Check"

    local subnet
    subnet=$(grep -E '^IPV4SUBNET=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    subnet="${subnet:-172.16.32}"

    # 1. Is hermes_unbound running?
    local unbound_status
    unbound_status=$(docker inspect -f '{{.State.Status}}' hermes_unbound 2>/dev/null)
    if [[ "$unbound_status" != "running" ]]; then
        cat <<EOF >&2

[FATAL] hermes_unbound container is not running (status: ${unbound_status:-not found})

All Hermes containers route DNS through hermes_unbound at ${subnet}.117.
Without it, commandbox can't download Lucee from forgebox.io and the
admin UI never starts.

Check:
  docker logs hermes_unbound
  docker compose up -d hermes_unbound
  docker compose ps

EOF
        error "Unbound DNS resolver not running"
        return 1
    fi
    log "hermes_unbound container is running"

    # 2. Can a typical container resolve an external hostname via unbound?
    # Use hermes_db_server as the probe -- it's configured with unbound as
    # its DNS resolver (per compose), so this exercises the full container
    # -> unbound -> recursive-lookup path. We only need the container to be
    # RUNNING (libc + getent) -- MariaDB itself doesn't have to be ready.
    local db_status
    db_status=$(docker inspect -f '{{.State.Status}}' hermes_db_server 2>/dev/null)
    if [[ "$db_status" != "running" ]]; then
        error "hermes_db_server is not running (status: ${db_status:-not found}) -- can't probe DNS path. Run 'docker compose up -d' first."
        return 1
    fi

    local test_host="www.forgebox.io"
    log "Resolving ${test_host} via unbound (exercises recursive path)..."
    if docker exec hermes_db_server getent hosts "$test_host" >/dev/null 2>&1; then
        log "External DNS resolution working"
        return 0
    fi

    # Failed. Give an actionable error message.
    cat <<EOF >&2

[FATAL] DNS resolution failed -- container cannot resolve ${test_host}

hermes_unbound is running but its recursive resolver isn't returning
answers for external hostnames. commandbox will fail to download Lucee
from forgebox.io, and the Hermes admin UI will never start.

Most likely causes:

  1. Outbound port 53 (DNS) blocked by host firewall / network policy.
     Unbound performs full recursive resolution against the DNS root
     servers; some networks block this.

     Workaround: enable upstream forwarders. Edit
     config/unbound/conf.d/forward.conf and uncomment the
     forward-zone block with public resolvers (1.1.1.1, 8.8.8.8),
     then:
       docker compose restart hermes_unbound
     and re-run --init-db.

  2. DNSSEC validation failing on root anchor or recursive query
     errors. Check unbound logs:
       docker logs --tail 50 hermes_unbound

  3. Host has no outbound DNS at all. Test from the host:
       dig @1.1.1.1 ${test_host}    # should succeed
     If this fails, fix host networking first.

EOF
    error "DNS preflight check failed"
    return 1
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

    # ---- Local helpers ----
    # Write VALUE to TARGET only if TARGET doesn't exist. No explicit chmod
    # -- files inherit the script's umask (typically 0022 -> mode 0644),
    # which is required so non-root processes inside containers (Nextcloud
    # PHP-FPM as www-data, etc.) can read the bind-mounted Docker secrets.
    # Host security is the admin's responsibility on a dedicated server.
    _ensure_secret() {
        local target="$1"
        local value="$2"
        if [[ ! -f "$target" ]]; then
            printf '%s' "$value" > "$target"
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
    log "  + ldap_service_password (creds/ + keys/ldap_user_password_file)"

    # Authelia OIDC JWKS -- RSA 2048 private key in PEM format. Authelia
    # reads this as the signing key for ID tokens and OIDC userinfo. The
    # public half is exposed via /.well-known/jwks.json so clients can
    # verify signatures.
    if [[ ! -f "${SECRETS_DIR}/authelia_identity_providers_oidc_jwks_file" ]]; then
        log "  + authelia_identity_providers_oidc_jwks_file (generating RSA 2048 private key)"
        openssl genrsa -out "${SECRETS_DIR}/authelia_identity_providers_oidc_jwks_file" 2048 2>>"$LOG_FILE"
        # openssl creates with 0600; relax so non-root container processes
        # (Authelia) can read the bind-mounted secret.
        chmod 644 "${SECRETS_DIR}/authelia_identity_providers_oidc_jwks_file"
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
        log "  + authelia_identity_providers_oidc_clients_client_secret_plain_file"
        log "  + authelia_identity_providers_oidc_clients_client_secret_digest_file"
        log "  + nextcloud_oidc_secret (matches Authelia plain)"
    else
        log "  = OIDC client secret pair (kept)"
        # Keep Nextcloud's copy in sync if it drifted
        if [[ ! -f "$NC_OIDC_FILE" ]]; then
            cp "$OIDC_PLAIN_FILE" "$NC_OIDC_FILE"
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

    # Split hostname into name + domain: smtp.example.com -> smtp / example.com.
    # Bare-IP HERMES_HOSTNAME (the install default before admin sets a real
    # hostname) would split into nonsense like 192 / 168.30.18 -- substitute
    # the Hermes-canonical placeholder so amavis sees a sane SERVER-NAME /
    # SERVER-DOMAIN. CFML's amavis re-render rewrites these on first save.
    # Same approach as postfix's myhostname handling per
    # [[feedback-demo-data-domain]].
    local server_name server_domain
    if [[ "$hermes_hostname" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        server_name="smtp"
        server_domain="domain.tld"
    else
        server_name="${hermes_hostname%%.*}"
        server_domain="${hermes_hostname#*.}"
    fi

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
        log "  + $(echo "$target" | sed "s|^${HERMES_ROOT}/||")"
    }

    _render_hibernate_conf "$cfg_template"  "$cfg_target"
    _render_hibernate_conf "$conn_template" "$conn_target"

    log "CipherMail Hibernate configs rendered"
}

# ============================================================================
# RENDER AUTHELIA CONFIGURATION
# ============================================================================

generate_authelia_config() {
    # Renders config/authelia/configuration.yml from the committed template
    # at config/hermes/opt/hermes/templates/configuration.yml. The whole
    # config/authelia/ directory is gitignored, so on a fresh clone there is
    # NO live config at all -- Authelia starts up against its empty defaults
    # and immediately fails 12+ schema validations.
    #
    # The template uses two layers of substitution:
    #   1. Install-time (this function): replaces `hermes_*` literal
    #      placeholders with admin-supplied / default scalar values.
    #   2. Authelia runtime ({{ env ... }} / {{ secret ... }} directives,
    #      enabled by X_AUTHELIA_CONFIG_FILTERS=template in docker-compose).
    #      These pull LDAP base DN, OIDC keys, DB creds, etc. from
    #      /keys/<name> Docker secret bind mounts at startup.
    #
    # The container reads /config/configuration.yml (mounted from
    # ./config/authelia/), so this function MUST run before
    # `docker compose up`. Not state-guarded -- same rationale as the other
    # render functions. Linked: #179
    header "Rendering Authelia Configuration"

    local template="${HERMES_ROOT}/config/hermes/opt/hermes/templates/configuration.yml"
    local target_dir="${HERMES_ROOT}/config/authelia"
    local target="${target_dir}/configuration.yml"

    if [[ ! -f "$template" ]]; then
        error "Authelia template missing: $template"
    fi

    # Need HERMES_HOSTNAME for the access_control domain + SMTP sender.
    local hermes_hostname
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    if [[ -z "$hermes_hostname" ]]; then
        error "HERMES_HOSTNAME missing from .env -- run generate_compose_override first"
    fi
    # Domain portion (after the first dot) for the SMTP From address.
    # Bare-IP HERMES_HOSTNAME would split into nonsense like 168.30.18 and
    # produce `no-reply@168.30.18` (technically valid but ugly). Use the
    # Hermes-canonical placeholder per [[feedback-demo-data-domain]];
    # admin can change once a real hostname is configured.
    local server_domain
    if [[ "$hermes_hostname" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        server_domain="domain.tld"
    else
        server_domain="${hermes_hostname#*.}"
    fi

    mkdir -p "$target_dir"
    [[ -e "$target" ]] && rm -rf "$target"

    # ---- Placeholders, with comments on each default value ----
    # Order matters: substitute longer placeholders BEFORE shorter ones that
    # share a prefix (e.g. hermes_session_expiration before any hypothetical
    # hermes_session match -- in this template the bare "hermes_session" is a
    # cookie NAME on line 229, not a placeholder, so we never substitute it).
    # The 6 non-placeholder hermes_* tokens that occur as literals are:
    #   hermes_ldap, hermes_db_server, hermes_authelia_redis,
    #   hermes_postfix_dkim, hermes_session (cookie name), hermes_webmail
    #   (auth policy name). Our sed patterns use full placeholder names, so
    #   those literals are untouched.
    sed \
        -e "s|hermes_log_level|info|g" \
        -e "s|hermes_log_format|text|g" \
        -e "s|hermes_duo_self_enrollment|false|g" \
        -e "s|hermes_duo_hostname||g" \
        -e "s|hermes_duo_disable|true|g" \
        -e "s|hermes_authentication_backend_disable_reset_password|false|g" \
        -e "s|hermes_access_control_domain|${hermes_hostname}|g" \
        -e "s|hermes_session_expiration|0|g" \
        -e "s|hermes_session_inactivity|3600|g" \
        -e "s|hermes_session_remember_me|1M|g" \
        -e "s|hermes_regulation_max_retries|5|g" \
        -e "s|hermes_regulation_find_time|120|g" \
        -e "s|hermes_regulation_ban_time|300|g" \
        -e "s|hermes_notifier_smtp_sender|no-reply@${server_domain}|g" \
        -e "s|hermes_notifier_smtp_subject|[Hermes SEG] {title}|g" \
        "$template" > "$target"

    # Sanity check: no hermes_* placeholders should remain. The 6 literal
    # tokens above are expected to still match; everything else (e.g.
    # hermes_log_level) should be gone.
    local leftovers
    leftovers=$(grep -oE 'hermes_[a-z_]+' "$target" | sort -u | grep -vE '^hermes_(ldap|db_server|authelia_redis|postfix_dkim|session|webmail)$' || true)
    if [[ -n "$leftovers" ]]; then
        warn "Authelia config has unsubstituted placeholders:"
        warn "$leftovers"
    fi

    log "  + config/authelia/configuration.yml"
    log "Authelia configuration rendered (domain=${hermes_hostname})"
}

# ============================================================================
# RENDER POSTFIX CONFIGS
# ============================================================================

generate_postfix_configs() {
    # Renders the postfix configs the container expects at startup:
    #   /etc/postfix/main.cf                   <- main.cf.HERMES (copy + dev-host sub)
    #   /etc/postfix/mysql-*.cf  (14 files)    <- mysql-*.HERMES (creds sub)
    #
    # All are gitignored (the `main.cf*` and `mysql-*.cf` wildcards). The
    # parent directory `config/postfix-dkim/etc/postfix` is bind-mounted as
    # a directory, so missing FILES inside won't fail compose-up but postfix
    # itself will fail to start (or start with broken DB lookups).
    #
    # Note: main.cf.HERMES currently has DEV-specific values baked in
    # (`smtp-dev.deeztek.com`, `deeztek.com`, dev mynetworks) -- not just
    # neat placeholders. We sub the most obvious ones (hostname, domain,
    # mynetworks) to get a fresh install booting cleanly. Admin should
    # regenerate via the System Settings UI on first login for full accuracy.
    #
    # Not state-guarded -- same rationale as the other render functions.
    # Linked: #179
    header "Rendering Postfix Configs"

    local target_dir="${HERMES_ROOT}/config/postfix-dkim/etc/postfix"
    mkdir -p "$target_dir"

    # ---- Credentials + hostname / subnet from .env ----
    local hermes_user hermes_pass hermes_hostname server_domain ipv4_subnet
    hermes_user=$(cat "${CREDS_DIR}/hermes_username")
    hermes_pass=$(cat "${CREDS_DIR}/hermes_password")
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    ipv4_subnet=$(grep -E '^IPV4SUBNET=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    ipv4_subnet="${ipv4_subnet:-172.16.32}"

    if [[ -z "$hermes_user" || -z "$hermes_pass" ]]; then
        error "hermes DB credentials missing in ${CREDS_DIR}/ -- run generate_secrets first"
    fi
    if [[ -z "$hermes_hostname" ]]; then
        error "HERMES_HOSTNAME missing from .env -- run generate_compose_override first"
    fi

    # Domain portion. Bare-IP HERMES_HOSTNAME would split into nonsense
    # (e.g. 168.30.18). Use Hermes-canonical placeholder per
    # [[feedback-demo-data-domain]]; admin overrides via UI.
    if [[ "$hermes_hostname" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        server_domain="domain.tld"
    else
        server_domain="${hermes_hostname#*.}"
    fi

    # ---- main.cf: render from CANONICAL template ----
    # The canonical postfix template lives at
    # config/hermes/opt/hermes/conf_files/main.cf.HERMES (mounted into
    # the commandbox container at /opt/hermes/conf_files/main.cf.HERMES).
    # generate_postfix_configuration.cfm reads from there too, then runs
    # `postconf -e` for individual parameters from the DB on Save. This
    # bootstrap mirrors that: cp the canonical template, then sed in the
    # install values so postfix has a parseable config at first start.
    #
    # NB: do NOT confuse with config/postfix-dkim/etc/postfix/main.cf.HERMES
    # -- that path is the BACKUP location CFML writes the previous live
    # config to before regenerating; it's gitignored and never authoritative.
    local main_template="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/main.cf.HERMES"
    local main_target="${target_dir}/main.cf"
    if [[ -f "$main_template" ]]; then
        [[ -e "$main_target" ]] && rm -rf "$main_target"
        # Postfix rejects bare IPs for myhostname (must be FQDN-form;
        # `postmulti[N]: fatal: parameter myhostname: bad parameter value`).
        # When HERMES_HOSTNAME is a bare IP -- the install default before
        # admin sets a real hostname -- substitute the Hermes-canonical
        # placeholder (smtp.domain.tld; matches the demo-data convention
        # per [[feedback-demo-data-domain]]) for postfix only. CFML's
        # generate_postfix_configuration.cfm rewrites this on first save
        # from the System Settings UI.
        local postfix_hostname="$hermes_hostname"
        local postfix_origin="$server_domain"
        if [[ "$hermes_hostname" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            postfix_hostname="smtp.domain.tld"
            postfix_origin="domain.tld"
        fi
        # TLS cert paths point at the self-signed bootstrap cert generated
        # by generate_self_signed_cert() -- same one nginx uses. Admin
        # uploads a real cert via the System Certificates UI; CFML's
        # generate_postfix_configuration.cfm postconf's the live paths.
        sed \
            -e "s|^myhostname = .*|myhostname = ${postfix_hostname}|" \
            -e "s|^myorigin = .*|myorigin = ${postfix_origin}|" \
            -e "s|^mynetworks = .*|mynetworks = 127.0.0.1, ${ipv4_subnet}.0/24|" \
            -e "s|^smtpd_tls_cert_file = .*|smtpd_tls_cert_file = /opt/hermes/ssl/bootstrap_hermes.pem|" \
            -e "s|^smtpd_tls_key_file = .*|smtpd_tls_key_file = /opt/hermes/ssl/bootstrap_hermes.key|" \
            -e "s|^smtpd_tls_CAfile = .*|smtpd_tls_CAfile = /opt/hermes/ssl/bootstrap_hermes.chain.pem|" \
            "$main_template" > "$main_target"
        log "  + config/postfix-dkim/etc/postfix/main.cf"
    else
        error "Postfix canonical template missing: $main_template"
    fi

    # ---- mysql-*.cf: 14 lookup tables with HERMES-USERNAME/HERMES-PASSWORD ----
    # mysql-ldap-syslog.HERMES is a different beast (rsyslog config for slapd
    # logging to MySQL) and is handled separately by generate_rsyslog_configs
    # via the ldap rsyslog template. Skipped here.
    local mysql_template_dir="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files"
    local rendered=0
    for tmpl in "$mysql_template_dir"/mysql-*.HERMES; do
        [[ -e "$tmpl" ]] || continue
        local base=$(basename "$tmpl" .HERMES)
        [[ "$base" == "mysql-ldap-syslog" ]] && continue
        local target="${target_dir}/${base}.cf"
        [[ -e "$target" ]] && rm -rf "$target"
        sed \
            -e "s|HERMES-USERNAME|${hermes_user}|g" \
            -e "s|HERMES-PASSWORD|${hermes_pass}|g" \
            "$tmpl" > "$target"
        rendered=$((rendered + 1))
    done
    log "  + config/postfix-dkim/etc/postfix/mysql-*.cf (${rendered} files)"

    # master.cf is tracked directly at the render-target path (no
    # placeholders, no CFML writes -- it's a pure framework file).
    # Nothing to render here. .dkim/.non-dkim/.postscreen variants are
    # tracked as alternatives admins can swap in by hand.

    # ---- Lookup-table placeholder files ----
    # These files are gitignored (admin data managed by CFML or directly by
    # admin). Touch empty placeholders so postfix doesn't log warnings on
    # every lookup at startup. CFML's generate_*.cfm pages populate them
    # later; admin's first save through the UI triggers postmap to build
    # the .db hashmap files.
    local lookup_tables=(
        transport virtual bcc_maps tls_policy sender_access
        relay_domains relay_recipients networks amavis_senderbypass
        postscreen_access.cidr regexp_header_checks
        relay_passwd sasl_passwd
    )
    local tbl
    for tbl in "${lookup_tables[@]}"; do
        local tpath="${target_dir}/${tbl}"
        [[ -d "$tpath" ]] && rm -rf "$tpath"   # recover empty-dir bind-mount trap
        if [[ ! -f "$tpath" ]]; then
            touch "$tpath"
        fi
    done
    log "  + ${#lookup_tables[@]} postfix lookup-table placeholders touched"
    log "Postfix configs rendered"
}

# ============================================================================
# RENDER NGINX HERMES-SSL CONFIG
# ============================================================================

generate_nginx_config() {
    # Renders two nginx files from the CANONICAL templates under
    # config/hermes/opt/hermes/templates/ (mounted into the commandbox
    # container at /opt/hermes/templates/):
    #
    #   templates/hermes-ssl.conf  ->  config/nginx/etc/nginx/sites-available/hermes-ssl.conf
    #   templates/auth.conf        ->  config/nginx/etc/nginx/snippets/auth.conf
    #
    # generate_nginx_configuration.cfm and generate_auth_nginx_configuration.cfm
    # read these exact same templates, ReReplace the `hermes_*` placeholders
    # from DB values, and write to the live paths. Bootstrap mirrors that.
    #
    # NB: do NOT use config/nginx/etc/nginx/sites-available/hermes-ssl.HERMES
    # or config/nginx/etc/nginx/snippets/auth.HERMES as source -- those are
    # CFML write-time BACKUPS, not templates. Both deleted from the repo and
    # gitignored to prevent re-confusion.
    #
    # Bootstrap defaults applied:
    #   hermes_server_name      -> HERMES_HOSTNAME from .env
    #   hermes_ssl_certificate  -> /etc/letsencrypt/live/<hostname>/fullchain.pem
    #   hermes_ssl_key          -> /etc/letsencrypt/live/<hostname>/privkey.pem
    #   hermes_hsts             -> empty (admin enables via UI)
    #   hermes_ocsp             -> empty (admin enables via UI)
    #   hermes_verify           -> empty (no client cert verify on bootstrap)
    #   hermes_fw_hermes        -> empty (no admin IP allowlist yet)
    #   hermes_fw_ciphermail    -> empty (same)
    #   hermes_console_host     -> HERMES_HOSTNAME
    #
    # Without these rendered files nginx falls back to its default site and
    # serves "Welcome to nginx!" instead of the Hermes admin console.
    #
    # Not state-guarded. Linked: #179
    header "Rendering Nginx Configs"

    local site_template="${HERMES_ROOT}/config/hermes/opt/hermes/templates/hermes-ssl.conf"
    local site_target="${HERMES_ROOT}/config/nginx/etc/nginx/sites-available/hermes-ssl.conf"
    local auth_template="${HERMES_ROOT}/config/hermes/opt/hermes/templates/auth.conf"
    local auth_target="${HERMES_ROOT}/config/nginx/etc/nginx/snippets/auth.conf"

    if [[ ! -f "$site_template" ]]; then
        error "Nginx canonical template missing: $site_template"
    fi
    if [[ ! -f "$auth_template" ]]; then
        error "Auth canonical template missing: $auth_template"
    fi

    local hermes_hostname
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    if [[ -z "$hermes_hostname" ]]; then
        error "HERMES_HOSTNAME missing from .env"
    fi

    # Point nginx at the self-signed bootstrap cert generated by
    # generate_self_signed_cert(). Same files postfix uses (via main.cf
    # render). Admin uploads a real cert via System Certificates UI;
    # generate_nginx_configuration.cfm re-renders this template with
    # the new paths on Save.
    local ssl_cert="/opt/hermes/ssl/bootstrap_hermes.pem"
    local ssl_key="/opt/hermes/ssl/bootstrap_hermes.key"

    # hermes-ssl.conf -- 8 real placeholders. The other hermes_* tokens in
    # the template (hermes_authelia, hermes_commandbox, hermes_ciphermail,
    # hermes_nextcloud, hermes_webmail, hermes_access, hermes_error) are
    # literal container/log names and intentionally not substituted.
    [[ -e "$site_target" ]] && rm -rf "$site_target"
    sed \
        -e "s|hermes_server_name|${hermes_hostname}|g" \
        -e "s|hermes_ssl_certificate|${ssl_cert}|g" \
        -e "s|hermes_ssl_key|${ssl_key}|g" \
        -e "s|^[[:space:]]*hermes_hsts;[[:space:]]*\$|        # add_header Strict-Transport-Security \"max-age=31536000; preload\";|" \
        -e "s|^[[:space:]]*hermes_ocsp;[[:space:]]*\$|        # ssl_stapling on;|" \
        -e "s|^[[:space:]]*hermes_verify;[[:space:]]*\$|        # ssl_stapling_verify on;|" \
        -e "s|hermes_fw_hermes||g" \
        -e "s|hermes_fw_ciphermail||g" \
        "$site_template" > "$site_target"
    log "  + config/nginx/etc/nginx/sites-available/hermes-ssl.conf"

    # Symlink sites-available -> sites-enabled so nginx actually loads
    # the vhost. Without this, nginx starts with no enabled sites, accepts
    # TCP connections on :80/:443, then immediately RSTs because no
    # server block matches the request (no error in error.log because
    # the conn never gets far enough to be classified). Relative path so
    # the symlink resolves correctly when bind-mounted into the container
    # at /etc/nginx/sites-{available,enabled}/.
    local enabled_dir="${HERMES_ROOT}/config/nginx/etc/nginx/sites-enabled"
    mkdir -p "$enabled_dir"
    local enabled_link="${enabled_dir}/hermes-ssl.conf"
    [[ -e "$enabled_link" || -L "$enabled_link" ]] && rm -f "$enabled_link"
    ln -s "../sites-available/hermes-ssl.conf" "$enabled_link"
    log "  + config/nginx/etc/nginx/sites-enabled/hermes-ssl.conf (-> ../sites-available/)"

    # auth.conf snippet (single placeholder)
    [[ -e "$auth_target" ]] && rm -rf "$auth_target"
    sed -e "s|hermes_console_host|${hermes_hostname}|g" "$auth_template" > "$auth_target"
    log "  + config/nginx/etc/nginx/snippets/auth.conf"

    log "Nginx configs rendered (domain=${hermes_hostname})"
}

# ============================================================================
# RENDER SPAMASSASSIN local.cf
# ============================================================================

generate_spamassassin_config() {
    # Plain copy from the .HERMES template -- no placeholders. SpamAssassin
    # would start with built-in defaults if local.cf is absent, but the
    # template carries Hermes-tuned scores and tweaks.
    # Linked: #179
    header "Rendering SpamAssassin local.cf"

    local template="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/local.cf.HERMES"
    local target="${HERMES_ROOT}/config/mail_filter/etc/spamassassin/local.cf"

    if [[ ! -f "$template" ]]; then
        warn "SpamAssassin template missing: $template -- skipping"
        return 0
    fi

    [[ -e "$target" ]] && rm -rf "$target"
    cp "$template" "$target"
    log "  + config/mail_filter/etc/spamassassin/local.cf"
    log "SpamAssassin local.cf rendered"
}

# ============================================================================
# RENDER OPENDKIM TABLES
# ============================================================================

generate_opendkim_tables() {
    # Writes EMPTY KeyTable + SigningTable + an initial TrustedHosts with
    # the Docker subnet + 127.0.0.1. Admin populates KeyTable / SigningTable
    # via the System Settings > DKIM admin UI as they configure outbound
    # signing per domain.
    #
    # OpenDKIM refuses to start if these files don't exist (even empty),
    # so on fresh install we MUST create stubs before postfix starts.
    # Linked: #179
    header "Rendering OpenDKIM Tables"

    local dkim_dir="${HERMES_ROOT}/config/hermes/opt/hermes/dkim"
    mkdir -p "$dkim_dir"

    local ipv4_subnet
    ipv4_subnet=$(grep -E '^IPV4SUBNET=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    ipv4_subnet="${ipv4_subnet:-172.16.32}"

    # KeyTable + SigningTable + ExemptDomains: empty stubs.
    # ExemptDomains is referenced as `refile:/opt/hermes/dkim/ExemptDomains`
    # by both opendkim.conf and opendkim-sign.conf -- if the file is missing,
    # opendkim logs `dkimf_db_open(): No such file or directory` (noise, not
    # fatal, but clutters logs).
    for f in KeyTable SigningTable ExemptDomains; do
        local target="${dkim_dir}/${f}"
        [[ -e "$target" ]] && rm -rf "$target"
        : > "$target"
        log "  + config/hermes/opt/hermes/dkim/${f} (empty stub)"
    done

    # TrustedHosts: localhost + the Docker subnet. Admin adds additional
    # trusted IPs via the UI later.
    local trusted="${dkim_dir}/TrustedHosts"
    [[ -e "$trusted" ]] && rm -rf "$trusted"
    cat > "$trusted" <<EOF
127.0.0.1
${ipv4_subnet}.0/24
EOF
    log "  + config/hermes/opt/hermes/dkim/TrustedHosts (127.0.0.1 + ${ipv4_subnet}.0/24)"
    log "OpenDKIM tables initialized"
}

# ============================================================================
# RENDER COMMANDBOX LUCEE PASSWORD FILE
# ============================================================================

generate_commandbox_password_file() {
    # Writes the literal string `$CFADMIN_PASSWORD` to the Lucee password.txt
    # file. CommandBox's startup substitutes this with the value of the
    # $CFADMIN_PASSWORD env var, which compose populates from the
    # ./config/hermes/opt/hermes/creds/cfadmin_password Docker secret
    # (generated by generate_secrets()).
    #
    # The file is bind-mounted as a FILE in docker-compose.yml -- if it's
    # missing on a fresh clone, Docker creates an empty dir at the source
    # path and the commandbox container fails to start with "not a directory".
    # Linked: #179
    header "Rendering CommandBox Lucee Password File"

    local target_dir="${HERMES_ROOT}/config/commandbox/serverhome/WEB-INF/lucee-server/context"
    local target="${target_dir}/password.txt"

    mkdir -p "$target_dir"
    [[ -e "$target" ]] && rm -rf "$target"
    # The single-quoted heredoc prevents the shell from expanding $CFADMIN_PASSWORD;
    # we want the literal token to land in the file. CommandBox resolves it.
    printf '%s\n' '$CFADMIN_PASSWORD' > "$target"
    log "  + config/commandbox/serverhome/WEB-INF/lucee-server/context/password.txt"
    log "CommandBox Lucee password file rendered (env-var-templated)"
}

# ============================================================================
# RENDER /etc/mailname
# ============================================================================

generate_mailname_config() {
    # Renders config/common/etc/mailname (bind-mounted into the amavis
    # container at /etc/mailname). The canonical template lives at
    # config/hermes/opt/hermes/conf_files/mailname.HERMES and contains
    # `SERVER-NAME.SERVER-DOMAIN`. The CFML modify_hosts.cfm renders it
    # the same way when admin saves the Hosts page; this is the
    # install-time bootstrap so amavis has a correct mailname at first
    # start (legacy installer step at line ~646: `echo $MAIL_NAME >
    # /etc/mailname`).
    # Linked: #179
    header "Rendering /etc/mailname"

    local template="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/mailname.HERMES"
    local target_dir="${HERMES_ROOT}/config/common/etc"
    local target="${target_dir}/mailname"

    if [[ ! -f "$template" ]]; then
        error "mailname template missing: $template"
    fi

    local hermes_hostname
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    if [[ -z "$hermes_hostname" ]]; then
        error "HERMES_HOSTNAME missing from .env"
    fi

    local server_name="${hermes_hostname%%.*}"
    local server_domain="${hermes_hostname#*.}"

    mkdir -p "$target_dir"
    [[ -e "$target" ]] && rm -rf "$target"
    sed -e "s|SERVER-NAME|${server_name}|g" \
        -e "s|SERVER-DOMAIN|${server_domain}|g" \
        "$template" > "$target"
    log "  + config/common/etc/mailname (${hermes_hostname})"
    log "/etc/mailname rendered"
}

# ============================================================================
# GENERATE SELF-SIGNED TLS CERTIFICATE
# ============================================================================

generate_self_signed_cert() {
    # Generates a self-signed TLS cert (CN=localhost, 10-year validity,
    # 4096-bit RSA) for nginx + postfix to use until admin uploads a real
    # cert via the System Certificates page in the admin UI. Files are
    # placed using the same naming convention CFML's import_system_certificate
    # uses (`<file_name>_hermes.{pem,chain.pem,bundle.pem,key}`) so the UI
    # can manage / replace this cert through the standard flow.
    #
    # Using CN=localhost (not HERMES_HOSTNAME) by design — admin should
    # SEE the hostname mismatch warning as a clear signal to upload a
    # real cert. Tying it to HERMES_HOSTNAME would imply the cert is
    # legit for that host.
    #
    # State-guarded so re-runs don't clobber an admin-replaced cert.
    # Linked: #179
    header "Generating Self-Signed Bootstrap TLS Certificate"

    local ssl_dir="${HERMES_ROOT}/config/hermes/opt/hermes/ssl"
    local prefix="bootstrap"
    local pem="${ssl_dir}/${prefix}_hermes.pem"
    local chain="${ssl_dir}/${prefix}_hermes.chain.pem"
    local bundle="${ssl_dir}/${prefix}_hermes.bundle.pem"
    local key="${ssl_dir}/${prefix}_hermes.key"

    mkdir -p "$ssl_dir"

    if [[ -f "$pem" && -f "$key" ]]; then
        log "  = bootstrap_hermes.{pem,key} already exist (kept)"
        return 0
    fi

    log "Generating CN=localhost self-signed cert (4096-bit RSA, 10-year)..."
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
        -subj "/CN=localhost" \
        -addext "subjectAltName=DNS:localhost,DNS:hermes-bootstrap.local" \
        -keyout "$key" -out "$pem" 2>>"$LOG_FILE"

    # Self-signed = its own chain/bundle. Duplicate so the file names
    # match what CFML expects when admin selects this cert in the UI.
    cp "$pem" "$chain"
    cp "$pem" "$bundle"

    # openssl req creates the key as 0600 by default; relax so non-root
    # container processes (nginx, postfix) can read the bind-mounted key.
    chmod 644 "$key" "$pem" "$chain" "$bundle"

    log "  + config/hermes/opt/hermes/ssl/${prefix}_hermes.pem"
    log "  + config/hermes/opt/hermes/ssl/${prefix}_hermes.chain.pem"
    log "  + config/hermes/opt/hermes/ssl/${prefix}_hermes.bundle.pem"
    log "  + config/hermes/opt/hermes/ssl/${prefix}_hermes.key"
    log "Self-signed bootstrap cert generated (CN=localhost)"
}

# ============================================================================
# DOVECOT MAIL-CRYPT KEY PLACEHOLDERS
# ============================================================================
# docker-compose bind-mounts /opt/hermes/keys/ec{pub,priv}key.pem as individual
# files into hermes_dovecot. On a fresh install these files don't exist, so
# Docker auto-creates EMPTY DIRECTORIES at those host paths and Dovecot dies
# with "Is a directory" reading the key. Touch empty placeholder files so the
# bind mounts resolve as files. The dovecot.conf template only emits the
# crypt_global_public_key_file directive when a real PEM key is present (the
# CFML inc/generate_dovecot_configuration.cfm checks for the BEGIN marker;
# install-time bootstrap render leaves the line empty), so an empty placeholder
# is safe. Admin generates the real keys via
# inc/generate_mail_crypt_keys.cfm when enabling mail encryption.
ensure_dovecot_key_placeholders() {
    header "Ensuring Dovecot Mail-Crypt Key Placeholders"

    local keys_dir="/opt/hermes/keys"
    local privkey="${keys_dir}/ecprivkey.pem"
    local pubkey="${keys_dir}/ecpubkey.pem"

    mkdir -p "$keys_dir"

    # If the path exists but is a directory (the empty-dir-trap state from a
    # failed prior install), remove it before touching the placeholder file.
    [[ -d "$privkey" ]] && rmdir "$privkey" 2>/dev/null
    [[ -d "$pubkey"  ]] && rmdir "$pubkey"  2>/dev/null

    if [[ ! -f "$privkey" ]]; then
        touch "$privkey"
        log "  + ${privkey} (empty placeholder)"
    else
        log "  = ${privkey} already exists (kept)"
    fi

    if [[ ! -f "$pubkey" ]]; then
        touch "$pubkey"
        log "  + ${pubkey} (empty placeholder)"
    else
        log "  = ${pubkey} already exists (kept)"
    fi
}

# ============================================================================
# RENDER DOVECOT dovecot.conf
# ============================================================================

generate_dovecot_config() {
    # Renders config/dovecot-2.4/conf/dovecot.conf from the canonical
    # template at config/hermes/opt/hermes/templates/dovecot.conf. The
    # Dovecot 2.4 template has 23 distinct placeholders covering:
    #   - DB connection (user/password)
    #   - Protocol list, SSL paths/cipher/min-protocol
    #   - Mail-crypt key curve + write algorithm
    #   - Compression (yes/no, method, level)
    #   - Quota warning thresholds (medium/high/critical) + trash quota
    #   - Connection limits (login_client_limit, max_userip)
    #   - Logging debug level
    #   - 3 conditional BLOCK placeholders (ACL config, ACL dict-map,
    #     shared namespace) — bootstrap leaves these empty; admin
    #     enables via UI which triggers CFML re-render with actual blocks.
    #
    # CFML generate_dovecot_configuration.cfm re-renders this from DB
    # values on Save. This bootstrap render uses sensible defaults so
    # Dovecot starts cleanly on first boot:
    #   - protocols: imap pop3 lmtp submission sieve
    #   - SSL: bootstrap_hermes.{pem,key} (same as nginx/postfix), TLSv1.2
    #   - Compression: off (no), method lz4 if admin turns it on
    #   - Quota warnings: 75 / 85 / 95 (trash 10)
    #   - Connection limits: 100 / 50
    #   - Logging: no debug
    #   - Mail-crypt: prime256v1 + ecdh-aes-256-gcm-sha256 (Hermes default)
    #   - ACL / shared namespace: disabled (empty blocks)
    #
    # Linked: #179
    header "Rendering Dovecot dovecot.conf"

    local template="${HERMES_ROOT}/config/hermes/opt/hermes/templates/dovecot.conf"
    local target_dir="${HERMES_ROOT}/config/dovecot-2.4/conf"
    local target="${target_dir}/dovecot.conf"

    if [[ ! -f "$template" ]]; then
        error "Dovecot canonical template missing: $template"
    fi

    local hermes_user hermes_pass
    hermes_user=$(cat "${CREDS_DIR}/hermes_username")
    hermes_pass=$(cat "${CREDS_DIR}/hermes_password")
    if [[ -z "$hermes_user" || -z "$hermes_pass" ]]; then
        error "hermes DB credentials missing in ${CREDS_DIR}/ -- run generate_secrets first"
    fi

    mkdir -p "$target_dir"
    [[ -e "$target" ]] && rm -rf "$target"

    # Note ordering: do whole-line BLOCK replacements first (sed `^...$` to
    # zap the entire line cleanly), then scalar substitutions. None of the
    # placeholder names are prefixes of each other so ordering is safe.
    sed \
        -e "s|^hermes_log_debug_line$||" \
        -e "s|^hermes_compress_level_line$||" \
        -e "s|^hermes_crypt_pubkey_line$||" \
        -e "s|^hermes_crypt_write_algorithm_line$|crypt_write_algorithm = ecdh-aes-256-gcm-sha256|" \
        -e "s|^[[:space:]]*hermes_acl_dict_block[[:space:]]*$||" \
        -e "s|^hermes_acl_config_block$||" \
        -e "s|^hermes_shared_namespace_block$||" \
        -e "s|hermes_db_username|${hermes_user}|g" \
        -e "s|hermes_db_password|${hermes_pass}|g" \
        -e "s|hermes_protocols|imap pop3 lmtp submission sieve|g" \
        -e "s|hermes_acl_enabled|no|g" \
        -e "s|hermes_mail_compress|no|g" \
        -e "s|hermes_compress_method|lz4|g" \
        -e "s|hermes_crypt_curve|prime256v1|g" \
        -e "s|hermes_quota_warn_critical|95|g" \
        -e "s|hermes_quota_warn_high|85|g" \
        -e "s|hermes_quota_warn_medium|75|g" \
        -e "s|hermes_trash_quota_pct|10|g" \
        -e "s|hermes_max_userip|50|g" \
        -e "s|hermes_login_client_limit|100|g" \
        -e "s|hermes_ssl_cipher_list|ECDHE+AESGCM:ECDHE+CHACHA20:DHE+AESGCM:DHE+CHACHA20:!aNULL:!MD5:!DSS|g" \
        -e "s|hermes_ssl_min_protocol|TLSv1.2|g" \
        -e "s|hermes_ssl_cert_path|/opt/hermes/ssl/bootstrap_hermes.pem|g" \
        -e "s|hermes_ssl_key_path|/opt/hermes/ssl/bootstrap_hermes.key|g" \
        "$template" > "$target"

    # Sanity check: only hermes_db_server / hermes_postfix_dkim (literal
    # container names, not placeholders) should remain as hermes_* tokens.
    local leftovers
    leftovers=$(grep -oE 'hermes_[a-z_]+' "$target" | sort -u \
        | grep -vE '^hermes_(db_server|postfix_dkim)$' || true)
    if [[ -n "$leftovers" ]]; then
        warn "Dovecot config has unsubstituted placeholders:"
        warn "$leftovers"
    fi

    log "  + config/dovecot-2.4/conf/dovecot.conf"
    log "Dovecot dovecot.conf rendered"
}

# ============================================================================
# RENDER DOVECOT auth_app_passwords.lua
# ============================================================================

generate_dovecot_lua_config() {
    # Renders config/dovecot-2.4/conf/auth_app_passwords.lua from the
    # canonical template at config/hermes/opt/hermes/templates/auth_app_passwords.lua.
    # Two placeholders only: hermes_db_username + hermes_db_password.
    # `hermes_db_server` is a literal container hostname (NOT a placeholder).
    #
    # This is the Dovecot 2.4 passdb lua script for #197 app passwords.
    # Without it Dovecot can't authenticate via app-password records.
    # rotate_db_credentials.sh handles cred rotation; this is the initial
    # bootstrap render. Linked: #179
    header "Rendering Dovecot auth_app_passwords.lua"

    local template="${HERMES_ROOT}/config/hermes/opt/hermes/templates/auth_app_passwords.lua"
    local target_dir="${HERMES_ROOT}/config/dovecot-2.4/conf"
    local target="${target_dir}/auth_app_passwords.lua"

    if [[ ! -f "$template" ]]; then
        error "Dovecot lua canonical template missing: $template"
    fi

    local hermes_user hermes_pass
    hermes_user=$(cat "${CREDS_DIR}/hermes_username")
    hermes_pass=$(cat "${CREDS_DIR}/hermes_password")
    if [[ -z "$hermes_user" || -z "$hermes_pass" ]]; then
        error "hermes DB credentials missing in ${CREDS_DIR}/ -- run generate_secrets first"
    fi

    mkdir -p "$target_dir"
    [[ -e "$target" ]] && rm -rf "$target"
    sed \
        -e "s|hermes_db_username|${hermes_user}|g" \
        -e "s|hermes_db_password|${hermes_pass}|g" \
        "$template" > "$target"
    log "  + config/dovecot-2.4/conf/auth_app_passwords.lua"
    log "Dovecot auth_app_passwords.lua rendered"
}

# ============================================================================
# CREATE DATABASES
# ============================================================================

create_databases() {
    # ------------------------------------------------------------------
    # Creates the 6 databases Hermes needs + per-db users + grants, then
    # imports schemas/seeds for the four that ship them:
    #
    #   hermes     -- needs schema + sanitized seed data (config/database/hermes_install.sql)
    #   opendmarc  -- needs empty schema (config/database/opendmarc_schema.sql)
    #   Syslog     -- needs empty schema (config/database/syslog_schema.sql)
    #   djigzo     -- needs canonical CipherMail schema (config/database/djigzo_schema.sql,
    #                 extracted from /usr/share/djigzo/conf/database/sql/djigzo.mysql.sql
    #                 in the djigzo .deb). Hibernate's hbm2ddl.auto=validate refuses
    #                 to bootstrap, so the schema must be present before CipherMail starts.
    #   authelia   -- Authelia auto-creates its tables on first startup
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
    NEXTCLOUD_DB_USER=$(cat "${CREDS_DIR}/nextcloud_mysql_username")
    NEXTCLOUD_DB_PASS=$(cat "${CREDS_DIR}/nextcloud_mysql_password")

    # ---- Wait for MariaDB to be ready ----
    log "Waiting for MariaDB to be ready..."
    for i in {1..30}; do
        if docker exec hermes_db_server mysqladmin ping -u root --silent 2>/dev/null; then
            log "MariaDB is ready"
            break
        fi
        if [[ $i -eq 30 ]]; then
            error "MariaDB did not become ready in time"
        fi
        sleep 2
    done

    # ---- Verify we can talk to MariaDB as root via socket auth ----
    # NOTE: We use unix_socket auth (no -p) because LinuxServer's mariadb
    # image creates root@localhost / root@127.0.0.1 / root@<container-host>
    # with the unix_socket plugin (NOT mysql_native_password). They reject
    # password-bearing connections. The MYSQL_ROOT_PASSWORD env var set
    # via FILE__ only configures root@'%' (the remote-access entry) with
    # mysql_native_password. Since we always connect via `docker exec`
    # (running as OS root inside the container -> unix socket auth), we
    # never need to send a password from the install script.
    #
    # The smoke test below catches the case where MariaDB isn't ready yet
    # or socket auth somehow doesn't map root -> root (extremely unusual).
    if ! docker exec hermes_db_server mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
        error "MariaDB root socket auth failed. Container may not be fully started yet, or LinuxServer's init didn't complete. Try: docker logs hermes_db_server"
    fi
    log "MariaDB root authentication verified (unix_socket plugin via docker exec)"

    # NB: LinuxServer's mariadb init has already created root@'%' with
    # the password from MYSQL_ROOT_PASSWORD (verified via mysql.user
    # plugin column). No need for us to ALTER it.

    # ---- Create one DB + user + grants ----
    # NOTE: backtick-quoting `Syslog` is REQUIRED — case-sensitive on Linux
    # and rsyslog's mysql template writes to exactly that mixed-case name.
    _create_db_user() {
        local dbname="$1"
        local user="$2"
        local pass="$3"
        local collation="${4:-utf8mb4_unicode_ci}"

        log "Creating database '${dbname}' (user '${user}')..."
        # `CREATE USER IF NOT EXISTS` is a NO-OP if the user exists, which
        # means stale users from a prior install (whose MariaDB data
        # survived an incomplete wipe) keep their OLD password — and the
        # current install's NEW password silently fails to authenticate.
        # The ALTER USER below force-syncs the password whether the user is
        # being created fresh or already existed. Idempotent + makes the
        # whole step safe to re-run on a partially-stale MariaDB volume.
        docker exec hermes_db_server mysql -u root -e "
            CREATE DATABASE IF NOT EXISTS \`${dbname}\` CHARACTER SET utf8mb4 COLLATE ${collation};
            CREATE USER IF NOT EXISTS '${user}'@'%' IDENTIFIED BY '${pass}';
            ALTER USER '${user}'@'%' IDENTIFIED BY '${pass}';
            GRANT ALL PRIVILEGES ON \`${dbname}\`.* TO '${user}'@'%';
        " 2>> "$LOG_FILE"
    }

    _create_db_user hermes    "$HERMES_DB_USER"     "$HERMES_DB_PASS"
    _create_db_user authelia  "$AUTHELIA_DB_USER"   "$AUTHELIA_DB_PASS"   utf8mb4_unicode_520_ci
    _create_db_user opendmarc "$OPENDMARC_DB_USER"  "$OPENDMARC_DB_PASS"
    _create_db_user Syslog    "$SYSLOG_DB_USER"     "$SYSLOG_DB_PASS"
    _create_db_user djigzo    "$CIPHERMAIL_DB_USER" "$CIPHERMAIL_DB_PASS"
    _create_db_user nextcloud "$NEXTCLOUD_DB_USER"  "$NEXTCLOUD_DB_PASS"

    docker exec hermes_db_server mysql -u root -e "FLUSH PRIVILEGES;" 2>> "$LOG_FILE"
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
        if ! docker exec -i hermes_db_server mysql -u root "$target_db" \
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

    # ---- djigzo schema for CipherMail ----
    # hibernate.mysql.cfg.HERMES sets hbm2ddl.auto=validate (not create/update),
    # so Hibernate refuses to bootstrap. Import the canonical schema that
    # ships with the djigzo .deb at /usr/share/djigzo/conf/database/sql/
    # djigzo.mysql.sql — extracted at repo-prep time to config/database/.
    _import_sql \
        "${HERMES_ROOT}/config/database/djigzo_schema.sql" \
        "djigzo" \
        "djigzo_schema.sql"

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

    local pass hermes_hostname server_name server_domain postfix_hostname
    pass=$(cat "${CREDS_DIR}/mysql_root_password")
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    hermes_hostname="${hermes_hostname:-${ip}}"
    # Bare-IP HERMES_HOSTNAME (install default before admin sets a real FQDN)
    # would split into nonsense like 192 / 168.30.18 and would also fail
    # postfix's valid_hostname() check on myhostname (must be FQDN-form).
    # Substitute the Hermes-canonical placeholder per
    # [[feedback-demo-data-domain]]. Mirrored in generate_postfix_main_cf
    # and generate_amavis_50user_config so all three landings agree.
    # Admin changes via System Settings UI once a real hostname is configured.
    if [[ "$hermes_hostname" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        server_name="smtp"
        server_domain="domain.tld"
        postfix_hostname="smtp.domain.tld"
    else
        server_name="${hermes_hostname%%.*}"
        server_domain="${hermes_hostname#*.}"
        postfix_hostname="$hermes_hostname"
    fi

    # server_ip (module='network') — view_server_setup.cfm reads this row.
    # Pre-correction: rule used module='console' (typo), missed the row.
    log "Writing parameters2.server_ip = ${ip} (module=network)..."
    docker exec hermes_db_server mysql -u root hermes -e "
        UPDATE parameters2 SET value2='${ip}', active='1', applied='2'
         WHERE parameter='server_ip' AND module='network';
    " 2>>"$LOG_FILE"

    # console.host (module='console') — what the admin UI uses as its
    # public hostname (CONSOLE_HOST in .env). Set to IP initially; admin
    # changes to FQDN via the Console Settings page once DNS is in place.
    log "Writing parameters2.console.host = ${ip}..."
    docker exec hermes_db_server mysql -u root hermes -e "
        UPDATE parameters2 SET value2='${ip}', active='1', applied='2'
         WHERE parameter='console.host' AND module='console';
    " 2>>"$LOG_FILE"

    # server_name + server_domain (module='network') — split halves of the
    # mail hostname. Used by Postfix main.cf myhostname/myorigin and by
    # other config generators (modify_hosts.cfm etc.).
    log "Writing parameters2.server_name = ${server_name} / server_domain = ${server_domain}..."
    docker exec hermes_db_server mysql -u root hermes -e "
        UPDATE parameters2 SET value2='${server_name}'   WHERE parameter='server_name'   AND module='network';
        UPDATE parameters2 SET value2='${server_domain}' WHERE parameter='server_domain' AND module='network';
    " 2>>"$LOG_FILE"

    # Postfix myorigin + myhostname child rows in parameters table.
    # view_server_setup.cfm reads these; generate_postfix_configuration.cfm
    # postconf's main.cf from these values on Save. Use postfix_hostname
    # (sanitized above) -- bare-IP would fail postfix's valid_hostname().
    log "Writing parameters.myorigin = ${server_domain} / myhostname = ${postfix_hostname}..."
    docker exec hermes_db_server mysql -u root hermes -e "
        UPDATE parameters SET parameter='${server_domain}'
         WHERE parent_name='myorigin' AND child=1 AND module='postfix' AND conf_file='main.cf';
        UPDATE parameters SET parameter='${postfix_hostname}'
         WHERE parent_name='myhostname' AND child=1 AND module='postfix' AND conf_file='main.cf';
    " 2>>"$LOG_FILE"

    # Unbound forwarders: align the DB to match what render_unbound_forward_conf()
    # wrote to forward.conf in phase 1. Without this, the UI (System > DNS
    # Resolver) sees the seeded recursive default (forwarding.enabled='no')
    # and the seeded public-resolver list, and on the FIRST save will
    # clobber the bootstrap forward.conf back to recursive mode -- breaking
    # everything that needed DNS.
    #
    # The CFML page that re-renders forward.conf
    # (inc/generate_unbound_forward_conf.cfm) reads:
    #   - parameters2 WHERE module='unbound' AND parameter='forwarding.enabled'
    #   - dns_forwarders WHERE enabled=1 ORDER BY sort_order
    # so we set both to mirror the admin's phase-1 choice.
    local dns_forwarders_csv
    dns_forwarders_csv=$(state_get_value "03b-dns-forwarders-configured")
    if [[ -n "$dns_forwarders_csv" ]]; then
        log "Writing parameters2.forwarding.enabled = yes (module=unbound)..."
        docker exec hermes_db_server mysql -u root hermes -e "
            UPDATE parameters2 SET value2='yes', applied='1'
             WHERE module='unbound' AND parameter='forwarding.enabled';
        " 2>>"$LOG_FILE"

        log "Replacing dns_forwarders seed with admin's choice: ${dns_forwarders_csv}"
        # Build a multi-INSERT statement; truncate first so seeded defaults
        # don't linger alongside admin's entries.
        local truncate_sql="TRUNCATE TABLE dns_forwarders;"
        local insert_sql=""
        local sort=1 fwd
        IFS=',' read -ra fwd_list <<< "$dns_forwarders_csv"
        for fwd in "${fwd_list[@]}"; do
            fwd="$(echo "$fwd" | xargs)"
            [[ -z "$fwd" ]] && continue
            insert_sql+="INSERT INTO dns_forwarders (server, port, tls, enabled, sort_order) VALUES ('${fwd}', 53, 0, 1, ${sort});"
            sort=$((sort + 1))
        done
        docker exec hermes_db_server mysql -u root hermes -e "${truncate_sql}${insert_sql}" 2>>"$LOG_FILE"
    else
        warn "No DNS forwarder choice in state -- leaving DB seeded defaults"
    fi

    log "Install-specific values seeded"
}

# ============================================================================
# REGISTER BOOTSTRAP CERTIFICATE IN DATABASE
# ============================================================================

register_bootstrap_cert_in_db() {
    # Registers the self-signed bootstrap cert (generated by
    # generate_self_signed_cert) in the `system_certificates` table so it
    # appears in the System Certificates admin page, then updates the three
    # cert-assignment rows in parameters2 (console / smtp / mail) to point
    # at this cert id. Admin sees a working "System Bootstrap Certificate"
    # selected for all three roles on first login; replaces via Upload Cert
    # in the UI.
    #
    # Phase 2 step (needs DB up). State-guarded against duplicate INSERTs.
    header "Registering Bootstrap Certificate in Database"

    local pass cert_pem prefix friendly_name
    pass=$(cat "${CREDS_DIR}/mysql_root_password")
    prefix="bootstrap"
    friendly_name="System Bootstrap Certificate"
    cert_pem="${HERMES_ROOT}/config/hermes/opt/hermes/ssl/${prefix}_hermes.pem"

    if [[ ! -f "$cert_pem" ]]; then
        warn "Bootstrap cert file missing: $cert_pem -- skipping DB registration"
        return 0
    fi

    # Idempotency: skip INSERT if a row with this friendly_name already exists.
    local existing_id
    existing_id=$(docker exec hermes_db_server mysql -u root -N -s hermes -e "
        SELECT id FROM system_certificates WHERE friendly_name='${friendly_name}' LIMIT 1;
    " 2>>"$LOG_FILE")

    if [[ -z "$existing_id" ]]; then
        # Pull metadata from the cert with openssl.
        local subject issuer serial fingerprint startdate enddate
        subject=$(openssl x509 -in "$cert_pem" -noout -subject -nameopt RFC2253 2>/dev/null | sed 's/^subject=//')
        issuer=$(openssl x509 -in "$cert_pem" -noout -issuer -nameopt RFC2253 2>/dev/null | sed 's/^issuer=//')
        serial=$(openssl x509 -in "$cert_pem" -noout -serial 2>/dev/null | sed 's/^serial=//')
        fingerprint=$(openssl x509 -in "$cert_pem" -noout -fingerprint -sha256 2>/dev/null | sed 's/^.*=//')
        startdate=$(openssl x509 -in "$cert_pem" -noout -startdate 2>/dev/null | sed 's/^notBefore=//')
        enddate=$(openssl x509 -in "$cert_pem" -noout -enddate 2>/dev/null | sed 's/^notAfter=//')

        log "Inserting system_certificates row (type='Generated', file_name='${prefix}')..."
        docker exec hermes_db_server mysql -u root hermes -e "
            INSERT INTO system_certificates
              (type, subject, issuer, serial, fingerprint, startdate, enddate, file_name, friendly_name)
            VALUES
              ('Generated',
               '${subject}',
               '${issuer}',
               '${serial}',
               '${fingerprint}',
               '${startdate}',
               '${enddate}',
               '${prefix}',
               '${friendly_name}');
        " 2>>"$LOG_FILE"

        existing_id=$(docker exec hermes_db_server mysql -u root -N -s hermes -e "
            SELECT id FROM system_certificates WHERE friendly_name='${friendly_name}' LIMIT 1;
        " 2>>"$LOG_FILE")
    else
        log "  = system_certificates row already exists (id=${existing_id})"
    fi

    if [[ -z "$existing_id" ]]; then
        warn "Could not determine bootstrap cert id -- skipping parameters2 assignment"
        return 0
    fi

    # Point all three role assignments at the bootstrap cert.
    log "Pointing console.certificate / smtp.certificate / mail.certificate at id=${existing_id}..."
    docker exec hermes_db_server mysql -u root hermes -e "
        UPDATE parameters2 SET value2='${existing_id}' WHERE parameter='console.certificate' AND module='console';
        UPDATE parameters2 SET value2='${existing_id}' WHERE parameter='smtp.certificate'    AND module='certificates';
        UPDATE parameters2 SET value2='${existing_id}' WHERE parameter='mail.certificate'    AND module='certificates';
    " 2>>"$LOG_FILE"

    log "Bootstrap cert registered (id=${existing_id})"
}

# ============================================================================
# CONFIGURE CIPHERMAIL USER PORTAL URL
# ============================================================================

configure_ciphermail_portal_url() {
    # Sets Ciphermail's user.portal.baseURL global property so:
    #   1. The admin UI's "CipherMail" link resolves (without this property,
    #      Ciphermail rejects portal-relative requests).
    #   2. Encryption notifications sent to external recipients carry a
    #      working URL pattern (https://<host>/web/portal/<token>).
    #
    # Mirrors the legacy installer's step at line ~1268. Runs in phase 2
    # after the ciphermail container is up. Idempotent: re-running just
    # overwrites the property to the same value.
    header "Configuring Ciphermail User Portal URL"

    local hermes_hostname portal_url
    hermes_hostname=$(grep -E '^HERMES_HOSTNAME=' "${HERMES_ROOT}/.env" 2>/dev/null \
        | cut -d= -f2- | tr -d '"' | tr -d "'")
    if [[ -z "$hermes_hostname" ]]; then
        warn "HERMES_HOSTNAME missing from .env -- skipping ciphermail portal URL"
        return 0
    fi
    portal_url="https://${hermes_hostname}/web/portal"

    log "Setting user.portal.baseURL = ${portal_url} (global)..."
    # CipherMail's Tomcat + Spring + Hibernate startup takes 30-90s on fresh
    # installs (especially first boot when Hibernate initializes against the
    # freshly-imported djigzo schema). Retry the CLITool call with backoff
    # rather than failing the install -- the property must be set or the
    # admin "CipherMail" link breaks and encryption-notification URLs are
    # malformed.
    local attempts=0
    local max_attempts=20   # 20 * 5s = 100s total
    while (( attempts < max_attempts )); do
        if docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' \
                mitm.application.djigzo.tools.CLITool \
                --set-property user.portal.baseURL --value "$portal_url" --global \
                >>"$LOG_FILE" 2>&1; then
            log "Ciphermail user.portal.baseURL configured"
            return 0
        fi
        attempts=$((attempts + 1))
        if (( attempts < max_attempts )); then
            sleep 5
        fi
    done
    warn "Failed to set ciphermail user.portal.baseURL after ${max_attempts} attempts -- run --init-db again once hermes_ciphermail is fully started"
    return 0
}

# ============================================================================
# WRITE INSTALL SUMMARY
# ============================================================================

write_install_summary() {
    # Writes a single-file credential + access summary to /opt/hermes/INSTALL_SUMMARY.txt
    # Also prints a condensed version to the console. This is the last
    # user-facing output of a successful install -- admins MUST save the
    # contents before logging out, then they can delete the file or
    # tighten its permissions as they see fit.
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
Console URL:        https://${ip}/admin/   (self-signed cert; browser will warn)
Admin username:     $(state_get_value "04-admin-username" 2>/dev/null || echo "admin")
Admin password:     $(cat "${CREDS_DIR}/ldap_admin_password" 2>/dev/null || echo "<not-generated>")
                    (this is the LDAP admin password — Authelia authenticates
                     against LDAP, so the same password unlocks the admin UI)

MARIADB
-------
Root password:      $(cat "${CREDS_DIR}/mysql_root_password" 2>/dev/null || echo "<not-generated>")
hermes user/pw:     $(cat "${CREDS_DIR}/hermes_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/hermes_password" 2>/dev/null || echo "?")
opendmarc user/pw:  $(cat "${CREDS_DIR}/opendmarc_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/opendmarc_password" 2>/dev/null || echo "?")
syslog user/pw:     $(cat "${CREDS_DIR}/syslog_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/syslog_password" 2>/dev/null || echo "?")
ciphermail user/pw: $(cat "${CREDS_DIR}/ciphermail_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/ciphermail_password" 2>/dev/null || echo "?")
nextcloud user/pw:  $(cat "${CREDS_DIR}/nextcloud_mysql_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/nextcloud_mysql_password" 2>/dev/null || echo "?")

AUTHELIA
--------
DB user/pw:         $(cat "${SECRETS_DIR}/authelia_username" 2>/dev/null || echo "?") / $(cat "${SECRETS_DIR}/authelia_password" 2>/dev/null || echo "?")
JWT secret:         $(cat "${SECRETS_DIR}/authelia_jwt_secret" 2>/dev/null || echo "<not-generated>")
Session secret:     $(cat "${SECRETS_DIR}/authelia_session_secret" 2>/dev/null || echo "<not-generated>")
Storage enc key:    $(cat "${SECRETS_DIR}/authelia_storage_encryption_key_file" 2>/dev/null || echo "<not-generated>")

LDAP
----
Admin password:     $(cat "${CREDS_DIR}/ldap_admin_password" 2>/dev/null || echo "<not-generated>")
                    (bind DN: cn=admin,dc=hermes,dc=local — full LDAP admin
                     access; also used as the admin UI password — see ACCESS)
Service password:   $(cat "${CREDS_DIR}/ldap_service_password" 2>/dev/null || echo "<not-generated>")
                    (bind DN: cn=hermes-ldap-user,dc=hermes,dc=local —
                     read-only service account; used by Authelia and CFML
                     to look up users during authentication; NOT for human
                     login)

NEXTCLOUD
---------
Admin user/pw:      $(cat "${CREDS_DIR}/nextcloud_admin_username" 2>/dev/null || echo "?") / $(cat "${CREDS_DIR}/nextcloud_admin_password" 2>/dev/null || echo "?")
OIDC secret:        $(cat "${CREDS_DIR}/nextcloud_oidc_secret" 2>/dev/null || echo "<not-generated>")
Redis password:     $(cat "${CREDS_DIR}/nextcloud_redis_password" 2>/dev/null || echo "<not-generated>")

NEXT STEPS (in admin UI)
------------------------
1. Log in at https://${ip}/admin/   (self-signed cert — accept browser warning)
2. System  -> Console Settings: change console host from IP to FQDN if needed
3. System  -> SSL Certificates: install your real cert (Let's Encrypt or imported)
4. Email Server -> Domains: add your first domain
5. DNS records to set up at your registrar: A/AAAA, MX, SPF, DKIM, DMARC

RECOVERY
--------
If https://${ip}/admin/ does NOT load, the most likely cause is that the host
IP you entered was wrong. Re-run the installer and pick option [2] (WIPE) to
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

    # Console summary — condensed
    echo ""
    echo "================================================================================"
    echo "                INSTALL COMPLETE   -   SAVE THESE NOW"
    echo "================================================================================"
    echo "Console URL:      https://${ip}/admin/   (self-signed; expect browser warning)"
    echo "Admin username:   $(state_get_value "04-admin-username" 2>/dev/null || echo "admin")"
    echo "Admin password:   $(cat "${CREDS_DIR}/ldap_admin_password" 2>/dev/null || echo "<see INSTALL_SUMMARY.txt>")"
    echo ""
    echo "Full credential summary written to:"
    echo "  ${summary}"
    echo ""
    echo "To view it:"
    echo "  sudo cat ${summary}"
    echo ""
    echo "If https://${ip}/admin/ does NOT load, the IP was wrong. Re-run this"
    echo "installer and select [2] WIPE to start over."
    echo ""
    echo "================================================================================"
    echo "                NOTES ON FILE PERMISSIONS"
    echo "================================================================================"
    echo "Credential files were written with default permissions (0644 files in 0755"
    echo "directories) so non-root container processes can read bind-mounted Docker"
    echo "secrets. On a dedicated single-purpose Hermes host this is fine."
    echo ""
    echo "If your security policy requires tightening, suggested commands:"
    echo ""
    echo "  # Lock the credentials + keys directories to root-only (containers still"
    echo "  # work — the Docker daemon traverses these as root):"
    echo "  sudo chmod 700 ${HERMES_ROOT}/config/hermes/opt/hermes/creds"
    echo "  sudo chmod 700 ${HERMES_ROOT}/config/hermes/opt/hermes/keys"
    echo ""
    echo "  # Lock the install summary (or delete it after saving its contents):"
    echo "  sudo chmod 600 ${summary}"
    echo "  # ... or:"
    echo "  sudo rm ${summary}"
    echo ""
    echo "  WARNING: do NOT chmod the individual files inside creds/ or keys/ to 0600."
    echo "  Container processes (Nextcloud PHP-FPM as www-data, etc.) need read access"
    echo "  to the bind-mounted Docker secrets. Tightening the parent directory mode"
    echo "  to 0700 is the safe lockdown — it blocks host traversal but the daemon"
    echo "  still mounts the files into containers correctly."
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

    # Use ldapi:// + SASL EXTERNAL (matches Docker/openldap entrypoint and
    # config/ldap/hermes/add_remoteauth_overlay.sh — the canonical Hermes
    # pattern). docker exec runs as root inside the container, the socket
    # bind maps to root via SASL EXTERNAL, and slapd's olcAccess grants
    # that mapping admin privilege. No password needed.
    local LDAPI_URI="ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi"

    # Wait for OpenLDAP to be ready (container is named hermes_ldap per compose).
    # Probe by exit code: root DSE search succeeds (exit 0) only when slapd
    # is accepting binds. Earlier versions grepped for `namingContexts` but
    # that's an operational attribute -- not returned by default and the
    # grep always failed regardless of slapd state.
    log "Waiting for OpenLDAP to be ready..."
    for i in {1..30}; do
        if docker exec hermes_ldap ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "" -s base "(objectClass=*)" >/dev/null 2>&1; then
            log "OpenLDAP is ready"
            break
        fi
        if [[ $i -eq 30 ]]; then
            error "OpenLDAP did not become ready in time"
        fi
        sleep 2
    done

    # Check if base structure already exists (SASL EXTERNAL via socket; no
    # cn=admin bind needed because root-via-socket already has admin rights).
    # ldapsearch returns 0 if entry exists, 32 (No such object) if not.
    if docker exec hermes_ldap ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "ou=users,dc=hermes,dc=local" -s base "(objectClass=*)" >/dev/null 2>&1; then
        log "LDAP base structure already exists"
        return
    fi

    log "Creating LDAP base structure..."
    # The base structure should be created by the LDAP container's seed data
    # This is a placeholder for any additional initialization

    log "LDAP initialization completed"
}

# ============================================================================
# PHASE 2: POST-CONTAINER-UP INITIALIZATION
# ============================================================================
# All steps that require the docker compose stack to be running. Called
# inline from main() right after `docker compose up -d`, and also exposed via
# the `--init-db` CLI flag as a recovery escape hatch for re-running phase 2
# without going through phase-1 prompts (state guards skip completed steps).

run_phase2_db_init() {
    touch "$LOG_FILE"
    log "Phase 2 (post-container) initialization started at $(date)"

    # Resolve HERMES_HOST_IP from state (set during phase 1).
    if [[ -z "${HERMES_HOST_IP:-}" ]]; then
        HERMES_HOST_IP=$(state_get_value "03-host-ip-confirmed")
        export HERMES_HOST_IP
    fi
    if [[ -z "$HERMES_HOST_IP" ]]; then
        error "Host IP not in state. Run phase 1 first: ./install_hermes_docker.sh"
    fi
    log "Resolved host IP from state: ${HERMES_HOST_IP}"

    # Fail fast if the container DNS path is broken. Without this check
    # the user hits opaque downstream failures: commandbox can't pull
    # Lucee, ofelia can't resolve hermes_postfix_dkim, etc. Not
    # state-guarded -- DNS health can change between re-runs.
    preflight_dns_check

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

    if state_is_done "07b-bootstrap-cert-registered"; then
        log "Skip: bootstrap cert already registered in DB"
    else
        register_bootstrap_cert_in_db
        state_mark_done "07b-bootstrap-cert-registered"
    fi

    if state_is_done "07c-ciphermail-portal-configured"; then
        log "Skip: ciphermail portal URL already configured"
    else
        configure_ciphermail_portal_url
        state_mark_done "07c-ciphermail-portal-configured"
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

        # Wait for Nextcloud's auto-install to complete. The official
        # nextcloud:apache image runs `occ maintenance:install` on first
        # boot when admin creds (NEXTCLOUD_ADMIN_USER_FILE +
        # NEXTCLOUD_ADMIN_PASSWORD_FILE) are present as Docker secrets.
        # That takes 30-90s after the container starts.
        log "  Waiting for Nextcloud auto-install to complete (up to 2 min)..."
        NC_READY=0
        for i in $(seq 1 24); do
            if docker exec -u www-data hermes_nextcloud \
                   php /var/www/html/occ status 2>&1 | grep -q "installed: true"; then
                log "    Nextcloud is installed (after ${i} attempt(s))"
                NC_READY=1
                break
            fi
            sleep 5
        done

        if [[ $NC_READY -eq 0 ]]; then
            warn "Nextcloud did not finish auto-installing within 120s -- skipping post-install configuration"
            warn "Re-run --init-db once Nextcloud is ready; state-guard will skip completed"
            warn "steps and retry the Nextcloud block."
            NC_SKIP=1
        fi
    fi

    if [[ "$NC_SKIP" -eq 0 ]]; then
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

        # Enable core apps that ship with NC.
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

        # Theming
        log "  Configuring Nextcloud theming..."
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config name "Hermes SEG" >> "$LOG_FILE" 2>&1 || true
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config logo /img/hermes_logo_new_orange2.png >> "$LOG_FILE" 2>&1 || true
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config slogan "Secure Email Gateway and Server" >> "$LOG_FILE" 2>&1 || true
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config primary_color '#343A40' >> "$LOG_FILE" 2>&1 || true
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config background_color '#343A40' >> "$LOG_FILE" 2>&1 || true
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config background --reset >> "$LOG_FILE" 2>&1 || true
        if [[ -n "$NC_HOSTNAME" ]]; then
            docker exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config url "https://${NC_HOSTNAME}" >> "$LOG_FILE" 2>&1 || true
        fi
        log "  Theming configured"

        # Cross-domain isolation. Every occ call wrapped with `|| log "WARNING..."`
        # so a transient failure on any single one doesn't kill the install
        # under set -e (defense-in-depth on top of the wait-for-installed loop).
        log "  Configuring Nextcloud cross-domain isolation..."
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
            config:app:set core shareapi_allow_share_dialog_user_enumeration --value=yes >> "$LOG_FILE" 2>&1 \
            || log "  WARNING: Failed to set shareapi_allow_share_dialog_user_enumeration"
        docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
            config:app:set core shareapi_restrict_user_enumeration_to_group --value=yes >> "$LOG_FILE" 2>&1 \
            || log "  WARNING: Failed to set shareapi_restrict_user_enumeration_to_group"
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
    log "Phase 2 (post-container) initialization completed"
    write_install_summary
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

    # EULA — Pro features are covered by a separate end-user license agreement.
    # State-guarded so it's a one-time consent per install (a fresh `--wipe`
    # clears state and re-prompts). Mirrors the legacy installer's step 1.
    if state_is_done "00-eula-accepted"; then
        log "Skip: EULA already accepted"
    else
        echo ""
        echo "============================================================"
        echo " End-User License Agreement"
        echo "============================================================"
        echo ""
        echo "Parts of this program are covered by the Hermes Secure Email"
        echo "Gateway Pro EULA, which can be found at:"
        echo ""
        echo "  https://docs.hermesseg.io/books/hermes-secure-email-gateway-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula"
        echo ""
        echo "You must agree to the terms set forth by the EULA before"
        echo "continuing."
        echo ""
        echo "  [1] Accept the EULA and continue"
        echo "  [2] Decline and exit (default)"
        echo ""
        local eula_choice
        read -p "Choice [2]: " eula_choice
        case "${eula_choice:-2}" in
            1) ;;
            *) echo "EULA not accepted. Installation cancelled."; exit 0 ;;
        esac
        state_mark_done "00-eula-accepted"
        log "EULA accepted"
    fi

    # Confirm installation. The single-session flow does host-side prep,
    # then `docker compose up -d`, then post-container DB init -- all in one
    # go. On a fresh host that's 10-30 minutes total (mostly image pulls).
    echo ""
    echo "This will run the full Hermes SEG install in one session:"
    echo "  1. Host-side config rendering + secrets (a few seconds)"
    echo "  2. docker compose up -d        (5-15 min on fresh host: image pulls)"
    echo "  3. Database + LDAP + Nextcloud initialization (~2 min)"
    echo ""
    read -p "Continue? (y/N): " CONFIRM
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
        prompt_mount_points
        state_mark_done "02-mounts-configured"
    fi

    # Always provision subdirs -- fast, idempotent, recovers from any
    # external wipe of ${DATA_MOUNT}/* between runs. The prompts above are
    # state-guarded, but mkdir/touch are not. See
    # [[feedback-install-script-patterns]] rule #3.
    provision_mount_dirs

    if state_is_done "03-host-ip-confirmed"; then
        HERMES_HOST_IP=$(state_get_value "03-host-ip-confirmed")
        export HERMES_HOST_IP
        log "Skip: host IP already confirmed (${HERMES_HOST_IP})"
    else
        prompt_host_ip
        state_set_value "03-host-ip-confirmed" "$HERMES_HOST_IP"
        state_mark_done "03-host-ip-confirmed"
    fi

    if state_is_done "03b-dns-forwarders-configured"; then
        log "Skip: DNS forwarders already configured ($(state_get_value 03b-dns-forwarders-configured))"
    else
        prompt_dns_forwarders
        state_mark_done "03b-dns-forwarders-configured"
    fi

    # Always re-render forward.conf -- the prompt is state-guarded but the
    # file is a Docker bind-mount source, so it must exist on every run.
    render_unbound_forward_conf

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
    generate_authelia_config
    generate_self_signed_cert
    generate_postfix_configs
    generate_nginx_config
    generate_spamassassin_config
    generate_opendkim_tables
    generate_commandbox_password_file
    generate_mailname_config
    ensure_dovecot_key_placeholders
    generate_dovecot_config
    generate_dovecot_lua_config

    log "Phase 1 (host-side prep) completed"

    # ---- Phase 2: bring up the containers and run the post-container steps
    # in the same session. The old flow stopped here and made the admin run
    # `docker compose up -d` + `./install_hermes_docker.sh --init-db` by hand;
    # that boundary was disorienting on a fresh install. Now it's one flow.
    # The --init-db CLI flag is still wired up as a recovery escape hatch.
    header "Starting containers"
    echo "Running: docker compose up -d"
    echo "(first run on a fresh host pulls ~10 images -- can take 5-15 minutes)"
    echo ""
    if ! ( cd "$HERMES_ROOT" && docker compose up -d 2>&1 | tee -a "$LOG_FILE" ); then
        error "docker compose up -d failed. Inspect ${LOG_FILE}, fix the issue, then re-run ./install_hermes_docker.sh (state guards will resume where you left off)."
    fi
    log "Containers started"

    run_phase2_db_init
}

# ============================================================================
# COMMAND LINE HANDLING
# ============================================================================

case "${1:-}" in
    --init-db)
        # Recovery escape hatch: re-run phase 2 (post-container init) only.
        # Useful when phase 1 prep + `docker compose up` already happened but
        # phase 2 partially failed -- state guards skip completed steps.
        # The single-session main() flow no longer requires this flag; it's
        # kept for manual reruns and CI-style invocations.
        run_phase2_db_init
        ;;
    --generate-secrets)
        # Only generate secrets (and re-render anything that derives from them)
        touch "$LOG_FILE"
        generate_secrets
        generate_rsyslog_configs
        generate_amavis_50user_config
        generate_ciphermail_hibernate_configs
        generate_authelia_config
        generate_self_signed_cert
        generate_postfix_configs
        generate_nginx_config
        generate_spamassassin_config
        generate_opendkim_tables
        generate_commandbox_password_file
        generate_mailname_config
        generate_dovecot_config
        generate_dovecot_lua_config
        ;;
    --configure-storage)
        # Configure storage mount points
        touch "$LOG_FILE"
        log "Storage configuration started at $(date)"
        prompt_mount_points
        provision_mount_dirs
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
            echo "Storage paths:"
            echo "  System data:    ${DATA_MOUNT:-not set}"
            echo "  Email storage:  ${VMAIL_MOUNT:-not set}"
            if [[ "${ENABLE_NEXTCLOUD}" == "true" ]]; then
                echo "  Nextcloud files: ${FILES_MOUNT:-not set}"
            else
                echo "  Nextcloud files: disabled"
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
        echo "  - Rendered service configs (rsyslog x4, amavis 50-user,"
        echo "    ciphermail hibernate x2, authelia configuration.yml,"
        echo "    postfix main.cf + mysql-*.cf, nginx hermes-ssl.conf,"
        echo "    SpamAssassin local.cf, OpenDKIM tables, CommandBox"
        echo "    password.txt)"
        echo ""
        echo "After confirming, you will get a SECOND prompt asking whether"
        echo "to also wipe the contents of user-mounted storage (DATA_MOUNT"
        echo "/ VMAIL_MOUNT / FILES_MOUNT). Required for fresh-install"
        echo "testing; skip if you want to preserve mail/files."
        echo ""
        echo "  [1] Cancel (default)"
        echo "  [2] Yes, wipe everything"
        echo ""
        read -p "Choice [1]: " confirm
        case "${confirm:-1}" in
            2)
                wipe_install
                echo "Wipe complete. Re-run the installer to start fresh."
                ;;
            *)
                echo "Wipe not confirmed. Exiting."
                exit 1
                ;;
        esac
        ;;
    --help|-h)
        echo "Hermes SEG Docker Installation Script"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Installation:"
        echo "  (none)               Run full installation (host prep + docker compose up + DB init)"
        echo ""
        echo "Configuration:"
        echo "  --configure-storage  Configure storage mount points"
        echo "  --generate-override  Regenerate docker-compose.override.yml"
        echo "  --generate-secrets   Generate secrets only"
        echo "  --show-config        Display current configuration"
        echo ""
        echo "Recovery:"
        echo "  --init-db            Re-run phase-2 (post-container) initialization only."
        echo "                       Useful if containers are already up but DB init"
        echo "                       failed partway through; state guards skip done steps."
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
        echo "  ./install_hermes_docker.sh"
        echo "  (single-session: host prep -> docker compose up -d -> DB init)"
        echo ""
        ;;
    "")
        main
        ;;
    *)
        error "Unknown option: $1. Use --help for usage."
        ;;
esac
