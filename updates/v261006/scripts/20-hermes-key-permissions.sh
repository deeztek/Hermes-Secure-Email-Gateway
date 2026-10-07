#!/usr/bin/env bash
# FRESH-INSTALL: covered-by scripts/install_hermes_docker.sh  generate_secrets() now creates hermes.key with mode 600
#
# v261006 -- set hermes.key to 600. The key itself is not changed. Idempotent.

set -euo pipefail

# ---- Self-locate HERMES_ROOT (walk up to find docker-compose.yml) ----
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

KEY="${HERMES_ROOT}/config/hermes/opt/hermes/keys/hermes.key"

if [[ ! -f "$KEY" ]]; then
    echo "  No hermes.key on this install; nothing to do."
    exit 0
fi

mode="$(stat -c '%a' "$KEY")"
if [[ "$mode" == "600" ]]; then
    echo "  hermes.key is already 600; nothing to do."
    exit 0
fi

chmod 600 "$KEY"
echo "  hermes.key permissions changed from ${mode} to 600."
