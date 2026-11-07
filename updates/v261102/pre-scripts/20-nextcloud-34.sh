#!/usr/bin/env bash
# FRESH-INSTALL: n/a  .env.template ships NCVERSION=34.0.5
#
# v261102 -- Nextcloud 33 -> 34.0.5.
#
# .env is per-install and untracked, so a new NCVERSION in .env.template does
# not reach existing installs on its own. Raise NCVERSION in .env to 34.0.5.
# The update orchestrator then pulls that image, detects the version change
# and runs occ upgrade (#264), after creating the temp directory Nextcloud 34
# needs (#338).
#
# Nextcloud upgrades one major at a time, so only 33.x and older 34.x are
# raised. Anything else is left alone: no NCVERSION line, an older major
# (it must reach 33 first), or already 34.0.5 or newer. Idempotent.

set -euo pipefail

TARGET="34.0.5"

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

ENV_FILE="${HERMES_ROOT}/.env"
[[ -f "$ENV_FILE" ]] || { echo "  No .env; nothing to change."; exit 0; }
current="$(sed -n 's/^NCVERSION=//p' "$ENV_FILE" | tr -d '\r' | head -1)"
if [[ -z "$current" ]]; then
    echo "  No NCVERSION in .env; nothing to change."
    exit 0
fi
case "${current%%.*}" in
    33|34) ;;
    *)  echo "  NCVERSION=$current: not on Nextcloud 33 or 34; left alone."
        exit 0 ;;
esac
if [[ "$(printf '%s\n%s\n' "$current" "$TARGET" | sort -V | tail -1)" == "$current" ]]; then
    echo "  NCVERSION=$current is already $TARGET or newer."
    exit 0
fi
cp -p "$ENV_FILE" "${ENV_FILE}.pre-v261102"
sed -i "s/^NCVERSION=.*/NCVERSION=${TARGET}/" "$ENV_FILE"
echo "  NCVERSION $current -> $TARGET (backup: .env.pre-v261102)."
