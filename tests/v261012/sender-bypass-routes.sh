#!/usr/bin/env bash
# Global Sender Rules allow entries route to the mail filter and no legacy
# rows are left hidden (#358). Read-only.
source "$(dirname "$0")/../lib.sh"

n="$(db "SELECT COUNT(*) FROM amavis_sender_bypass WHERE transport LIKE '%[127.0.0.1]:10030%'")"
[[ "$n" == "0" ]] && pass "no allow entry stores the legacy amavis address" || fail "$n row(s) still route to [127.0.0.1]:10030"

n="$(db "SELECT COUNT(*) FROM amavis_sender_bypass WHERE action IN ('add','ADD')")"
[[ "$n" == "0" ]] && pass "no legacy action='add' rows left hidden" || fail "$n legacy row(s) still have action='add'"

c="$(docker exec hermes_postfix_dkim sh -c 'grep -c "\[127\.0\.0\.1\]:10030" /etc/postfix/amavis_senderbypass 2>/dev/null' || true)"
[[ "${c:-0}" == "0" ]] && pass "live amavis_senderbypass map has no legacy address" || fail "live map still has $c legacy line(s)"

done_check
