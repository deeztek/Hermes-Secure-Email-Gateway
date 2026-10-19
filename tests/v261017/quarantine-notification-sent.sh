#!/usr/bin/env bash
# A quarantined message produces a real quarantine notification, so the
# release link in it can be tested by hand (MANUAL.md: confirm page first,
# released only by the button).
#
# Sends one message carrying the EICAR antivirus test file to a recipient over
# SMTP from a throwaway container. Virus quarantine keeps a copy whatever the
# mail's origin. (From this host the message arrives as local-network mail,
# where spam such as GTUBE is dropped WITHOUT a copy above the quarantine
# cutoff, so spam cannot be used here.) The message stays in quarantine for
# the manual release check.
#
# Recipient: $QTEST_RCPT if set, else one that already has notifications on,
# else the first recipient (notifications switched on for this test and put
# back afterwards). Sender: $QTEST_FROM, else quarantine-test@<recipient domain>.
source "$(dirname "$0")/../lib.sh"

addr_re='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+$'

rcpt="${QTEST_RCPT:-}"
[[ -n "$rcpt" ]] || rcpt="$(db "SELECT us.email FROM user_settings us JOIN recipients r ON r.recipient = us.email
                              WHERE us.report_enabled IN ('YES','ALL') ORDER BY us.email LIMIT 1")"
[[ -n "$rcpt" ]] || rcpt="$(db "SELECT recipient FROM recipients WHERE recipient LIKE '%_@_%' ORDER BY id LIMIT 1")"
[[ -n "$rcpt" ]] || skip "no recipients on this install"
[[ "$rcpt" =~ $addr_re ]] || { fail "unexpected recipient address: $rcpt"; done_check; }
[[ "$(db "SELECT COUNT(*) FROM recipients WHERE recipient = '$rcpt'")" != "0" ]] \
    || { fail "$rcpt is not a Hermes recipient (Relay Recipients or Mailboxes); notifications only go to recipients"; done_check; }
from="${QTEST_FROM:-quarantine-test@${rcpt#*@}}"
[[ "$from" =~ $addr_re ]] || { fail "unexpected sender address: $from"; done_check; }

# Notifications on for the recipient, put back on exit.
prev="$(db "SELECT IFNULL(report_enabled,'') FROM user_settings WHERE email = '$rcpt' LIMIT 1")"
had_row="$(db "SELECT COUNT(*) FROM user_settings WHERE email = '$rcpt'")"
restore() {
    if [[ "$had_row" == "0" ]]; then
        db "DELETE FROM user_settings WHERE email = '$rcpt'" >/dev/null
    elif [[ "$prev" != "YES" && "$prev" != "ALL" ]]; then
        db "UPDATE user_settings SET report_enabled = NULLIF('$prev','') WHERE email = '$rcpt'" >/dev/null
    fi
}
trap restore EXIT
if [[ "$had_row" == "0" ]]; then
    db "INSERT INTO user_settings (email, datetime, report_enabled) VALUES ('$rcpt', NOW(), 'YES')" >/dev/null
elif [[ "$prev" != "YES" && "$prev" != "ALL" ]]; then
    db "UPDATE user_settings SET report_enabled = 'YES' WHERE email = '$rcpt'" >/dev/null
fi

gw="$(docker network inspect bridge -f '{{(index .IPAM.Config 0).Gateway}}' 2>/dev/null)"
[[ -n "$gw" ]] || { fail "cannot find Docker's default bridge gateway"; done_check; }

# The EICAR test file, assembled here so this script itself is not flagged by
# antivirus scanners. Attached as its exact 68 bytes, which is what ClamAV
# matches.
eicar_a='X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR'
eicar_b='-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
eicar_b64="$(printf '%s' "${eicar_a}${eicar_b}" | base64 -w0)"

subj="Hermes quarantine test $(date +%s)"
boundary="hermes-test-$(date +%s%N)"
since="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
sleep 1
if out="$(printf 'From: Quarantine Test <%s>\r\nTo: <%s>\r\nSubject: %s\r\nDate: %s\r\nMessage-ID: <%s@hermes-test>\r\nMIME-Version: 1.0\r\nContent-Type: multipart/mixed; boundary="%s"\r\n\r\n--%s\r\nContent-Type: text/plain\r\n\r\nHermes release test: the attachment is the harmless EICAR antivirus test file.\r\n\r\n--%s\r\nContent-Type: application/octet-stream; name="eicar.com"\r\nContent-Disposition: attachment; filename="eicar.com"\r\nContent-Transfer-Encoding: base64\r\n\r\n%s\r\n--%s--\r\n' \
        "$from" "$rcpt" "$subj" "$(date -R)" "$(date +%s%N)" "$boundary" "$boundary" "$boundary" "$eicar_b64" "$boundary" \
    | docker run --rm -i curlimages/curl:8.10.1 -sS --url "smtp://$gw:25" \
        --mail-from "$from" --mail-rcpt "$rcpt" -T - 2>&1)"; then
    pass "Postfix accepted the test message for $rcpt"
else
    fail "SMTP send refused: $out"
    done_check
fi

row() { db "SELECT CONCAT(mr.ds, '|', IFNULL(m.quar_loc, '')) FROM msgrcpt mr JOIN msgs m ON m.mail_id = mr.mail_id WHERE m.subject = '$subj' LIMIT 1"; }
kept() { [[ "$(row)" =~ ^[BD]\|.+ ]]; }
if wait_for 90 kept; then
    pass "test message quarantined with a copy ($(row))"
else
    fail "test message not quarantined with a copy within 90s (ds|quar_loc='$(row)'; empty = never reached Amavis, see docker logs hermes_postfix_dkim and hermes_mail_filter)"
    done_check
fi

# Ofelia runs the notifier every minute; run it now instead of waiting.
docker exec hermes_commandbox curl -s -m 120 http://localhost:8888/schedule/quarantine_notify.cfm >/dev/null \
    || echo "  NOTE  notifier call did not finish within 120s; waiting for the scheduled run"
flag() { db "SELECT mr.notification_sent FROM msgrcpt mr JOIN msgs m ON m.mail_id = mr.mail_id WHERE m.subject = '$subj' LIMIT 1"; }
notified() { [[ "$(flag)" == "1" ]]; }
if wait_for 90 notified; then
    pass "quarantine notification generated"
else
    fail "no notification within 90s (notification_sent='$(flag)'; 2 = recipient skipped)"
    done_check
fi

sent() { docker logs --since "$since" hermes_postfix_dkim 2>&1 | grep "to=<$rcpt>" | grep -q 'status=sent'; }
if wait_for 60 sent; then
    pass "notification delivered to $rcpt"
else
    fail "notification for $rcpt not delivered within 60s (docker logs hermes_postfix_dkim)"
fi

echo "  NOTE  manual: open the notification for \"$subj\" in $rcpt's mailbox and use its release link (MANUAL.md)"
done_check
