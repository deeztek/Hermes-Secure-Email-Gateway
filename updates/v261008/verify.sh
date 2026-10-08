#!/usr/bin/env bash
# v261008: confirm this release's changes landed. Run from the install root:
#   sudo bash updates/v261008/verify.sh
# Read-only. Exit code is the number of failed checks.

cd "$(dirname "$0")/../.." || exit 1
failed=0
ok()  { echo "  PASS  $*"; }
bad() { echo "  FAIL  $*"; failed=$((failed + 1)); }

build="$(docker exec hermes_db_server mysql -u root -N -s hermes -e \
    "SELECT value FROM system_settings WHERE parameter='build_no'" 2>/dev/null \
  || docker exec hermes_db_server sh -c 'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD); export MYSQL_PWD; mysql -u root -N -s hermes -e "SELECT value FROM system_settings WHERE parameter='"'"'build_no'"'"'"' 2>/dev/null)"
[[ "$build" == "v261008" ]] && ok "build_no is v261008" || bad "build_no is '$build', expected v261008"

[[ ! -e config/hermes/var/www/html/hermes-api ]] && ok "hermes-api/ removed" || bad "hermes-api/ still present"

for f in dovecot_overquota_notification fail2ban_ban_unban check_hibp; do
    [[ -f config/hermes/var/www/html/schedule/$f.cfm ]] && ok "schedule/$f.cfm present" || bad "schedule/$f.cfm missing"
done

mounts="$(docker inspect hermes_dovecot --format '{{range .Mounts}}{{.Destination}} {{end}}' 2>/dev/null)"
[[ "$mounts" != *"/opt/hermes/creds/hermes_"* ]] && ok "hermes_dovecot has no creds mounts" \
    || bad "hermes_dovecot still mounts /opt/hermes/creds (container not recreated)"

docker inspect hermes_fail2ban --format '{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null \
    | grep -q '^HERMES_COMMANDBOX_IP=' && ok "hermes_fail2ban has HERMES_COMMANDBOX_IP" \
    || bad "hermes_fail2ban lacks HERMES_COMMANDBOX_IP (container not recreated)"

docker inspect hermes_fail2ban --format '{{range .Mounts}}{{.Destination}} {{end}}' 2>/dev/null \
    | grep -q '/custom-cont-init.d/10-detect-iptables-backend' && ok "iptables backend detection mounted" \
    || bad "iptables backend detection not mounted (container not recreated)"

echo
echo "Failed: $failed"
exit "$failed"
