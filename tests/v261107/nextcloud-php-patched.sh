#!/usr/bin/env bash
# The PHP inside hermes_nextcloud has no known security fix outstanding.
# Read-only. Asks php.net which releases exist for the running PHP minor and
# fails if any newer one is a security release. Nextcloud's official image
# bundles PHP, so a stale base image can ship a vulnerable PHP even when the
# Nextcloud version is current (PHP2Shell, CVE-2026-109618/109619, was fixed
# in 8.5.12 / 8.4.27 / 8.3.36 / 8.2.35 on 2026-10-21).
source "$(dirname "$0")/../lib.sh"

docker ps --format '{{.Names}}' | grep -qx hermes_nextcloud || skip "hermes_nextcloud is not running"

ver="$(docker exec hermes_nextcloud php -r 'echo PHP_VERSION;' 2>/dev/null)"
[[ "$ver" =~ ^([0-9]+\.[0-9]+)\.([0-9]+)$ ]] || { fail "could not read the PHP version in hermes_nextcloud ('$ver')"; done_check; }
minor="${BASH_REMATCH[1]}"

json="$(curl -fsS --max-time 15 "https://www.php.net/releases/index.php?json&version=${minor}&max=50" 2>/dev/null)"
[[ -n "$json" ]] || skip "php.net is unreachable; check by hand: hermes_nextcloud runs PHP $ver"

result="$(python3 -c '
import json, sys
cur = tuple(int(x) for x in sys.argv[1].split("."))
d = json.loads(sys.stdin.read())
newer = sorted((tuple(int(x) for x in k.split(".")), "security" in (v.get("tags") or []))
               for k, v in d.items() if k.count(".") == 2)
newer = [(v, s) for v, s in newer if v > cur]
sec = [".".join(map(str, v)) for v, s in newer if s]
print("SECURITY " + " ".join(sec) if sec else ("NEWER " + ".".join(map(str, newer[-1][0])) if newer else "CURRENT"))
' "$ver" <<< "$json" 2>/dev/null)"

case "$result" in
    CURRENT)    pass "hermes_nextcloud PHP $ver is the latest $minor release" ;;
    NEWER\ *)   pass "hermes_nextcloud PHP $ver has no security release outstanding (newer bug-fix release: ${result#NEWER })" ;;
    SECURITY\ *) fail "hermes_nextcloud PHP $ver is missing security release(s) ${result#SECURITY }: rebuild hermes-nextcloud with --pull (or raise NCVERSION) before shipping" ;;
    *)          fail "could not evaluate php.net release data for PHP $minor" ;;
esac
done_check
