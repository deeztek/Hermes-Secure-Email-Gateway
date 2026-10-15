#!/usr/bin/env bash
# v261015's code changes are in the installed tree. Read-only.
source "$(dirname "$0")/../lib.sh"

w=config/hermes/var/www/html/admin/2
check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}
absent() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && fail "$3 (still in $1)" || pass "$3"
}

check $w/inc/recipient_portal_accounts_action.cfm 'portalMode' \
    "portal account provisioning action present (#359)"
check $w/view_internal_recipients.cfm 'id="provisionMissingBtn"' \
    "Relay Recipients banner provisions recipients without an account (#359)"
check $w/view_internal_recipients.cfm 'id="fltDomain"' \
    "Relay Recipients filter row with Domain (#359)"
check $w/view_mailboxes.cfm 'id="mailboxFilters"' \
    "Mailboxes filter row (#359)"
check $w/inc/send_recipient_welcome_email.cfm 'welcomeExtraMessage' \
    "welcome email carries the admin's message (#359)"
check $w/inc/cert_queue_failures.cfm 'failedJobMap' \
    "certificate/keyring failures named per recipient (#364)"
check $w/view_mailboxes.cfm 'cert_queue_failures.cfm' \
    "Mailboxes shows generation failures (#364)"
absent $w/view_score_overrides.cfm 'restart_spamassassin.cfm' \
    "Score Overrides save lints and restarts once"
absent $w/inc/spam_settings_save.cfm 'restart_spamassassin.cfm' \
    "Antispam Settings save lints and restarts once"
[[ -x scripts/audit_legacy_migration.sh ]] && pass "scripts/audit_legacy_migration.sh present and executable" \
    || fail "scripts/audit_legacy_migration.sh missing or not executable"

done_check
