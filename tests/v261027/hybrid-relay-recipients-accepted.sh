#!/usr/bin/env bash
# Hybrid domains are not mailbox-only domains in Postfix, so their relay
# recipients are accepted (v261027). v261026 gave every hybrid domain a
# mailbox_domains row and Postfix then rejected its relay recipients with
# "User unknown in virtual mailbox table". Read-only.
source "$(dirname "$0")/../lib.sh"

tmpl=config/hermes/opt/hermes/conf_files/mysql-virtual-mailbox-domains.HERMES
live=config/postfix-dkim/etc/postfix/mysql-virtual-mailbox-domains.cf

grep -q "type = 'hybrid'" "$tmpl" && pass "map template leaves hybrid domains out" \
    || fail "map template still lists hybrid domains as mailbox-only"
[[ -x updates/v261027/pre-scripts/10-hybrid-mailbox-domains-map.sh ]] && pass "v261027 pre-script present and executable" \
    || fail "v261027 pre-script missing or not executable"
grep -q "type = 'hybrid'" "$live" 2>/dev/null && pass "live map leaves hybrid domains out" \
    || fail "live $live still lists hybrid domains as mailbox-only"

hybrids="$(db "SELECT GROUP_CONCAT(domain SEPARATOR ' ') FROM domains WHERE type='hybrid'")"
if [[ -z "$hybrids" || "$hybrids" == "NULL" ]]; then
    skip "no hybrid domains on this install"
fi
for d in $hybrids; do
    if [[ -n "$(docker exec hermes_postfix_dkim postmap -q "$d" mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf 2>/dev/null)" ]]; then
        fail "$d is a mailbox-only domain in Postfix (relay recipients rejected)"
    else
        pass "$d is not mailbox-only in Postfix"
    fi
    if [[ -n "$(docker exec hermes_postfix_dkim postmap -q "$d" mysql:/etc/postfix/mysql-domains.cf 2>/dev/null)" ]]; then
        pass "$d is a relay domain in Postfix"
    else
        fail "$d is not a relay domain in Postfix"
    fi
done

done_check
