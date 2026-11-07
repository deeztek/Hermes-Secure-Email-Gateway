#!/usr/bin/env bash
# v261022 release contents present. Read-only.
source "$(dirname "$0")/../lib.sh"

check() {  # <file> <pattern> <description>
    grep -q -- "$2" "$1" 2>/dev/null && pass "$3" || fail "$3 (not found in $1)"
}

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261022" ]] && fail "build_no is $build, expected v261022 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

# Later releases raise Nextcloud further, so 33.0.10 is a floor, not a pin.
nc_tpl="$(sed -n 's/^NCVERSION=//p' .env.template | tr -d '\r' | head -1)"
if [[ -n "$nc_tpl" && "$(printf '%s\n%s\n' 33.0.10 "$nc_tpl" | sort -V | head -1)" == "33.0.10" ]]; then
    pass ".env.template ships Nextcloud $nc_tpl (33.0.10 or newer)"
else
    fail ".env.template ships Nextcloud '$nc_tpl', expected 33.0.10 or newer"
fi
check scripts/migrate_legacy_to_docker.sh 'chmod 644 .*creds/"nextcloud_' "legacy migration keeps Nextcloud's secrets readable"
[[ -x updates/v261022/pre-scripts/10-nextcloud-secret-modes.sh && -x updates/v261022/pre-scripts/20-nextcloud-php-fix.sh ]] \
    && pass "v261022 pre-scripts present and executable" || fail "v261022 pre-scripts missing or not executable"

done_check
