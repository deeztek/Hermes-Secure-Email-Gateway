#!/usr/bin/env bash
# v261012 schema: msgs stores emoji (#353) and has the chart index (#355). Read-only.
source "$(dirname "$0")/../lib.sh"

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261012" ]] && fail "build_no is $build, expected v261012 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

for col in subject from_addr; do
    cs="$(db "SELECT character_set_name FROM information_schema.columns WHERE table_schema='hermes' AND table_name='msgs' AND column_name='$col'")"
    [[ "$cs" == "utf8mb4" ]] && pass "msgs.$col is utf8mb4" || fail "msgs.$col is '$cs', expected utf8mb4 (#353)"
done

cols="$(db "SELECT GROUP_CONCAT(column_name ORDER BY seq_in_index) FROM information_schema.statistics WHERE table_schema='hermes' AND table_name='msgs' AND index_name='idx_msgs_time_content'")"
[[ "$cols" == "time_num,content" ]] && pass "idx_msgs_time_content on (time_num, content)" \
    || fail "idx_msgs_time_content missing or wrong: '$cols' (#355)"

done_check
