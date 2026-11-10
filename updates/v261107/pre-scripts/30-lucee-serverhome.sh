#!/usr/bin/env bash
# FRESH-INSTALL: n/a  a fresh install starts with an empty server home
#
# v261107 -- Lucee 5.3 -> 6.2 (CommandBox engine change).
#
# hermes_commandbox runs CommandBox with a fixed serverHomeDirectory
# (/serverhome, on the Data tier). With a custom server home CommandBox does
# NOT install a new engine version: it keeps starting whatever is already in
# that directory and ignores the cfengine in server.json. The server home has
# to be emptied before the new engine can be deployed.
#
# So when the engine in server.json differs from the one the server home was
# last deployed for, move the server home aside and create an empty one. The
# recreated container then deploys the new engine on its first start. The old
# home is kept as serverhome.pre-<engine> for comparison; nothing in it is
# needed: datasources live in each Application.cfc, and the Lucee admin
# password comes from the bind-mounted password.txt.
#
# The engine last deployed is recorded OUTSIDE the server home, in
# commandbox/.hermes_serverhome_engine, so the new home stays empty. A home
# with no record is treated as the old engine. Idempotent: once the record
# matches server.json, nothing happens.

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
SERVER_JSON="${HERMES_ROOT}/config/hermes/var/www/html/server.json"
[[ -f "$ENV_FILE" ]] || { echo "  No .env; nothing to change."; exit 0; }
[[ -f "$SERVER_JSON" ]] || { echo "  No server.json; nothing to change."; exit 0; }

data_mount="$(sed -n 's/^DATA_MOUNT=//p' "$ENV_FILE" | tr -d '\r"' | head -1)"
engine="$(grep -o '"cfengine" *: *"[^"]*"' "$SERVER_JSON" | sed 's/.*: *"//; s/"$//' | head -1)"
if [[ -z "$data_mount" || "$data_mount" != /* ]]; then
    echo "  DATA_MOUNT not set to an absolute path in .env; left alone." >&2
    exit 0
fi
if [[ -z "$engine" ]]; then
    echo "  No cfengine in server.json; left alone." >&2
    exit 0
fi

base="${data_mount}/commandbox"
home="${base}/serverhome"
record="${base}/.hermes_serverhome_engine"
previous="$(cat "$record" 2>/dev/null || true)"

if [[ "$previous" == "$engine" ]]; then
    echo "  Server home already deployed for ${engine}."
    exit 0
fi

if [[ -d "$home" ]] && [[ -n "$(ls -A "$home" 2>/dev/null)" ]]; then
    aside="${home}.pre-${engine//[^A-Za-z0-9.+_-]/_}"
    if [[ -e "$aside" ]]; then
        aside="${aside}.$(date +%Y%m%d%H%M%S)"
    fi
    owner="$(stat -c '%u:%g' "$home")"
    mode="$(stat -c '%a' "$home")"
    mv "$home" "$aside"
    mkdir -p "$home"
    chown "$owner" "$home"
    chmod "$mode" "$home"
    echo "  Server home moved to ${aside} (was ${previous:-unrecorded}); ${engine} deploys on the next start."
else
    mkdir -p "$home"
    echo "  Server home empty; ${engine} deploys on the next start."
fi
printf '%s\n' "$engine" > "$record"
