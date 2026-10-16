#!/usr/bin/env bash
# v261017 schema: build stamp, legacy user_settings columns and crontab_entries gone. Read-only.
source "$(dirname "$0")/../lib.sh"

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261017" ]] && fail "build_no is $build, expected v261017 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

left="$(db "SELECT GROUP_CONCAT(column_name) FROM information_schema.columns WHERE table_schema='hermes' AND table_name='user_settings' AND column_name IN ('password','password_set','report_frequency','reset_password_code','reset_password_ip','reset_password_datetime')")"
[[ -z "$left" || "$left" == "NULL" ]] && pass "no legacy password/reset/digest columns in user_settings" \
    || fail "legacy user_settings columns still present: $left"

n="$(db "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='hermes' AND table_name='crontab_entries'")"
[[ "$n" == "0" ]] && pass "crontab_entries dropped" || fail "crontab_entries still exists"

done_check
