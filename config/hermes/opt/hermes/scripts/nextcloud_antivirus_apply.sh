#!/usr/bin/env bash
#
# Install Nextcloud's files_antivirus app and point it at Hermes's ClamAV (#384).
# Runs from the installer, from post_upgrade.cfm, and by hand after editing
# NEXTCLOUD_AV_INFECTED_ACTION or NEXTCLOUD_AV_BLOCK_UNREACHABLE in
# security.conf: nothing in Nextcloud reads that file, so an edit only takes
# effect when this runs. A missing or invalid switch falls back to its default.
#
# Works on the host and inside hermes_commandbox: security.conf sits at
# ../config/ relative to this script in both. Idempotent.

set -u

log() { echo "[nextcloud-antivirus] $*"; }

DOCKER="$(command -v docker || echo /usr/local/bin/docker)"
CONF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../config/security.conf"

setting() {
    grep -E "^$1=" "$CONF" 2>/dev/null | tail -1 | cut -d= -f2- | tr -d '[:space:]'
}

occ() {
    "$DOCKER" exec -u www-data hermes_nextcloud php /var/www/html/occ "$@"
}

if [[ "$("$DOCKER" inspect -f '{{.State.Running}}' hermes_nextcloud 2>/dev/null)" != "true" ]]; then
    log "hermes_nextcloud is not running; nothing to do."
    exit 0
fi

infected_action="$(setting NEXTCLOUD_AV_INFECTED_ACTION)"
case "$infected_action" in
    only_log|delete) ;;
    *) infected_action=only_log ;;
esac

case "$(setting NEXTCLOUD_AV_BLOCK_UNREACHABLE)" in
    no) block_unreachable=false ;;
    *)  block_unreachable=true ;;
esac

if ! occ app:list --output=json | grep -q '"files_antivirus"'; then
    occ app:install files_antivirus >/dev/null || { log "ERROR: could not install files_antivirus."; exit 1; }
fi
occ app:enable files_antivirus >/dev/null || { log "ERROR: could not enable files_antivirus."; exit 1; }

# 26214400 matches clamd StreamMaxLength 25M; it must not exceed it.
occ config:app:set files_antivirus av_mode --value=daemon >/dev/null \
    && occ config:app:set files_antivirus av_host --value=hermes_mail_filter >/dev/null \
    && occ config:app:set files_antivirus av_port --value=3310 --type=integer >/dev/null \
    && occ config:app:set files_antivirus av_stream_max_length --value=26214400 --type=integer >/dev/null \
    && occ config:app:set files_antivirus av_infected_action --value="$infected_action" >/dev/null \
    && occ config:app:set files_antivirus av_block_unreachable --value="$block_unreachable" --type=boolean >/dev/null \
    || { log "ERROR: could not apply the files_antivirus settings."; exit 1; }

log "Applied: infected action=$infected_action, block when unreachable=$block_unreachable"
exit 0
