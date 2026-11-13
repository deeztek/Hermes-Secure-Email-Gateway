#!/usr/bin/env bash
# #411: a message redirected by Sieve (Forwarding, a Mail Filters redirect)
# re-enters Postfix from Dovecot, which is in mynetworks. Every body modifier
# must pass it through unchanged: it already got its signature, disclaimer,
# banner and Link Guard rewrite on the first pass. The X-Sieve-Redirected-From
# header is only honoured from a trusted client. Loads the repo's
# hermes-body-milter in a THROWAWAY container of the hermes_body_milter image
# with no network; nothing live is touched.
source "$(dirname "$0")/../lib.sh"

image="${BODY_MILTER_TEST_IMAGE:-$(docker inspect -f '{{.Config.Image}}' hermes_body_milter 2>/dev/null)}"
[[ -n "$image" ]] || skip "hermes_body_milter is not running (needed for its image)"
milter="${BODY_MILTER_TEST_SRC:-$HERMES_ROOT/Docker/body_milter/config/usr/local/bin/hermes-body-milter}"
[[ -f "$milter" ]] || { fail "milter not found: $milter"; done_check; }

out="$(docker run --rm --network none --entrypoint python3 \
        -v "$milter:/t/milter.py:ro" "$image" -I -c '
import importlib.machinery, importlib.util, tempfile
ld = tempfile.NamedTemporaryFile("w", delete=False)
ld.write("example.com OK\n"); ld.close()
loader = importlib.machinery.SourceFileLoader("hbm", "/t/milter.py")
spec = importlib.util.spec_from_loader("hbm", loader)
m = importlib.util.module_from_spec(spec); loader.exec_module(m)
m.local_domains = m.LocalDomains(ld.name)
if not hasattr(m, "RE_SIEVE_REDIRECTED"):
    print("FAIL\tmilter has no Sieve redirect handling"); raise SystemExit

class Out(m.Modifier):
    direction = "outbound"
class In(m.Modifier):
    direction = "inbound"

RED = b"X-Sieve-Redirected-From: a@example.com\r\nSubject: hi\r\n"
PLAIN = b"Subject: hi\r\n"

def ctx(sender, rcpts, hdrs, trusted):
    return m.MessageContext(sender, rcpts, hdrs, b"", trusted_sender=trusted)

cases = [
    ("colleague mail redirected by Dovecot: outbound modifiers skip", Out, "c@example.com", ["b@example.com"], RED, True, False),
    ("external mail redirected by Dovecot: inbound modifiers skip", In, "x@gmail.com", ["b@example.com"], RED, True, False),
    ("redirect to an outside address: outbound modifiers skip", Out, "c@example.com", ["x@gmail.com"], RED, True, False),
    ("header from an untrusted client: inbound still runs", In, "x@gmail.com", ["b@example.com"], RED, False, True),
    ("no header, trusted internal: outbound still runs (#407)", Out, "c@example.com", ["b@example.com"], PLAIN, True, True),
    ("no header, external to local: inbound still runs", In, "x@gmail.com", ["b@example.com"], PLAIN, False, True),
]
for label, cls, s, r, h, t, want in cases:
    got = cls().applies_to(ctx(s, r, h, t))
    print(("PASS" if got == want else "FAIL") + "\t" + label)
' 2>&1)"

[[ -n "$out" ]] || { fail "test produced no output"; done_check; }
while IFS=$'\t' read -r verdict label; do
    case "$verdict" in
        PASS) pass "$label" ;;
        FAIL) fail "$label" ;;
        *)    [[ -n "$verdict" ]] && fail "unexpected output: $verdict $label" ;;
    esac
done <<< "$out"
done_check
