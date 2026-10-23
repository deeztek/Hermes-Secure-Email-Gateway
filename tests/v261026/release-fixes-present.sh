#!/usr/bin/env bash
# v261026 release contents present (#371). Read-only.
source "$(dirname "$0")/../lib.sh"

check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}
w=config/hermes/var/www/html

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261026" ]] && fail "build_no is $build, expected v261026 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

check $w/admin/2/view_mailbox_domains.cfm "d.type IN ('mailbox', 'hybrid')" "Email Server > Domains lists hybrid domains (#371)"
check $w/admin/2/inc/mailbox_domain_edit_action.cfm "d.type IN ('mailbox', 'hybrid')" "hybrid domains editable (#371)"
check $w/admin/2/inc/mailbox_domain_delete_action.cfm "AND type = 'mailbox'" "hybrid domains cannot be deleted from Email Server > Domains (#371)"
check $w/admin/2/edit_internal_recipient_backend.cfm "ensure_mailbox_cert_binding.cfm" "conversion creates the certificate binding (#371)"
check $w/schedule/post_upgrade.cfm "hybrid-domain-cert-binding-v1" "upgrade repairs existing hybrid domains (#371)"

# URLhaus Auth-Key (abuse.ch retired keyless downloads)
n="$(db "SELECT COUNT(*) FROM malware_feeds_config c JOIN malware_feed_urls u ON u.feed_id=c.id WHERE c.section_name='urlhaus' AND c.api_key_1_name='auth_key' AND c.integrity_check='disabled' AND u.url_value LIKE 'https://urlhaus-api.abuse.ch/v2/files/exports/%auth_key%/urlhaus_clamav.ndb'")"
[[ "$n" == "1" ]] && pass "Malware Feeds: URLhaus uses the keyed export" || fail "Malware Feeds: URLhaus not migrated to the keyed export"
n="$(db "SELECT COUNT(*) FROM parameters2 WHERE module='linkguard' AND parameter='urlhaus_auth_key'")"
[[ "$n" == "1" ]] && pass "Link Guard: URLhaus Auth-Key setting present" || fail "Link Guard: no urlhaus_auth_key setting"
check $w/admin/2/inc/generate_malware_feeds_configuration.cfm "feedMissingKey" "a feed with an empty required key is written disabled"
check $w/admin/2/view_malware_feeds.cfm "URLhaus needs an Auth-Key" "Malware Feeds explains the URLhaus key"
check $w/admin/2/view_linkguard.cfm "urlhaus_auth_key" "Link Guard page edits the URLhaus key"
check config/mail_filter/etc/fangfrisch/fangfrisch.conf "auth.abuse.ch\|Auth-Key" "shipped fangfrisch.conf explains the URLhaus key"

# Link Guard engine (image): keyed URLhaus export, detection update
if docker ps --format '{{.Names}}' | grep -qx hermes_linkguard; then
    docker exec hermes_linkguard grep -q 'urlhaus-api.abuse.ch/v2/files/exports' /opt/linkguard/app/feeds.py 2>/dev/null \
        && pass "Link Guard engine uses the keyed URLhaus export" || fail "Link Guard engine still uses the retired URLhaus URL"
    docker exec hermes_linkguard grep -q '_UUID_LABEL_RE' /opt/linkguard/app/verdict.py 2>/dev/null \
        && pass "Link Guard detection update present" || fail "Link Guard engine lacks the detection update"
fi

done_check
