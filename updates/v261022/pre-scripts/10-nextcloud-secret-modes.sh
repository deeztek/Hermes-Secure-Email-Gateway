#!/usr/bin/env bash
# FRESH-INSTALL: n/a  the installer writes these files 0644
#
# v261022 -- Nextcloud's Docker secrets must be readable by www-data
#
# hermes_nextcloud receives five Docker secrets as bind mounts of
# config/hermes/opt/hermes/creds/nextcloud_*. Nextcloud reads them as
# www-data on every request (redis.config.php, the database settings), so the
# files must be world-readable, as the installer writes them. The legacy
# migration script set every file in creds/ to 0600, which leaves Nextcloud
# unable to reach its database and Redis ("NOAUTH Authentication required",
# occ user:add failing). Runs before the containers are recreated.
#
# Only the nextcloud_* files are changed; nothing else in creds/ is read by a
# non-root container. Idempotent.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]]; do
        [[ -f "$HERMES_ROOT/docker-compose.yml" ]] && break
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "  Could not locate docker-compose.yml walking up from $SCRIPT_DIR; skipping." >&2
        exit 0
    fi
fi

fixed=0
for f in "${HERMES_ROOT}"/config/hermes/opt/hermes/creds/nextcloud_*; do
    [[ -f "$f" ]] || continue
    if [[ "$(stat -c '%a' "$f")" != "644" ]]; then
        chmod 644 "$f"
        echo "  $(basename "$f"): set to 0644 (was not readable by Nextcloud)."
        fixed=$((fixed + 1))
    fi
done
[[ $fixed -eq 0 ]] && echo "  Nextcloud secret files already readable."
exit 0
