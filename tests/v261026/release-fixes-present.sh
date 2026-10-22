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

done_check
