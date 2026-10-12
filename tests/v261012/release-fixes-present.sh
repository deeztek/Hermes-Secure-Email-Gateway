#!/usr/bin/env bash
# v261012's code fixes are in the installed tree. Read-only.
source "$(dirname "$0")/../lib.sh"

w=config/hermes/var/www/html/admin/2
check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}

check $w/inc/restart_opendkim.cfm "postfix status" \
    "DKIM save waits for Postfix after the container restart (#351)"
check $w/inc/update_spamassassin_config_files.cfm 'action="write" file="/etc/spamassassin/local.cf"' \
    "local.cf written in place, not moved (#352)"
check $w/inc/update_spamassassin_config_files.cfm "HERMES_LINT_EXIT" \
    "new local.cf linted, previous restored on failure (#352)"
check $w/view_message_rules.cfm 'cfparam name="form.edit_header"' \
    "body-rule edit tolerates the missing header field (#352)"
check $w/view_message_rules.cfm "insertedRule.generatedKey" \
    "rejected message rule is not stored (#352)"
check $w/inc/generate_antivirus_configuration.cfm 'FileExists("/var/lib/clamav/local.ign2")' \
    "Antivirus save tolerates a missing local.ign2 (#352)"
check $w/api/get_message_stats.cfm '"720"' \
    "Messages Processed offers 30 days (#355)"
check scripts/install_hermes_docker.sh "--provision-dirs)" \
    "installer has non-interactive --provision-dirs (#348)"
check scripts/system_update_docker.sh "install_hermes_docker.sh\" --provision-dirs" \
    "upgrade provisions storage directories before compose up (#348)"
check config/hermes/var/www/html/schedule/acme_validate_ip.cfm "sync_mailbox_sans.cfm" \
    "scheduled SAN validation rebuilds mailbox_sans first (#319)"
check $w/inc/mailbox_domain_delete_action.cfm "checkAliases" \
    "mailbox domain delete refuses while aliases exist (#320)"
check config/hermes/opt/hermes/conf_files/main.cf.HERMES "smtpd_relay_before_recipient_restrictions = no" \
    "relay-before-recipient set explicitly (#318)"
check scripts/hermes_smoke_test.sh "hermes_linkguard" \
    "smoke test covers hermes_linkguard (#281)"
check scripts/system_update_docker.sh "--no-prune)" \
    "updater accepts --no-prune (#340)"
check scripts/migrate_legacy_to_docker.sh 'MODE" != "archive"' \
    "archive-only migration restore exempt from the release guard (#354)"

done_check
