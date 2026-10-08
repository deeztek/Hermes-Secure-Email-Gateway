#!/usr/bin/env bash
# v261008's own changes are in place after install or upgrade. Read-only.
source "$(dirname "$0")/../lib.sh"

build="$(db "SELECT value FROM system_settings WHERE parameter='build_no'")"
case "$build" in
    v2[6-9][0-9][0-9][0-9][0-9]) [[ "$build" < "v261008" ]] && fail "build_no is $build, expected v261008 or later" || pass "build_no is $build" ;;
    *) fail "build_no is '$build'" ;;
esac

for f in dovecot_overquota_notification fail2ban_ban_unban check_hibp; do
    [[ -f config/hermes/var/www/html/schedule/$f.cfm ]] && pass "schedule/$f.cfm present" || fail "schedule/$f.cfm missing"
done

mounts="$(docker inspect hermes_dovecot --format '{{range .Mounts}}{{.Destination}} {{end}}' 2>/dev/null)"
[[ "$mounts" != *"/opt/hermes/creds/hermes_"* ]] && pass "hermes_dovecot has no creds mounts" \
    || fail "hermes_dovecot still mounts /opt/hermes/creds (container not recreated)"

docker inspect hermes_fail2ban --format '{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null \
    | grep -q '^HERMES_COMMANDBOX_IP=' && pass "hermes_fail2ban has HERMES_COMMANDBOX_IP" \
    || fail "hermes_fail2ban lacks HERMES_COMMANDBOX_IP (container not recreated)"

docker inspect hermes_fail2ban --format '{{range .Mounts}}{{.Destination}} {{end}}' 2>/dev/null \
    | grep -q '/custom-cont-init.d/10-detect-iptables-backend' && pass "iptables backend detection mounted" \
    || fail "iptables backend detection not mounted (container not recreated)"

done_check
