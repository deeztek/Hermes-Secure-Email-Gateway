#!/usr/bin/env bash
# FRESH-INSTALL: n/a  .env.template ships NCVERSION=33.0.10
#
# v261022 -- Nextcloud images with patched PHP (critical PHP RCE, CISA
# 2026-10-21): 33.0.10 ships PHP 8.4.27, 34.0.5 ships PHP 8.5.12.
#
# .env is per-install and untracked, so a new NCVERSION in .env.template does
# not reach existing installs on its own. Raise NCVERSION in .env to the
# patched point release of the major the install already runs. The update
# orchestrator then pulls that image, detects the version change and runs
# occ upgrade (#264). Point releases only: no major is skipped.
#
# Left alone: no NCVERSION line, a major not listed below, or already at the
# patched release or newer. Idempotent.

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

ENV_FILE="${HERMES_ROOT}/.env"
[[ -f "$ENV_FILE" ]] || { echo "  No .env; nothing to change."; exit 0; }
current="$(sed -n 's/^NCVERSION=//p' "$ENV_FILE" | tr -d '\r' | head -1)"
if [[ -z "$current" ]]; then
    echo "  No NCVERSION in .env; nothing to change."
    exit 0
fi
case "${current%%.*}" in
    33) TARGET="33.0.10" ;;
    34) TARGET="34.0.5" ;;
    *)  echo "  NCVERSION=$current: no patched release defined for this major; left alone."
        exit 0 ;;
esac
if [[ "$(printf '%s\n%s\n' "$current" "$TARGET" | sort -V | tail -1)" == "$current" ]]; then
    echo "  NCVERSION=$current is already $TARGET or newer."
    exit 0
fi
cp -p "$ENV_FILE" "${ENV_FILE}.pre-v261022"
sed -i "s/^NCVERSION=.*/NCVERSION=${TARGET}/" "$ENV_FILE"
echo "  NCVERSION $current -> $TARGET (backup: .env.pre-v261022)."
