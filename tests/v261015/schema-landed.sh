#!/usr/bin/env bash
# v261015 schema: build stamp, and no legacy user_settings.id (#362). Read-only.
source "$(dirname "$0")/../lib.sh"

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261015" ]] && fail "build_no is $build, expected v261015 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

n="$(db "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='hermes' AND table_name='user_settings' AND column_name='id'")"
[[ "$n" == "0" ]] && pass "user_settings has no legacy id column" \
    || fail "user_settings.id still exists ('$n'); adding a relay recipient fails on migrated installs (#362)"

done_check
