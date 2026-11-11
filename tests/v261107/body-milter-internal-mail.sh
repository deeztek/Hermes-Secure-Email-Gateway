#!/usr/bin/env bash
# #407: outbound modifiers (signature, disclaimer, Link Guard restore) run on
# 'internal' mail (local sender, at least one local recipient) when Postfix
# trusts the client to relay (submission, SASL login, or a client in
# mynetworks such as Nextcloud Mail), and still skip it from any other
# port 25 client. Loads the repo's hermes-body-milter in a THROWAWAY container
# of the hermes_body_milter image with no network; nothing live is touched.
source "$(dirname "$0")/../lib.sh"

image="${BODY_MILTER_TEST_IMAGE:-$(docker inspect -f '{{.Config.Image}}' hermes_body_milter 2>/dev/null)}"
[[ -n "$image" ]] || skip "hermes_body_milter is not running (needed for its image)"
milter="${BODY_MILTER_TEST_SRC:-$HERMES_ROOT/Docker/body_milter/config/usr/local/bin/hermes-body-milter}"
[[ -f "$milter" ]] || { fail "milter not found: $milter"; done_check; }

out="$(docker run --rm --network none --entrypoint python3 \
        -v "$milter:/t/milter.py:ro" "$image" -I -c '
import importlib.machinery, importlib.util, tempfile
ld = tempfile.NamedTemporaryFile("w", delete=False)
ld.write("example.com OK\nrelayed.example OK\n"); ld.close()
loader = importlib.machinery.SourceFileLoader("hbm", "/t/milter.py")
spec = importlib.util.spec_from_loader("hbm", loader)
m = importlib.util.module_from_spec(spec); loader.exec_module(m)
m.local_domains = m.LocalDomains(ld.name)

class Out(m.Modifier):
    direction = "outbound"
class In(m.Modifier):
    direction = "inbound"

def ctx(sender, rcpts, trusted):
    return m.MessageContext(sender, rcpts, b"", b"", trusted_sender=trusted)

cases = [
    ("external recipient, untrusted: outbound runs", Out, "a@example.com", ["x@gmail.com"], False, True),
    ("relay-domain recipient, submitted: outbound runs", Out, "a@example.com", ["b@relayed.example"], True, True),
    ("relay-domain + external, submitted: outbound runs", Out, "a@example.com", ["b@relayed.example", "x@gmail.com"], True, True),
    ("relay-domain recipient, port 25 unauthenticated: outbound skips", Out, "a@example.com", ["b@relayed.example"], False, False),
    ("internal, submitted: inbound modifiers still skip", In, "a@example.com", ["b@relayed.example"], True, False),
    ("external sender to local: inbound runs", In, "x@gmail.com", ["b@example.com"], False, True),
]
for label, cls, s, r, t, want in cases:
    got = cls().applies_to(ctx(s, r, t))
    print(("PASS" if got == want else "FAIL") + "\t" + label)

# Trust comes from the Postfix macros
class FakeMilter(m.HermesBodyMilter):
    def __init__(self, macros):
        super().__init__(); self._macros = macros
        self._protocol = 0  # pymilter internal, set by libmilter at negotiation
    def getsymval(self, name):
        return self._macros.get(name)
import inspect
if not hasattr(m, "TrustedNetworks"):
    print("FAIL\tmilter has no trusted networks support"); raise SystemExit
# mynetworks as the console writes it: one entry per line, any Postfix form
tn = tempfile.NamedTemporaryFile("w", delete=False)
tn.write("127.0.0.0/8\n[::1]/128\n172.16.32.0/24\n198.51.100.7\nmx.example.org\nhash:/etc/postfix/network_table\n"); tn.close()
m.trusted_networks = m.TrustedNetworks(tn.name)

def trusted(macros, ip):
    f = FakeMilter(macros)
    f.connect("h", 0, (ip, 1)); f.envfrom("<a@example.com>")
    return (f._daemon_name == "ORIGINATING" or bool(f._auth_authen)
            or m.trusted_networks.contains(f._client_ip))

p25 = {"{daemon_name}": "mx.example.com"}
for label, macros, ip, want in [
    ("daemon_name=ORIGINATING is trusted", {"{daemon_name}": "ORIGINATING"}, "203.0.113.9", True),
    ("SASL login is trusted", {"{daemon_name}": "mx.example.com", "{auth_authen}": "a@example.com"}, "203.0.113.9", True),
    ("port 25, no login, internet client is not trusted", p25, "203.0.113.9", False),
    ("port 25, no login, Docker subnet client (Nextcloud Mail) is trusted", p25, "172.16.32.101", True),
    ("port 25, no login, single-address Relay Network is trusted", p25, "198.51.100.7", True),
    ("bracketed IPv6 entry is understood", p25, "::1", True),
]:
    got = trusted(macros, ip)
    print(("PASS" if got == want else "FAIL") + "\t" + label)

import os
os.unlink(tn.name)
got = trusted(p25, "172.16.32.101")
print(("PASS" if got is False else "FAIL") + "\tno trusted_networks file: only logged-in senders are trusted")
' 2>&1)"

[[ -n "$out" ]] || { fail "test produced no output"; done_check; }
while IFS=$'\t' read -r verdict label; do
    case "$verdict" in
        PASS) pass "$label (#407)" ;;
        FAIL) fail "$label (#407)" ;;
        *)    fail "unexpected output: $verdict $label" ;;
    esac
done <<< "$out"
done_check
