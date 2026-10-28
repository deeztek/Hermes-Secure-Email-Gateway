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
check $w/admin/2/inc/org_signature_write_files.cfm "orgSigLinkRe" "plain-text org signatures keep link targets"
check $w/admin/2/inc/nextcloud_provision_user.cfm "tag-classified-messages" "new mailboxes: Nextcloud Mail importance tagging off"
check $w/schedule/post_upgrade.cfm "nextcloud-mail-importance-tagging-off-v1" "upgrade turns importance tagging off and clears its tags"
if docker ps --format '{{.Names}}' | grep -qx hermes_body_milter; then
    docker exec hermes_body_milter grep -q "_add_html_alternative" /usr/local/bin/hermes-body-milter 2>/dev/null \
        && pass "body milter adds an HTML version to plain-text signed mail" \
        || fail "body milter image predates the plain-text signature fix"
fi
check $w/users/2/user_settings.cfm "mfaEnableModal" "user portal: Enable 2FA asks for confirmation first"
check $w/admin/2/edit_org_signature.cfm "updateGalleryLock" "org signature: domain before template (#382)"
check $w/admin/2/inc/disclaimer_write_and_reload.cfm "Plain-text cleanup" "plain-text disclaimers: no blank runs or HTML codes"
grep -q "{{org.logo}}" $w/admin/2/view_mailbox_domains.cfm \
    && fail "Email Server > Domains still advertises {{org.logo}} (#375)" \
    || pass "Email Server > Domains no longer advertises {{org.logo}} (#375)"

done_check
