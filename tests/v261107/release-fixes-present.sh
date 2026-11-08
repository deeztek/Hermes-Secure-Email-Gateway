#!/usr/bin/env bash
# v261107 release contents present. Read-only.
source "$(dirname "$0")/../lib.sh"

check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}
w=config/hermes/var/www/html

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261107" ]] && fail "build_no is $build, expected v261107 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

# #401: no password change or reset path may hand the user's new password to
# Nextcloud. The only resetpassword callers left use random values.
for f in admin/2/inc/edit_mailbox_action.cfm admin/2/inc/process_admin_password_reset.cfm \
         user-auth/reset_password.cfm users/2/user_settings.cfm; do
    if grep -q 'user:resetpassword' "$w/$f" 2>/dev/null; then
        fail "$f still sets the Nextcloud local password (#401)"
    else
        pass "$f leaves the Nextcloud local password alone (#401)"
    fi
done
check $w/schedule/post_upgrade.cfm "nextcloud-local-password-random-v1" "upgrade resets Nextcloud local passwords to random (#401)"

# #400
check $w/admin/2/inc/nextcloud_mail_account.cfm "mail:repair:tags" "new Nextcloud Mail accounts get their default tags (#400)"
check $w/schedule/post_upgrade.cfm "nextcloud-mail-default-tags-v1" "upgrade adds missing Nextcloud Mail default tags (#400)"

# Mailboxes quota column: usage under 1 GB in MB
check $w/admin/2/view_mailboxes.cfm 'usedGb \* 1024' "Mailboxes shows usage under 1 GB in MB"
