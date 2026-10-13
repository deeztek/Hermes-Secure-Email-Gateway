#!/usr/bin/env bash
# FRESH-INSTALL: n/a  a fresh install's amavis_senderbypass map starts empty and the pages now write the corrected transport
#
# v261012 -- repair Global Sender Rules allow entries in the LIVE Postfix map (#358)
#
# Allow entries become lines in /etc/postfix/amavis_senderbypass of the form
#   <sender>  FILTER amavis:[127.0.0.1]:10030
# 127.0.0.1 is the legacy single-server address. Inside hermes_postfix_dkim
# nothing listens on 10030, so mail from an allowed sender was deferred
# instead of skipping the filters. The schema update corrects the database
# rows; this corrects the compiled map that Postfix is using now, so the fix
# does not wait for an admin to save the Global Sender Rules page.
#
# Idempotent: a map without the old address is left alone.

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

MAP="${HERMES_ROOT}/config/postfix-dkim/etc/postfix/amavis_senderbypass"

if [[ ! -f "$MAP" ]]; then
    echo "  No amavis_senderbypass map on this install; nothing to repair."
    exit 0
fi

if ! grep -q '\[127\.0\.0\.1\]:10030' "$MAP"; then
    echo "  amavis_senderbypass already routes allow entries to the mail filter; nothing to do."
    exit 0
fi

n=$(grep -c '\[127\.0\.0\.1\]:10030' "$MAP")
cp -p "$MAP" "${MAP}.pre-v261012"
sed -i 's/\[127\.0\.0\.1\]:10030/[hermes_mail_filter]:10030/g' "$MAP"
echo "  Corrected ${n} allow entr(ies) in amavis_senderbypass (backup: ${MAP}.pre-v261012)."

if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx hermes_postfix_dkim; then
    if docker exec hermes_postfix_dkim /usr/sbin/postmap /etc/postfix/amavis_senderbypass \
       && docker exec hermes_postfix_dkim /usr/sbin/postfix reload >/dev/null 2>&1; then
        echo "  Rebuilt the map and reloaded Postfix."
    else
        echo "  WARNING: postmap or reload failed; run 'docker exec hermes_postfix_dkim postmap /etc/postfix/amavis_senderbypass' and reload Postfix." >&2
    fi
else
    echo "  hermes_postfix_dkim is not running; run postmap on /etc/postfix/amavis_senderbypass once it starts."
fi
