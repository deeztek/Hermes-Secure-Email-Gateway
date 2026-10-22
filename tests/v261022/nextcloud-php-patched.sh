#!/usr/bin/env bash
# Nextcloud runs a PHP with the fix for the critical PHP RCE (CISA 2026-10-21):
# 8.4.27+ on the 8.4 branch (Nextcloud 33), 8.5.12+ on 8.5 (Nextcloud 34).
# Regression for v261022. Read-only.
source "$(dirname "$0")/../lib.sh"

docker ps --format '{{.Names}}' | grep -qx hermes_nextcloud || skip "hermes_nextcloud not running"

php="$(docker exec hermes_nextcloud php -r 'echo PHP_VERSION;' 2>/dev/null)"
[[ -n "$php" ]] || { fail "cannot read Nextcloud's PHP version"; done_check; }

case "${php%.*}" in
    8.4) need=8.4.27 ;;
    8.5) need=8.5.12 ;;
    *)   fail "Nextcloud runs PHP $php: no fixed version known for that branch"; done_check ;;
esac
if [[ "$(printf '%s\n%s\n' "$php" "$need" | sort -V | head -1)" == "$need" ]]; then
    pass "Nextcloud PHP $php (fixed from $need)"
else
    fail "Nextcloud PHP $php is older than the fixed $need"
fi

nc="$(sed -n 's/^NCVERSION=//p' .env 2>/dev/null | tr -d '\r' | head -1)"
[[ -n "$nc" ]] && pass "NCVERSION=$nc in .env" || fail "no NCVERSION in .env"

done_check
