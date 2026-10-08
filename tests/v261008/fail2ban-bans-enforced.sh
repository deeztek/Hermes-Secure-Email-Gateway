#!/usr/bin/env bash
# A fail2ban ban is enforced in iptables and recorded in the database, and an
# unban removes both. Regression for v261008: on nft hosts the backend
# detection chose iptables-legacy, so no ban was ever applied or recorded.
# Uses 192.0.2.10 (TEST-NET-1, never routed). Always unbans on exit.
source "$(dirname "$0")/../lib.sh"

IP=192.0.2.10
JAIL=authelia
F2B="docker exec hermes_fail2ban"

docker ps --format '{{.Names}}' | grep -qx hermes_fail2ban || skip "hermes_fail2ban not running"

backend="$($F2B sed -n 's/^iptables *= *//p' /config/fail2ban/action.d/hermes-iptables-$JAIL.local 2>/dev/null | tr -d '\r')"
if [[ -z "$backend" ]]; then
    fail "no iptables backend chosen (hermes-iptables-$JAIL.local missing)"
    done_check
fi

if $F2B "$backend" -L DOCKER-USER -n >/dev/null 2>&1; then
    pass "chosen backend $backend holds Docker's DOCKER-USER chain"
else
    fail "chosen backend $backend has no DOCKER-USER chain (wrong backend, bans cannot apply)"
fi

trap '$F2B fail2ban-client set $JAIL unbanip $IP >/dev/null 2>&1' EXIT
$F2B fail2ban-client set $JAIL unbanip $IP >/dev/null 2>&1   # clean start
sleep 2

rule_present() { $F2B "$backend" -L "f2b-$JAIL" -n 2>/dev/null | grep -q "$IP"; }
row_count()    { db "SELECT COUNT(*) FROM fail2ban_ips WHERE ip='$IP' AND jail='$JAIL'"; }
row_present()  { [[ "$(row_count)" == "1" ]]; }
row_absent()   { [[ "$(row_count)" == "0" ]]; }

$F2B fail2ban-client set $JAIL banip $IP >/dev/null 2>&1

if wait_for 15 rule_present; then
    pass "ban: $IP rejected in f2b-$JAIL"
else
    fail "ban: no rule for $IP in f2b-$JAIL"
fi

if [[ "$(db "SELECT setting_value FROM intrusion_prevention_settings WHERE setting_name='enabled'")" == "1" ]]; then
    check_db=1
    if wait_for 15 row_present; then
        pass "ban: $IP recorded in fail2ban_ips"
    else
        fail "ban: $IP not recorded in fail2ban_ips (see config/fail2ban/scripts/api-notify.log)"
    fi
else
    check_db=0
    echo "  NOTE  Intrusion Prevention disabled in settings; database recording not checked"
fi

$F2B fail2ban-client set $JAIL unbanip $IP >/dev/null 2>&1
trap - EXIT

if wait_for 15 bash -c "! docker exec hermes_fail2ban $backend -L f2b-$JAIL -n 2>/dev/null | grep -q '$IP'"; then
    pass "unban: rule for $IP removed"
else
    fail "unban: rule for $IP still present"
fi

if (( check_db )); then
    if wait_for 15 row_absent; then
        pass "unban: $IP removed from fail2ban_ips"
    else
        fail "unban: $IP still in fail2ban_ips"
    fi
fi

done_check
