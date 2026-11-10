#!/usr/bin/env bash
# FRESH-INSTALL: n/a  .env.template ships AUTHELIAVERSION=4.39.28
#
# v261107 -- Authelia 4.39.16 -> 4.39.28.
#
# .env is per-install and untracked, so a new AUTHELIAVERSION in
# .env.template does not reach existing installs on its own. Raise
# AUTHELIAVERSION in .env to 4.39.28; the update orchestrator then pulls that
# image and recreates hermes_authelia.
#
# Patch releases within 4.39 only: anything not on 4.39.x, or already
# 4.39.28 or newer, is left alone. Idempotent.

set -euo pipefail

TARGET="4.39.28"

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
current="$(sed -n 's/^AUTHELIAVERSION=//p' "$ENV_FILE" | tr -d '\r' | head -1)"
if [[ -z "$current" ]]; then
    echo "  No AUTHELIAVERSION in .env; nothing to change."
    exit 0
fi
if [[ "$current" != 4.39.* ]]; then
    echo "  AUTHELIAVERSION=$current: not on Authelia 4.39; left alone."
    exit 0
fi
if [[ "$(printf '%s\n%s\n' "$current" "$TARGET" | sort -V | tail -1)" == "$current" ]]; then
    echo "  AUTHELIAVERSION=$current is already $TARGET or newer."
    exit 0
fi
[[ -f "${ENV_FILE}.pre-v261107" ]] || cp -p "$ENV_FILE" "${ENV_FILE}.pre-v261107"
sed -i "s/^AUTHELIAVERSION=.*/AUTHELIAVERSION=${TARGET}/" "$ENV_FILE"
echo "  AUTHELIAVERSION $current -> $TARGET (backup: .env.pre-v261107)."
