#!/usr/bin/env bash
# Dovecot's quota warning reaches Hermes and Hermes hands Postfix a message.
# Regression for #349 (v261008): the warning depended on an API token that
# fresh installs never had, and on creds mounts that did not exist.
# Sends one real "Mailbox Quota Notification" to the first mailbox.
source "$(dirname "$0")/../lib.sh"

docker ps --format '{{.Names}}' | grep -qx hermes_dovecot || skip "hermes_dovecot not running"

user="$(db "SELECT username FROM mailboxes WHERE username LIKE '%@%' ORDER BY username LIMIT 1")"
[[ -n "$user" ]] || skip "no mailboxes on this install"

since="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
sleep 1

if docker exec hermes_dovecot sh /scripts/quota-warning.sh 85 "$user"; then
    pass "quota-warning.sh ran"
else
    fail "quota-warning.sh exited non-zero"
fi

sent() { docker logs --since "$since" hermes_postfix_dkim 2>&1 | grep -q "to=<$user>"; }
if wait_for 30 sent; then
    pass "Postfix received the quota notification for $user"
else
    fail "no Postfix entry for $user within 30s (Lucee mail.log has the reason)"
fi

done_check
