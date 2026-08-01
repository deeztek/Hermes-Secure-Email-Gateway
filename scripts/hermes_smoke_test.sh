#!/usr/bin/env bash
# scripts/hermes_smoke_test.sh
#
# Non-destructive post-install smoke test for a Hermes SEG Docker host.
# Verifies container health, DB integrity, mail-chain config, LDAP/Authelia,
# scheduled tasks, and fail2ban. Does NOT send or receive real mail.
#
# Run on the Docker host from anywhere in the install tree:
#   bash <install-root>/scripts/hermes_smoke_test.sh
# The install root is located automatically; override with HERMES_DIR=... if
# the script has been copied outside the tree.
#
# Exit code 0 = no failures, 1 = one or more failures (CI-friendly).
#
# Issue: https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/242

set -uo pipefail

# ---- Self-locate HERMES_DIR ----
# Walk up from this script's location looking for docker-compose.yml. This is
# depth-independent and survives the install root being anywhere (/opt/hermes-seg,
# /opt/Hermes-Secure-Email-Gateway, /opt/hermes-seg-container-gl, ...).
# HERMES_DIR=... in the environment still overrides.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ -z "${HERMES_DIR:-}" ]]; then
    HERMES_DIR="$SCRIPT_DIR"
    while [[ "$HERMES_DIR" != "/" ]]; do
        if [[ -f "$HERMES_DIR/docker-compose.yml" ]]; then
            break
        fi
        HERMES_DIR="$(dirname "$HERMES_DIR")"
    done
fi
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
    echo "${RED}ERROR${RESET} could not locate docker-compose.yml walking up from ${SCRIPT_DIR} (set HERMES_DIR=... to point at the install root)"
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

# Admin DB access.
#
# The documented design (install_hermes_docker.sh create_databases()) is that
# LinuxServer's mariadb image gives root@localhost the unix_socket plugin, so
# `docker exec ... mariadb -u root` with no password authenticates as OS root.
# Every Hermes script relies on that.
#
# Observed 2026-08-01 on DEV: root@localhost rejected socket auth outright --
# "ERROR 1045 Access denied for user 'root'@'localhost' (using password: NO)"
# -- i.e. that account is password-authenticated there, contrary to the design.
# Whether that is one box's drift or a real variation is still open (#288), but
# a diagnostic tool must not be the thing that falls over: resolve the working
# method once, then use it. The password is read from the Docker secret already
# mounted inside the container, so it never appears in argv or shell history.
# Probed in order; first that works wins. `default` is the historical form and
# stays FIRST -- the image ships a root client config, so a bare invocation
# picks up whatever credentials it holds. Adding an explicit `-u root` DISCARDS
# that and was a regression introduced 2026-08-01; it is kept only as a
# fallback for boxes without the client config.
DB_AUTH="unresolved"

resolve_db_auth() {
    if docker exec hermes_db_server mariadb -N -s -e "SELECT 1" >/dev/null 2>&1; then
        DB_AUTH="default"
    elif docker exec hermes_db_server mariadb -u root -N -s -e "SELECT 1" >/dev/null 2>&1; then
        DB_AUTH="root"
    elif docker exec hermes_db_server sh -c \
            'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD 2>/dev/null); export MYSQL_PWD; mariadb -u root -N -s -e "SELECT 1"' \
            >/dev/null 2>&1; then
        DB_AUTH="password"
    else
        DB_AUTH="none"
    fi
}

# db_query <sql>
db_query() {
    case "$DB_AUTH" in
        root)     docker exec hermes_db_server mariadb -u root -N -s -e "$1" 2>/dev/null ;;
        password) docker exec hermes_db_server sh -c \
                      'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD); export MYSQL_PWD; exec mariadb -u root -N -s -e "$1"' \
                      _ "$1" 2>/dev/null ;;
        *)        docker exec hermes_db_server mariadb -N -s -e "$1" 2>/dev/null ;;
    esac
}

# db_query_db <db> <sql>
db_query_db() {
    case "$DB_AUTH" in
        root)     docker exec hermes_db_server mariadb -u root -N -s "$1" -e "$2" 2>/dev/null ;;
        password) docker exec hermes_db_server sh -c \
                      'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD); export MYSQL_PWD; exec mariadb -u root -N -s "$1" -e "$2"' \
                      _ "$1" "$2" 2>/dev/null ;;
        *)        docker exec hermes_db_server mariadb -N -s "$1" -e "$2" 2>/dev/null ;;
    esac
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

# Probe the admin connection ONCE, with stderr visible, before running any
# real check.
#
# Every helper below suppresses stderr, so an unusable admin connection used
# to surface as twelve identical "database <x> missing" failures on a box
# whose databases are demonstrably fine -- Tier 2b authenticates to those same
# databases moments later and passes. That is a diagnosis the operator has to
# reverse-engineer, and it trains people to ignore this tier. Show the actual
# error instead, and say plainly that the failures below are downstream of it.
resolve_db_auth
case "$DB_AUTH" in
    socket)
        pass "admin DB access via unix_socket (root@localhost, as designed)"
        ;;
    password)
        warn "admin DB access requires a PASSWORD -- root@localhost is not unix_socket on this box"
        echo "          Every Hermes script assumes socket auth. system_update_docker.sh"
        echo "          reads build_no that way and calls fatal() when it comes back empty,"
        echo "          so THE UPDATE ORCHESTRATOR CANNOT RUN HERE. See issue #288."
        ;;
    none)
        fail "admin DB connection unusable by either method -- this tier is unreliable"
        echo "          command: docker exec hermes_db_server mariadb -u root -N -s -e 'SELECT 1'"
        docker exec hermes_db_server mariadb -u root -N -s -e "SELECT 1" 2>&1 >/dev/null \
            | sed 's/^/          /'
        echo "          Tier 2b below uses per-service credentials and is unaffected."
        ;;
esac

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

# The DB is the source of truth; /etc/ofelia/config.ini is RENDERED from it.
# Nothing enforced that the two agreed, and they silently diverged for four
# releases (#288): the repo shipped a config.ini snapshot frozen at v260612,
# it was bind-mounted straight into place, and nothing regenerated it at
# install or upgrade. Result -- four seeded jobs never ran on a fresh install
# (including the fangfrisch malware-feed refresh) and the update check called
# a script removed at #218, so the dashboard read UPDATE CHECK PENDING
# forever. Every one of those jobs LOOKED fine in the DB.
#
# This compares what is scheduled against what should be, so the divergence
# can never be invisible again. Fix with:
#     ./scripts/install_hermes_docker.sh --render-ofelia
OFELIA_RENDERED=$(docker exec hermes_ofelia grep -c '^\[job-exec' /etc/ofelia/config.ini 2>/dev/null || echo "")
if [[ -z "$OFELIA_RENDERED" ]]; then
    warn "Could not read /etc/ofelia/config.ini from hermes_ofelia"
elif [[ -z "$OFELIA_ACTIVE" ]]; then
    # Say so out loud. A comparison that quietly does not run reports the same
    # as one that passed -- which is the entire failure mode this check exists
    # to prevent, so it must never be silent about being unable to run.
    warn "config.ini vs ofelia_jobs NOT COMPARED -- DB unreachable ($OFELIA_RENDERED job(s) scheduled, DB count unknown)"
elif [[ "$OFELIA_RENDERED" -eq "$OFELIA_ACTIVE" ]]; then
    pass "config.ini matches ofelia_jobs ($OFELIA_RENDERED job(s) scheduled)"
else
    fail "config.ini is STALE: $OFELIA_RENDERED job(s) scheduled, $OFELIA_ACTIVE active in DB"
    echo "          Jobs in the DB but NOT scheduled (these are not running):"
    # Both sides hold the same shape -- [job-exec "name"] -- so one extraction
    # serves both and the two lists are guaranteed comparable.
    RENDERED_NAMES=$(docker exec hermes_ofelia grep '^\[job-exec' /etc/ofelia/config.ini 2>/dev/null \
                     | sed 's/.*"\(.*\)".*/\1/' | sort)
    DB_NAMES=$(db_query_db hermes "SELECT job_name FROM ofelia_jobs WHERE active=1" \
                     | sed 's/.*"\(.*\)".*/\1/' | sort)
    comm -13 <(echo "$RENDERED_NAMES") <(echo "$DB_NAMES") | sed 's/^/            - /'
    echo "          Fix: ./scripts/install_hermes_docker.sh --render-ofelia"
fi

# The update-check job is the ONLY channel that tells this box a release
# exists (dashboard widget + notification e-mail are both fed by the cache
# file it writes). It shipped pointed at /opt/hermes/schedule/update_check.sh,
# a pre-#218 wrapper that still runs but POSTs to a removed endpoint -- so it
# failed silently every night and the box could never learn it was behind.
# A job that LOOKS scheduled but cannot work is worse than a missing one.
UPDATE_CMD=$(docker exec hermes_ofelia sh -c \
    "grep -A3 'hermes-update-check' /etc/ofelia/config.ini | grep '^command'" 2>/dev/null || echo "")
if [[ -z "$UPDATE_CMD" ]]; then
    warn "hermes-update-check job not found in config.ini -- update notifications are OFF"
elif [[ "$UPDATE_CMD" == *check_for_update.cfm* ]]; then
    pass "hermes-update-check calls check_for_update.cfm"
else
    fail "hermes-update-check calls a stale target -- update notifications are silently dead"
    echo "          ${UPDATE_CMD#*= }"
    echo "          Fix: ./scripts/install_hermes_docker.sh --render-ofelia"
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
