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

check .env.template '^NCVERSION=33.0.10' ".env.template ships Nextcloud 33.0.10"
check scripts/migrate_legacy_to_docker.sh 'chmod 644 .*creds/"nextcloud_' "legacy migration keeps Nextcloud's secrets readable"
[[ -x updates/v261022/pre-scripts/10-nextcloud-secret-modes.sh && -x updates/v261022/pre-scripts/20-nextcloud-php-fix.sh ]] \
    && pass "v261022 pre-scripts present and executable" || fail "v261022 pre-scripts missing or not executable"

done_check
