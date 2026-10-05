#!/usr/bin/env bash
# FRESH-INSTALL: covered-by config/database/hermes_install.sql  the auto-id row now sits below every explicit id, so a fresh install renders the full chain from the start
#
# v260912 -- push the repaired milter chain into main.cf
#
# WHY THIS EXISTS
#
# sql/schema_updates.sql section 3 restores the parameters row that v260815's
# baseline silently dropped. That fixes the database. It does not fix Postfix.
#
# smtpd_milters lives in main.cf, written by `postconf -e` from
# generate_postfix_configuration.cfm, which runs on an admin Save & Apply.
# The update orchestrator's phase 4 restarts hermes_postfix_dkim but never
# re-renders the configuration, and a restart only re-reads main.cf as it
# already is. So without this, an upgraded gateway has the row in the database,
# the old two-milter chain in main.cf, and Link Guard and disclaimers still
# dead until somebody happens to save a Postfix settings page.
#
# WHAT IT DOES
#
# Reads the enabled children of smtpd_milters and non_smtpd_milters in order1
# order, exactly as generate_postfix_configuration.cfm does, and postconf's
# those two directives. One targeted edit per directive.
#
# It deliberately does NOT rewrite main.cf. Rewriting a live main.cf from an
# unattended upgrade script is a good way to stop a gateway accepting mail;
# this is the same targeted `postconf -e` the console itself uses.
#
# No-ops when the live value already matches, so re-running is free.

set -uo pipefail

log()  { echo "  $*"; }
warn() { echo "  WARNING: $*"; }

if ! docker ps --format '{{.Names}}' | grep -qx hermes_db_server; then
    warn "hermes_db_server is not running; skipping milter chain repair."
    exit 0
fi
if ! docker ps --format '{{.Names}}' | grep -qx hermes_postfix_dkim; then
    warn "hermes_postfix_dkim is not running; skipping milter chain repair."
    exit 0
fi

changed=0

for directive in smtpd_milters non_smtpd_milters; do
    # Same ordering rule the console uses: enabled children, by order1.
    want="$(docker exec hermes_db_server mariadb -u root -N hermes -e \
        "SELECT COALESCE(GROUP_CONCAT(parameter ORDER BY order1 SEPARATOR ', '), '')
         FROM parameters
         WHERE child='1' AND parent_name='${directive}' AND enabled='1';" 2>/dev/null | tr -d '\r')"

    if [[ -z "$want" ]]; then
        warn "${directive}: no enabled rows in the database, leaving the live value alone."
        continue
    fi

    # Never shrink the chain. If the database somehow holds less than what is
    # live, that is a state this script is not equipped to reason about, and
    # quietly removing a milter is worse than leaving a stale one.
    have="$(docker exec hermes_postfix_dkim postconf -h "$directive" 2>/dev/null | tr -d '\r')"
    if [[ "$have" == "$want" ]]; then
        log "${directive}: already correct."
        continue
    fi
    if [[ $(echo "$have" | tr ',' '\n' | grep -c .) -gt $(echo "$want" | tr ',' '\n' | grep -c .) ]]; then
        warn "${directive}: live value has more entries than the database describes."
        warn "  live: ${have}"
        warn "  db  : ${want}"
        warn "  Left unchanged. Reconcile by hand, or use Perimeter Checks / Save & Apply."
        continue
    fi

    if docker exec hermes_postfix_dkim postconf -e "${directive} = ${want}" 2>/dev/null; then
        log "${directive}: ${have}"
        log "${directive}: -> ${want}"
        changed=1
    else
        warn "${directive}: postconf failed, leaving the live value alone."
    fi
done

if [[ "$changed" == "1" ]]; then
    docker exec hermes_postfix_dkim /usr/sbin/postfix reload >/dev/null 2>&1 \
        && log "postfix reloaded." \
        || warn "postfix reload failed; phase 4 restarts the container anyway."
fi

exit 0
