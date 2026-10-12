#!/usr/bin/env bash
# The live SpamAssassin config lints clean and both containers see the same
# local.cf (#352). Read-only.
source "$(dirname "$0")/../lib.sh"

grep -q '^ifplugin Mail::SpamAssassin::Plugin::DCC' config/hermes/opt/hermes/conf_files/local.cf.HERMES \
    && pass "local.cf template guards the DCC lines" \
    || fail "local.cf template does not guard the DCC lines with ifplugin"

out="$(docker exec hermes_mail_filter spamassassin --lint 2>&1)"; rc=$?
[[ $rc -eq 0 && -z "$out" ]] && pass "spamassassin --lint is clean" \
    || fail "spamassassin --lint reported: $(echo "$out" | head -3 | tr '\n' ' ')"

# hermes_mail_filter bind-mounts local.cf as a single file; a replaced inode
# leaves it reading stale contents. Compare what commandbox wrote with what
# mail_filter reads.
a="$(docker exec hermes_commandbox md5sum /etc/spamassassin/local.cf 2>/dev/null | cut -d' ' -f1)"
b="$(docker exec hermes_mail_filter md5sum /etc/spamassassin/local.cf 2>/dev/null | cut -d' ' -f1)"
[[ -n "$a" && "$a" == "$b" ]] && pass "commandbox and mail_filter see the same local.cf" \
    || fail "local.cf differs: commandbox=$a mail_filter=$b (restart hermes_mail_filter, then save Antispam Settings)"

done_check
