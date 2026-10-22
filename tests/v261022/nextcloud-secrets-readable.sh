#!/usr/bin/env bash
# Nextcloud (www-data) can read every Docker secret it is given. At 0600 it
# cannot reach its database or Redis (occ "NOAUTH Authentication required").
# Regression for v261022 (legacy migration set creds/ to 0600). Read-only.
source "$(dirname "$0")/../lib.sh"

docker ps --format '{{.Names}}' | grep -qx hermes_nextcloud || skip "hermes_nextcloud not running"

bad="$(docker exec -u www-data hermes_nextcloud sh -c 'for f in /run/secrets/*; do [ -r "$f" ] || echo "$f"; done' 2>/dev/null)"
[[ -z "$bad" ]] && pass "www-data can read all of Nextcloud's secrets" \
    || fail "Nextcloud cannot read: $(echo $bad)"

done_check
