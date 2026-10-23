#!/usr/bin/env bash
# Every hybrid domain has a certificate binding, so it gets its
# autoconfig./autodiscover. SAN rows (#371). Read-only.
source "$(dirname "$0")/../lib.sh"

n="$(db "SELECT COUNT(*) FROM domains WHERE type='hybrid'")"
[[ "$n" =~ ^[0-9]+$ ]] || { fail "cannot query domains"; done_check; }
[[ "$n" -gt 0 ]] || skip "no hybrid domains on this install"

unbound="$(db "SELECT GROUP_CONCAT(d.domain) FROM domains d LEFT JOIN mailbox_domains md ON md.domain = d.domain WHERE d.type='hybrid' AND md.id IS NULL")"
[[ -z "$unbound" || "$unbound" == "NULL" ]] && pass "all $n hybrid domain(s) have a certificate binding" \
    || fail "hybrid domain(s) without a certificate binding: $unbound"

nosan="$(db "SELECT GROUP_CONCAT(d.domain) FROM domains d WHERE d.type='hybrid' AND NOT EXISTS (SELECT 1 FROM mailbox_sans s WHERE s.mailbox_domain='1' AND s.subdomain LIKE CONCAT('%.', d.domain))")"
[[ -z "$nosan" || "$nosan" == "NULL" ]] && pass "all hybrid domains have SAN rows (autoconfig/autodiscover)" \
    || fail "hybrid domain(s) without SAN rows: $nosan"

noquota="$(db "SELECT GROUP_CONCAT(domain) FROM domains WHERE type='hybrid' AND (default_quota_mb IS NULL OR default_quota_mb = 0)")"
[[ -z "$noquota" || "$noquota" == "NULL" ]] && pass "all hybrid domains have a default quota" \
    || fail "hybrid domain(s) without a default quota: $noquota"

done_check
