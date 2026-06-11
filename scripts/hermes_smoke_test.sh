#!/usr/bin/env bash
# scripts/hermes_smoke_test.sh
#
# Non-destructive post-install smoke test for a Hermes SEG Docker host.
# Verifies container health, DB integrity, mail-chain config, LDAP/Authelia,
# scheduled tasks, and fail2ban. Does NOT send or receive real mail.
#
# Run on the Docker host:
#   bash /opt/hermes-seg-docker-gl/scripts/hermes_smoke_test.sh
#
# Exit code 0 = no failures, 1 = one or more failures (CI-friendly).
#
# Issue: https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/242

set -uo pipefail

HERMES_DIR="${HERMES_DIR:-/opt/hermes-seg-docker-gl}"
COMPOSE_FILE="${HERMES_DIR}/docker-compose.yml"

# ---- Color (TTY only) ----
if [[ -t 1 ]]; then
    RED=$(tput setaf 1); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4); BOLD=$(tput bold); RESET=$(tput sgr0)
else
    RED=""; GREEN=""; YELLOW=""; BLUE=""; BOLD=""; RESET=""
fi

PASS=0; FAIL=0; WARN=0

section() { echo; echo "${BOLD}${BLUE}=== $1 ===${RESET}"; }
pass()    { echo "  ${GREEN}OK  ${RESET}  $1"; PASS=$((PASS+1)); }
fail()    { echo "  ${RED}FAIL${RESET}  $1"; FAIL=$((FAIL+1)); }
warn()    { echo "  ${YELLOW}WARN${RESET}  $1"; WARN=$((WARN+1)); }
detail()  { echo "          $1"; }

# ---- Preflight ----
if ! command -v docker >/dev/null 2>&1; then
    echo "${RED}ERROR${RESET} docker not found in PATH"
    exit 2
fi
if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "${RED}ERROR${RESET} compose file not found at $COMPOSE_FILE (set HERMES_DIR=... if installed elsewhere)"
    exit 2
fi

# ---- helpers ----

# check_container <name>
check_container() {
    local name="$1"
    local state
    state=$(docker inspect -f '{{.State.Status}}|{{.State.Restarting}}' "$name" 2>/dev/null)
    if [[ -z "$state" ]]; then
        fail "$name not found"
        return
    fi
    local status="${state%%|*}"
    local restarting="${state##*|}"
    if [[ "$restarting" == "true" ]]; then
        fail "$name in Restarting state"
    elif [[ "$status" == "running" ]]; then
        pass "$name running"
    else
        fail "$name state=$status"
    fi
}

# db_query <sql>  -- returns row data via socket auth (no -p)
db_query() {
    docker exec hermes_db_server mariadb -N -s -e "$1" 2>/dev/null
}

# db_query_db <db> <sql>
db_query_db() {
    docker exec hermes_db_server mariadb -N -s "$1" -e "$2" 2>/dev/null
}

# ============================================================
# Tier 1 — Container health
# ============================================================
section "Tier 1 — Container health"

# Canonical 18-container list per docker-compose.yml. OpenDKIM lives
# inside hermes_postfix_dkim and OpenDMARC's milter lives inside
# hermes_dmarc -- no separate hermes_opendkim/hermes_opendmarc.
CONTAINERS=(
    hermes_unbound
    hermes_db_server
    hermes_ofelia
    hermes_nginx
    hermes_authelia
    hermes_authelia_redis
    hermes_commandbox
    hermes_postfix_dkim
    hermes_dmarc
    hermes_openarc
    hermes_mail_filter
    hermes_body_milter
    hermes_ciphermail
    hermes_fail2ban
    hermes_nextcloud_redis
    hermes_nextcloud
    hermes_dovecot
    hermes_ldap
)
for c in "${CONTAINERS[@]}"; do
    check_container "$c"
done

RECENT_FATAL=$(docker compose -f "$COMPOSE_FILE" logs --since 10m 2>/dev/null \
    | grep -iE 'fatal|panic|emerg' \
    | grep -vE 'NOTICE|INFO|ZeroError' \
    | head -5)
if [[ -z "$RECENT_FATAL" ]]; then
    pass "no fatal/panic/emerg in last 10 min"
else
    warn "found fatal/panic/emerg lines in last 10 min (first 5):"
    echo "$RECENT_FATAL" | sed 's/^/          /'
fi

# ============================================================
# Tier 2 — Database integrity
# ============================================================
section "Tier 2 — Database integrity"

EXPECTED_DBS=(hermes djigzo authelia opendmarc nextcloud Syslog)
for db in "${EXPECTED_DBS[@]}"; do
    found=$(db_query "SHOW DATABASES LIKE '$db'")
    if [[ "$found" == "$db" ]]; then
        tbl_count=$(db_query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$db'")
        pass "database $db present ($tbl_count tables)"
    else
        fail "database $db missing"
    fi
done

# Key tables in hermes DB
for tbl in parameters parameters2 system_settings system_users system_updates; do
    count=$(db_query_db hermes "SELECT COUNT(*) FROM $tbl")
    if [[ -z "$count" ]]; then
        fail "hermes.$tbl unreachable"
    elif [[ "$count" -gt 0 ]]; then
        pass "hermes.$tbl has $count row(s)"
    else
        fail "hermes.$tbl is empty"
    fi
done

# Docker train identity.
# version_no distinguishes a Docker-era install ('Docker') from a legacy bare-metal one
# -- a genuine, cheap assertion. (system_settings presence is already checked above.)
actual=$(db_query_db hermes "SELECT value FROM system_settings WHERE parameter='version_no'")
if [[ "$actual" == "Docker" ]]; then
    pass "system_settings.version_no = 'Docker'"
else
    fail "system_settings.version_no = '$actual' (expected 'Docker')"
fi

# Release stamp. The smoke test cannot know which release *should* be installed (code
# checked out in updates/ is not proof of what was applied to the DB), so by default we
# just REPORT build_no as context -- not a pass/fail. A caller that knows the target
# (install_hermes_docker.sh / system_update_docker.sh) can export EXPECTED_BUILD=vYYMMDD
# to turn this into a hard assertion.
build_actual=$(db_query_db hermes "SELECT value FROM system_settings WHERE parameter='build_no'")
if [[ -n "${EXPECTED_BUILD:-}" ]]; then
    if [[ "$build_actual" == "$EXPECTED_BUILD" ]]; then
        pass "system_settings.build_no = '$build_actual' (matches expected)"
    else
        fail "system_settings.build_no = '$build_actual' (expected '$EXPECTED_BUILD')"
    fi
else
    detail "installed build_no = '${build_actual:-<unset>}' (informational; set EXPECTED_BUILD=vYYMMDD to assert)"
fi

# ============================================================
# Tier 2b — Per-service DB authentication
# ============================================================
# Tier 2 confirms each database EXISTS; it does NOT confirm each service can
# AUTHENTICATE to it. A cross-host restore can leave a service's config pointing
# at the SOURCE host's rotated DB user (which doesn't exist here) -- the database
# is present, but the service gets "Access denied [1045]". This tier closes that
# gap two ways:
#   1. connect as each service's creds/ user (confirms the MariaDB grant matches
#      this host's creds/ -- catches rotation/restore drift at the DB layer);
#   2. exercise the live service config path where cheap (NC occ, postfix maps) --
#      catches a restored config that diverged from creds/ (the real NC failure mode).
section "Tier 2b — Per-service DB authentication"

CREDS_PATH="${HERMES_DIR}/config/hermes/opt/hermes/creds"

# label : username-file : password-file : database
DB_CRED_MAP="\
hermes:hermes_username:hermes_password:hermes
ciphermail:ciphermail_username:ciphermail_password:djigzo
opendmarc:opendmarc_username:opendmarc_password:opendmarc
syslog:syslog_username:syslog_password:Syslog
authelia:authelia_username:authelia_password:authelia
nextcloud:nextcloud_mysql_username:nextcloud_mysql_password:nextcloud"

while IFS=: read -r label ufile pfile db; do
    [[ -n "$label" ]] || continue
    if [[ ! -f "${CREDS_PATH}/${ufile}" || ! -f "${CREDS_PATH}/${pfile}" ]]; then
        warn "${label}: creds/${ufile} or creds/${pfile} missing -- skipped"
        continue
    fi
    dbuser=$(tr -d '[:space:]' < "${CREDS_PATH}/${ufile}")
    dbpass=$(tr -d '\n'        < "${CREDS_PATH}/${pfile}")
    if [[ -z "$dbuser" || -z "$dbpass" ]]; then
        warn "${label}: empty creds -- skipped"
        continue
    fi
    # -h 127.0.0.1 forces TCP (matches the user@'%' grant, like the real service);
    # MYSQL_PWD keeps the password out of the process list.
    if docker exec -e MYSQL_PWD="$dbpass" hermes_db_server \
         mariadb -u "$dbuser" -h 127.0.0.1 "$db" -e "SELECT 1;" >/dev/null 2>&1; then
        pass "${label} DB auth OK (${dbuser}@${db})"
    else
        fail "${label} DB auth FAILED (${dbuser}@${db}) -- MariaDB user/grant missing or password drift"
    fi
done <<< "$DB_CRED_MAP"

# Live-config reality check: NC's occ exercises config.php's ACTUAL dbuser/dbpassword,
# so it catches a restored config.php that still points at the source host's user even
# when creds/ (and thus the test above) is correct -- the exact NC cross-host failure.
if docker ps --format '{{.Names}}' | grep -q '^hermes_nextcloud$'; then
    if docker exec -u www-data hermes_nextcloud php /var/www/html/occ status >/dev/null 2>&1; then
        pass "nextcloud occ status (config.php DB creds resolve)"
    else
        fail "nextcloud occ status FAILED -- config.php DB creds broken (cross-host restore?)"
    fi
fi

# ============================================================
# Tier 3 — Postfix + filter chain
# ============================================================
section "Tier 3 — Postfix + filter chain"

# postfix check -- ignore the informational "backwards-compatible default
# settings" lines (they're a heads-up from postfix, not an error condition).
POSTFIX_CHECK=$(docker exec hermes_postfix_dkim postfix check 2>&1 \
    | grep -vE 'backwards-compatible|COMPATIBILITY_README|disable backwards compatibility')
if [[ -z "$POSTFIX_CHECK" ]]; then
    pass "postfix check clean (ignoring backwards-compat notice)"
else
    fail "postfix check returned warnings/errors:"
    echo "$POSTFIX_CHECK" | sed 's/^/          /'
fi

# Show current smtpd_milters value. Empty IS valid on a fresh install
# (each milter URI is added to the chain only when admin enables the
# corresponding feature via Content Checks > SPF/DKIM/DMARC/ARC Settings),
# so an empty value is a WARN-with-context, not a FAIL.
SMTPD_MILTERS=$(docker exec hermes_postfix_dkim postconf -h smtpd_milters 2>/dev/null | tr -d '[:space:]')
if [[ -z "$SMTPD_MILTERS" ]]; then
    warn "smtpd_milters is empty -- expected on a fresh install before"
    detail "SPF/DKIM/DMARC/ARC are enabled via Content Checks settings pages."
else
    pass "smtpd_milters: $(docker exec hermes_postfix_dkim postconf -h smtpd_milters 2>/dev/null)"
fi

# Postfix content_filter (Amavis handoff) -- expected to be set.
CONTENT_FILTER=$(docker exec hermes_postfix_dkim postconf -h content_filter 2>/dev/null | tr -d '[:space:]')
if [[ -n "$CONTENT_FILTER" ]]; then
    pass "content_filter: $(docker exec hermes_postfix_dkim postconf -h content_filter 2>/dev/null)"
else
    fail "content_filter is empty -- amavis handoff not wired"
fi

# OpenDKIM daemon lives inside hermes_postfix_dkim, not a separate container.
if docker exec hermes_postfix_dkim pgrep -x opendkim >/dev/null 2>&1; then
    pass "opendkim daemon running inside hermes_postfix_dkim"
else
    warn "opendkim daemon not running inside hermes_postfix_dkim"
fi

# Amavis -- check the daemon is up rather than probing ports
# (the container often lacks ss/netstat, and amavis port assignment
# is custom-configured per Hermes -- check the process instead).
if docker exec hermes_mail_filter pgrep -f amavisd >/dev/null 2>&1; then
    pass "amavisd running inside hermes_mail_filter"
else
    fail "amavisd NOT running inside hermes_mail_filter"
fi

# Postfix queue
QUEUE_OUT=$(docker exec hermes_postfix_dkim postqueue -p 2>&1)
if echo "$QUEUE_OUT" | grep -q "Mail queue is empty"; then
    pass "postfix queue empty"
else
    QSUMMARY=$(echo "$QUEUE_OUT" | tail -1)
    warn "postfix queue not empty -- expected on non-routable test box: $QSUMMARY"
fi

# ============================================================
# Tier 4 — LDAP + Authelia
# ============================================================
section "Tier 4 — LDAP + Authelia"

# Check slapd process is alive. SASL EXTERNAL via ldapi:// requires
# uid 0 inside the container (proven to work in the entrypoint's
# ldapwhoami probe loop), but docker exec runs as whoever the
# Dockerfile USER directive specifies -- which may not map to the
# OS root the SASL rules accept. Process check is the safer probe.
if docker exec hermes_ldap pgrep -x slapd >/dev/null 2>&1; then
    pass "slapd running inside hermes_ldap"
else
    fail "slapd NOT running inside hermes_ldap"
fi

# ldapwhoami via ldapi+EXTERNAL -- same probe the entrypoint uses
# to confirm slapd is accepting connections (entrypoint.sh ~line 103).
# If this works for the entrypoint it should work for us.
if docker exec hermes_ldap ldapwhoami -Y EXTERNAL -H 'ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi' >/dev/null 2>&1; then
    pass "ldapwhoami via ldapi+EXTERNAL responds"
else
    warn "ldapwhoami via ldapi+EXTERNAL did not respond -- Authelia binds via TCP so this is not necessarily a failure"
fi

AUTHELIA_ERR=$(docker logs hermes_authelia --since 5m 2>&1 \
    | grep -iE 'level=error|level=fatal' \
    | head -5)
if [[ -z "$AUTHELIA_ERR" ]]; then
    pass "Authelia: no errors in last 5 min"
else
    warn "Authelia errors in last 5 min (first 5):"
    echo "$AUTHELIA_ERR" | sed 's/^/          /'
fi

# ============================================================
# Tier 7 — Scheduled tasks (Ofelia)
# ============================================================
section "Tier 7 — Scheduled tasks (Ofelia)"

# Column is `active` (1/0), not `enabled`.
OFELIA_ACTIVE=$(db_query_db hermes "SELECT COUNT(*) FROM ofelia_jobs WHERE active=1")
if [[ -z "$OFELIA_ACTIVE" ]]; then
    warn "ofelia_jobs table unreachable"
else
    if [[ "$OFELIA_ACTIVE" -gt 0 ]]; then
        pass "ofelia_jobs: $OFELIA_ACTIVE active job(s)"
    else
        warn "ofelia_jobs has no active rows"
    fi
fi

# ============================================================
# Tier 8 — Fail2ban
# ============================================================
section "Tier 8 — Fail2ban"

if docker exec hermes_fail2ban fail2ban-client ping 2>/dev/null | grep -q pong; then
    pass "fail2ban-client ping -> pong"
    JAILS_RAW=$(docker exec hermes_fail2ban fail2ban-client status 2>/dev/null | grep -E 'Jail list' | sed 's/.*Jail list:[[:space:]]*//')
    if [[ -n "$JAILS_RAW" ]]; then
        pass "active jails: $JAILS_RAW"
    else
        warn "fail2ban running but reports no active jails"
    fi
else
    fail "fail2ban-client not responding"
fi

# ============================================================
# Summary
# ============================================================
echo
echo "${BOLD}=== Summary ===${RESET}"
printf "  ${GREEN}PASS${RESET}: %s\n" "$PASS"
printf "  ${YELLOW}WARN${RESET}: %s\n" "$WARN"
printf "  ${RED}FAIL${RESET}: %s\n" "$FAIL"
echo

if [[ "$FAIL" -eq 0 ]]; then
    echo "${GREEN}${BOLD}All critical checks passed.${RESET}"
    if [[ "$WARN" -gt 0 ]]; then
        echo "${YELLOW}Review WARN lines -- some may be expected on a non-routable Test box.${RESET}"
    fi
    exit 0
else
    echo "${RED}${BOLD}One or more critical checks failed -- investigate above.${RESET}"
    exit 1
fi
