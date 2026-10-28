#!/usr/bin/env bash
# Intrusion Prevention watches SMTP logins: the postfix jail is running, reads
# Postfix's mail.log, and a ban is enforced and recorded under jail 'postfix'
# (not 'dovecot', which shares the MAILSERVER source). Before v261027 failed
# SASL logins on 587/465/25 were watched by nothing.
# Uses 192.0.2.11 (TEST-NET-1, never routed). Always unbans on exit.
source "$(dirname "$0")/../lib.sh"

IP=192.0.2.11
JAIL=postfix
F2B="docker exec hermes_fail2ban"

docker ps --format '{{.Names}}' | grep -qx hermes_fail2ban || skip "hermes_fail2ban not running"

[[ "$(db "SELECT COUNT(*) FROM intrusion_prevention_jails WHERE jail_name='$JAIL'")" == "1" ]] \
    && pass "postfix jail defined in the database" \
    || fail "postfix jail missing from intrusion_prevention_jails"

status="$($F2B fail2ban-client status $JAIL 2>&1)"
if grep -q '/remotelogs/postfix_dkim/mail.log' <<<"$status"; then
    pass "postfix jail running and reading Postfix's mail.log"
else
    fail "postfix jail not running (jail.local not regenerated, or the log mount is missing)"
    done_check
fi

$F2B fail2ban-client get $JAIL failregex 2>/dev/null | grep -q 'SASL' \
    && pass "postfix jail matches failed SASL logins" \
    || fail "postfix jail filter has no SASL failure rule (expected postfix[mode=auth])"

backend="$($F2B sed -n 's/^iptables *= *//p' /config/fail2ban/action.d/hermes-iptables-$JAIL.local 2>/dev/null | tr -d '\r')"
[[ -n "$backend" ]] || { fail "no iptables backend chosen (hermes-iptables-$JAIL.local missing)"; done_check; }

trap '$F2B fail2ban-client set $JAIL unbanip $IP >/dev/null 2>&1' EXIT
$F2B fail2ban-client set $JAIL unbanip $IP >/dev/null 2>&1   # clean start
sleep 2

rule_present() { $F2B "$backend" -L "f2b-$JAIL" -n 2>/dev/null | grep -q "$IP"; }
row_count()    { db "SELECT COUNT(*) FROM fail2ban_ips WHERE ip='$IP' AND jail='$JAIL'"; }
row_present()  { [[ "$(row_count)" == "1" ]]; }
row_absent()   { [[ "$(row_count)" == "0" ]]; }

$F2B fail2ban-client set $JAIL banip $IP >/dev/null 2>&1

wait_for 15 rule_present \
    && pass "ban: $IP rejected in f2b-$JAIL" \
    || fail "ban: no rule for $IP in f2b-$JAIL"

check_db=0
if [[ "$(db "SELECT setting_value FROM intrusion_prevention_settings WHERE setting_name='enabled'")" == "1" ]]; then
    check_db=1
    wait_for 15 row_present \
        && pass "ban: $IP recorded under jail '$JAIL'" \
        || fail "ban: $IP not recorded under jail '$JAIL' (see config/fail2ban/scripts/api-notify.log)"
else
    echo "  NOTE  Intrusion Prevention disabled in settings; database recording not checked"
fi

$F2B fail2ban-client set $JAIL unbanip $IP >/dev/null 2>&1
trap - EXIT

wait_for 15 bash -c "! docker exec hermes_fail2ban $backend -L f2b-$JAIL -n 2>/dev/null | grep -q '$IP'" \
    && pass "unban: rule for $IP removed" \
    || fail "unban: rule for $IP still present"

if (( check_db )); then
    wait_for 15 row_absent \
        && pass "unban: $IP removed from fail2ban_ips" \
        || fail "unban: $IP still in fail2ban_ips"
fi

done_check
