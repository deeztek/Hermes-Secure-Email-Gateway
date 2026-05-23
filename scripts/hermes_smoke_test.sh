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

CONTAINERS=(
    hermes_commandbox
    hermes_postfix_dkim
    hermes_mail_filter
    hermes_nginx
    hermes_authelia
    hermes_ciphermail
    hermes_db_server
    hermes_ldap
    hermes_dovecot
    hermes_ofelia
    hermes_fail2ban
    hermes_body_milter
    hermes_opendkim
    hermes_opendmarc
    hermes_dmarc
    hermes_openarc
    hermes_nextcloud
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

# Docker train markers
for kv in "version_no:Docker" "build_no:v260119"; do
    key="${kv%%:*}"; expected="${kv##*:}"
    actual=$(db_query_db hermes "SELECT value FROM system_settings WHERE parameter='$key'")
    if [[ "$actual" == "$expected" ]]; then
        pass "system_settings.$key = '$expected'"
    else
        fail "system_settings.$key = '$actual' (expected '$expected')"
    fi
done

# ============================================================
# Tier 3 — Postfix + filter chain
# ============================================================
section "Tier 3 — Postfix + filter chain"

POSTFIX_CHECK=$(docker exec hermes_postfix_dkim postfix check 2>&1)
if [[ -z "$POSTFIX_CHECK" ]]; then
    pass "postfix check clean"
else
    fail "postfix check returned warnings/errors:"
    echo "$POSTFIX_CHECK" | sed 's/^/          /'
fi

MILTERS=$(docker exec hermes_postfix_dkim postconf -h smtpd_milters 2>/dev/null)
if [[ -z "$MILTERS" ]]; then
    fail "smtpd_milters is empty"
else
    detail "smtpd_milters: $MILTERS"
    for m in opendkim opendmarc body_milter openarc; do
        if echo "$MILTERS" | grep -qi "$m"; then
            pass "smtpd_milters references $m"
        else
            warn "smtpd_milters has no reference to $m"
        fi
    done
fi

# Amavis listening on content-filter + re-injection ports
for port in 10024 10026; do
    if docker exec hermes_mail_filter sh -c "ss -tln 2>/dev/null || netstat -tln 2>/dev/null" \
        | grep -qE ":${port}[[:space:]]"; then
        pass "amavis listening on :$port"
    else
        fail "amavis NOT listening on :$port"
    fi
done

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

BASE_DN=$(docker exec hermes_ldap ldapsearch -x -H 'ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi' -Y EXTERNAL \
    -b "dc=hermes,dc=local" -s base "(objectClass=*)" dn 2>/dev/null | grep '^dn:' | head -1)
if [[ -n "$BASE_DN" ]]; then
    pass "LDAP responsive ($BASE_DN)"
else
    fail "LDAP NOT responsive via ldapi://"
fi

for ou in users groups; do
    if docker exec hermes_ldap ldapsearch -x -H 'ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi' -Y EXTERNAL \
        -b "ou=$ou,dc=hermes,dc=local" -s base "(objectClass=*)" dn 2>/dev/null | grep -q '^dn:'; then
        pass "LDAP ou=$ou exists"
    else
        fail "LDAP ou=$ou missing"
    fi
done

for grp in admins one_factor two_factor mailboxes relays; do
    member_count=$(docker exec hermes_ldap ldapsearch -x -H 'ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi' -Y EXTERNAL \
        -b "cn=$grp,ou=groups,dc=hermes,dc=local" -s base "(objectClass=*)" member 2>/dev/null \
        | grep -c '^member:')
    if [[ "$grp" == "admins" || "$grp" == "one_factor" ]]; then
        if [[ "$member_count" -gt 0 ]]; then
            pass "cn=$grp has $member_count member(s)"
        else
            fail "cn=$grp is empty (bootstrap admin should be a member)"
        fi
    else
        if [[ "$member_count" -gt 0 ]]; then
            pass "cn=$grp has $member_count member(s)"
        else
            detail "cn=$grp has 0 members (expected on fresh install)"
        fi
    fi
done

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

OFELIA_ENABLED=$(db_query_db hermes "SELECT COUNT(*) FROM ofelia_jobs WHERE enabled=1")
if [[ -z "$OFELIA_ENABLED" ]]; then
    warn "ofelia_jobs table unreachable"
else
    if [[ "$OFELIA_ENABLED" -gt 0 ]]; then
        pass "ofelia_jobs: $OFELIA_ENABLED enabled job(s)"
    else
        warn "ofelia_jobs has no enabled rows"
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
