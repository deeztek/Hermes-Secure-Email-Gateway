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

# Relay host credential rows exist (older installs lacked relay_host_password,
# so the console's UPDATE silently dropped the password).
for p in relay_host_username relay_host_password; do
    [[ "$(db "SELECT COUNT(*) FROM system_settings WHERE parameter='$p'")" -ge 1 ]] \
        && pass "system_settings has $p" || fail "system_settings is missing $p"
done

# Mailboxes quota column: usage under 1 GB in MB
check $w/admin/2/view_mailboxes.cfm 'usedGb \* 1024' "Mailboxes shows usage under 1 GB in MB"

# #356: Mail Import escapes only "%{" in the source credentials
check $w/schedule/mail_import.cfm 'Replace(sourcePass, "%{", "%%{", "all")' "Mail Import passes a source password containing % unchanged (#356)"
if grep -q 'Replace(sourcePass, "%", "%%", "all")' "$w/schedule/mail_import.cfm" 2>/dev/null; then
    fail "Mail Import still doubles every % in the source password (#356)"
fi

# #402: Lucee 6.2 on Java 21
check $w/server.json '"cfengine":"lucee@6\.2\.' "server.json pins Lucee 6.2 (#402)"
# Lucee 6.2 includes a trailing newline when decoding the key; Lucee 5 did
# not. With one, every credential stored before the upgrade fails to decrypt.
key=config/hermes/opt/hermes/keys/hermes.key
if [[ -f "$key" ]]; then
    if [[ "$(wc -c < "$key")" -eq "$(tr -d ' \t\r\n' < "$key" | wc -c)" ]]; then
        pass "hermes.key has no trailing newline (#402)"
    else
        fail "hermes.key has trailing whitespace: stored credentials will not decrypt on Lucee 6.2 (#402)"
    fi
fi
df=Docker/commandbox/dockerfiles/commandbox/Dockerfile
if [[ -f "$df" ]]; then
    baked="$(sed -n 's/^ARG LUCEE_VERSION=//p' "$df")"
    pinned="$(grep -o '"cfengine":"lucee@[^"]*"' $w/server.json | sed 's/.*@//; s/"$//')"
    [[ -n "$baked" && "$baked" == "$pinned" ]] && pass "image bakes the Lucee engine server.json asks for ($baked) (#402)" || fail "Dockerfile bakes Lucee '$baked' but server.json asks for '$pinned' (#402)"
fi
[[ -x updates/v261107/pre-scripts/30-lucee-serverhome.sh ]] && pass "Lucee server-home pre-script present and executable (#402)" || fail "updates/v261107/pre-scripts/30-lucee-serverhome.sh missing or not executable"
if docker ps --format '{{.Names}}' | grep -qx hermes_commandbox; then
    jv="$(docker exec hermes_commandbox java -version 2>&1 | sed -n 's/.*version "\([0-9]*\).*/\1/p' | head -1)"
    [[ "$jv" -ge 21 ]] 2>/dev/null && pass "hermes_commandbox runs Java $jv (#402)" || fail "hermes_commandbox Java is '$jv', expected 21 or newer (#402)"
    lv="$(docker exec hermes_commandbox box server info name=hermesseg property=engineVersion 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    [[ "$lv" == 6.2.* ]] && pass "CommandBox reports Lucee $lv (#402)" || fail "CommandBox reports Lucee '$lv', expected 6.2.x (#402)"
    docker exec hermes_commandbox sh -c 'ls /serverhome/WEB-INF/lucee-server/bundles/com.mysql.jdbc-*.jar' >/dev/null 2>&1 && pass "baked MySQL driver bundle is in the server home (#402)" || fail "no com.mysql.jdbc bundle in /serverhome; datasources would need update.lucee.org (#402)"
fi

# Authelia 4.39.28
ver_ge() { [[ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" == "$2" ]]; }
av="$(sed -n 's/^AUTHELIAVERSION=//p' .env 2>/dev/null | tr -d '\r' | head -1)"
ver_ge "$av" 4.39.28 && pass "AUTHELIAVERSION=$av in .env (4.39.28 or newer)" || fail "AUTHELIAVERSION is '$av', expected 4.39.28 or newer"
if docker ps --format '{{.Names}}' | grep -qx hermes_authelia; then
    ai="$(docker inspect -f '{{.Config.Image}}' hermes_authelia 2>/dev/null)"
    ver_ge "${ai##*:}" 4.39.28 && pass "hermes_authelia runs $ai" || fail "hermes_authelia runs '$ai', expected 4.39.28 or newer"
fi
