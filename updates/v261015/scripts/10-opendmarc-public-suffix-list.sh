#!/usr/bin/env bash
# FRESH-INSTALL: n/a  a fresh install ships opendmarc.conf with the corrected path and starts hermes_dmarc with it
#
# v261015 -- let OpenDMARC find the organizational domain (#360)
#
# PublicSuffixList pointed at /usr/share/publicsuffix, a directory, so
# OpenDMARC could not compute the organizational domain: a subdomain without
# its own _dmarc record evaluated as dmarc=none instead of inheriting its
# parent's policy. The upgrade's checkout already replaces the tracked
# opendmarc.conf; this corrects the live file if it still has the old path
# and restarts hermes_dmarc, which reads its config only at startup.
#
# Idempotent: a corrected file is left alone; the restart is harmless.

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

CONF="${HERMES_ROOT}/config/opendmarc/etc/opendmarc/opendmarc.conf"

if [[ ! -f "$CONF" ]]; then
    echo "  No opendmarc.conf on this install; nothing to correct."
    exit 0
fi

if grep -qE '^PublicSuffixList /usr/share/publicsuffix[[:space:]]*$' "$CONF"; then
    cp -p "$CONF" "${CONF}.pre-v261015"
    sed -i -E 's#^PublicSuffixList /usr/share/publicsuffix[[:space:]]*$#PublicSuffixList /usr/share/publicsuffix/public_suffix_list.dat#' "$CONF"
    echo "  Corrected PublicSuffixList in opendmarc.conf (backup: ${CONF}.pre-v261015)."
else
    echo "  opendmarc.conf PublicSuffixList already points at a file."
fi

if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx hermes_dmarc; then
    if docker restart hermes_dmarc >/dev/null 2>&1; then
        echo "  Restarted hermes_dmarc."
    else
        echo "  WARNING: could not restart hermes_dmarc; run 'docker restart hermes_dmarc'." >&2
    fi
else
    echo "  hermes_dmarc is not running; it reads the corrected file when it starts."
fi
