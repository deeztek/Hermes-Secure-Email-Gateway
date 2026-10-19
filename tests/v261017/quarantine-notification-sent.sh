#!/usr/bin/env bash
# A quarantined message produces a real quarantine notification, so the
# release link in it can be tested by hand (MANUAL.md: confirm page first,
# released only by the button).
#
# Sends one GTUBE test message (always scored as spam, so quarantined) to a
# recipient over SMTP from a throwaway container on Docker's default bridge,
# so it arrives like outside mail. The message stays in quarantine for the
# manual release check.
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

subj="Hermes quarantine test $(date +%s)"
since="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
sleep 1
if out="$(printf 'From: Quarantine Test <%s>\r\nTo: <%s>\r\nSubject: %s\r\nDate: %s\r\nMessage-ID: <%s@hermes-test>\r\n\r\nXJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X\r\n' \
        "$from" "$rcpt" "$subj" "$(date -R)" "$(date +%s%N)" \
    | docker run --rm -i curlimages/curl:8.10.1 -sS --url "smtp://$gw:25" \
        --mail-from "$from" --mail-rcpt "$rcpt" -T - 2>&1)"; then
    pass "Postfix accepted the GTUBE test message for $rcpt"
else
    fail "SMTP send refused: $out"
    done_check
fi

ds() { db "SELECT mr.ds FROM msgrcpt mr JOIN msgs m ON m.mail_id = mr.mail_id WHERE m.subject = '$subj' LIMIT 1"; }
quarantined() { [[ "$(ds)" =~ ^[BD]$ ]]; }
if wait_for 90 quarantined; then
    pass "test message quarantined (ds=$(ds))"
else
    fail "test message not quarantined within 90s (ds='$(ds)'; empty = never reached Amavis, see docker logs hermes_postfix_dkim)"
    done_check
fi

# Ofelia runs the notifier every minute; run it now instead of waiting.
docker exec hermes_commandbox curl -s http://localhost:8888/schedule/quarantine_notify.cfm >/dev/null
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

echo "  NOTE  manual: open the notification \"$subj\" in $rcpt's mailbox and use its release link (MANUAL.md)"
done_check
