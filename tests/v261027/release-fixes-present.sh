#!/usr/bin/env bash
# v261027 release contents present. Read-only.
source "$(dirname "$0")/../lib.sh"

check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}
w=config/hermes/var/www/html

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261027" ]] && fail "build_no is $build, expected v261027 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

for t in banner_with_logo compact_text modern_card promo_footer two_column_pro with_social_bar; do
    check $w/admin/2/inc/org_signature_templates/$t.cfm "{{org.name}}" "organizational signature $t shows the company name (#375)"
done
check $w/schedule/post_upgrade.cfm "linkguard-config" "upgrade refreshes the Link Guard engine config (#374)"
check $w/admin/2/view_linkguard.cfm "test_apikey" "Link Guard API keys can be tested"
grep -q "{{org.logo}}" $w/admin/2/view_mailbox_domains.cfm \
    && fail "Email Server > Domains still advertises {{org.logo}} (#375)" \
    || pass "Email Server > Domains no longer advertises {{org.logo}} (#375)"

done_check
