#!/usr/bin/env bash
# v261017's code and container changes are in place. Read-only.
source "$(dirname "$0")/../lib.sh"

w=config/hermes/var/www/html
check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}

# #361 upgrades keep admin-owned config
[[ -x scripts/lib/restore_runtime_config.sh ]] && pass "restore library present and executable (#361)" \
    || fail "scripts/lib/restore_runtime_config.sh missing or not executable (#361)"
check scripts/system_update_docker.sh "^    restore_admin_config$" "updater restores admin-owned config after checkout (#361)"
check scripts/system_update_docker.sh "^    require_docker_engine$" "updater checks the Docker Engine floor (#367)"

# dead quarantine digest removed
for f in $w/schedule/quarantine_report.cfm $w/schedule/quarantine_report_daily.cfm config/hermes/opt/hermes/templates/create_crontab.sh; do
    [[ ! -e "$f" ]] && pass "removed: ${f##*/}" || fail "still present: $f"
done

# Docker Engine 25+ (#367)
ver="$(docker version --format '{{.Server.Version}}' 2>/dev/null)"
[[ "${ver%%.*}" =~ ^[0-9]+$ ]] && (( ${ver%%.*} >= 25 )) && pass "Docker Engine $ver" || fail "Docker Engine '$ver' is below 25"

# #367 LDAP healthcheck
iv="$(docker inspect hermes_ldap --format '{{.Config.Healthcheck.Interval}}' 2>/dev/null)"
si="$(docker inspect hermes_ldap --format '{{.Config.Healthcheck.StartInterval}}' 2>/dev/null)"
[[ "$iv" == "1m0s" || "$iv" == "60000000000" ]] && pass "LDAP healthcheck every 60s" || fail "LDAP healthcheck interval is '$iv' (#367)"
[[ "$si" == "5s" || "$si" == "5000000000" ]] && pass "LDAP healthcheck start_interval 5s" || fail "LDAP start_interval is '$si' (#367)"

# #357 Bayes directory
perm="$(docker exec hermes_mail_filter stat -c '%a %G' /opt/hermes/sa-bayes 2>/dev/null)"
[[ "$perm" == "2775 amavis" ]] && pass "sa-bayes is 2775 group amavis (#357)" || fail "sa-bayes is '$perm', expected '2775 amavis' (#357)"
docker exec hermes_mail_filter id -nG debian-spamd 2>/dev/null | grep -qw amavis \
    && pass "debian-spamd in the amavis group (#357)" || fail "debian-spamd not in the amavis group (#357)"

# #315 Dovecot log replay
# The image runs `dumb-init /entrypoint.sh`; the script is always at that path.
docker exec hermes_dovecot grep -q 'tail -n 0 -F' /entrypoint.sh 2>/dev/null \
    && pass "Dovecot follows logs from the end (#315)" || fail "Dovecot /entrypoint.sh still replays old log lines (#315)"

# #365 rsyslog selector, rendered files
for svc in opendmarc mail_filter; do
    f="config/$svc/etc/rsyslog.d/mysql.conf"
    if [[ ! -f "$f" ]]; then fail "$f missing"; continue; fi
    grep -qE '^syslog[[:space:]]*:ommysql:' "$f" && fail "$svc mysql.conf still uses the 'syslog' selector (#365)" \
        || pass "$svc mysql.conf selector valid (#365)"
done

# Link Guard engine (in-page redirects, decode, clean-redirect detail)
docker exec hermes_linkguard grep -q 'follow_page_peek' /opt/linkguard/app/verdict.py 2>/dev/null \
    && pass "Link Guard follows in-page redirects" || fail "Link Guard engine lacks in-page redirect following"
docker exec hermes_linkguard grep -q 'api/decode' /opt/linkguard/app/server.py 2>/dev/null \
    && pass "Link Guard decode API present" || fail "Link Guard engine lacks /api/decode"
docker exec hermes_linkguard grep -q 'redirects to %s' /opt/linkguard/app/verdict.py 2>/dev/null \
    && pass "Link Guard records where clean links land" || fail "Link Guard engine lacks the clean-redirect Detail"
check $w/admin/2/view_linkguard.cfm 'value="decode_link"' "Decode a link card present"
check $w/admin/2/view_linkguard.cfm 'value="refresh_feeds"' "Refresh feeds now button present"

# Quarantine release page: binary addresses converted, render after the outcome
check config/hermes/var/www/html/user-auth/quarantine_release.cfm 'charsetEncode(getmsg.from_email' "quarantine release converts binary sender address"
check config/hermes/var/www/html/user-auth/quarantine_release.cfm 'releaseStatus EQ "released"' "quarantine release renders only the real outcome"

# Telemetry: dedicated receiver, failures logged, count fixed
check $w/admin/2/inc/send_telemetry.cfm 'https://telemetry.hermesseg.io/' "telemetry posts to telemetry.hermesseg.io"
check $w/admin/2/inc/send_telemetry.cfm 'cffinally' "telemetry deletes its temp files whatever happens"
check $w/admin/2/inc/send_telemetry.cfm "(status = '' or status is null)" "telemetry domain count fixed"

done_check
