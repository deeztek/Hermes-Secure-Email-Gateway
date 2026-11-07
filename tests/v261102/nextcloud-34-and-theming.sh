#!/usr/bin/env bash
# Nextcloud runs 34.0.5 or newer, and shows the Hermes logo and color
# background (#399). Regression for v261102. Read-only.
source "$(dirname "$0")/../lib.sh"

docker ps --format '{{.Names}}' | grep -qx hermes_nextcloud || skip "hermes_nextcloud not running"

occ() { docker exec -u www-data hermes_nextcloud php /var/www/html/occ "$@" 2>/dev/null; }

nc="$(occ status --output=json | sed -n 's/.*"versionstring":"\([^"]*\)".*/\1/p')"
if [[ -n "$nc" && "$(printf '%s\n%s\n' 34.0.5 "$nc" | sort -V | head -1)" == "34.0.5" ]]; then
    pass "Nextcloud $nc (34.0.5 or newer)"
else
    fail "Nextcloud runs '$nc', expected 34.0.5 or newer"
fi

docker exec hermes_nextcloud test -s /img/hermes_logo_new_orange2.png \
    && pass "/img holds the Hermes logo" || fail "/img/hermes_logo_new_orange2.png missing in hermes_nextcloud"

[[ -n "$(occ config:app:get theming logoMime)" ]] \
    && pass "Nextcloud logo is set" || fail "Nextcloud logo is not set (theming logoMime empty)"

bg="$(occ config:app:get theming backgroundMime)"
[[ -n "$bg" ]] && pass "Nextcloud background is '$bg', not the default image" \
    || fail "Nextcloud background is the default image (theming backgroundMime empty)"

done_check
