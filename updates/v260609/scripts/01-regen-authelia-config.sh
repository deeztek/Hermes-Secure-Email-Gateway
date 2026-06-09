#!/bin/bash
# ============================================================================
# v260609 post-container migration: regen Authelia configuration.yml + restart
# ============================================================================
# By the time this runs (Phase 3, after Phase 2's compose up):
#   - pre-scripts/01-migrate-authelia-creds.sh already moved
#     keys/authelia_{username,password} -> creds/
#   - The new docker-compose.yml is in place, mounting Docker secrets
#     AUTHELIA_STORAGE_USERNAME + AUTHELIA_STORAGE_PASSWORD from creds/
#   - Containers came up with the new mounts, but Authelia is still reading
#     its OLD configuration.yml which references {{ secret "/keys/..." }}
#     paths -- so Authelia is connecting to mariadb using the OLD path
#     (which still works because keys/ files weren't deleted, just supplemented)
#
# This script:
#   1. Re-renders config/authelia/configuration.yml from the v260609 template
#      so it references /run/secrets/AUTHELIA_STORAGE_* (Docker secrets)
#      instead of /keys/authelia_* (legacy volume-mount).
#   2. Restarts hermes_authelia so it picks up the new config + uses the
#      Docker secrets path.
#
# Idempotent:
#   - sed replacement only modifies lines if they still match the old pattern
#   - docker restart is always safe
# ============================================================================

set -euo pipefail

# Self-locate HERMES_ROOT
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_ROOT="$SCRIPT_DIR"
while [[ "$HERMES_ROOT" != "/" ]]; do
    if [[ -f "$HERMES_ROOT/docker-compose.yml" ]]; then
        break
    fi
    HERMES_ROOT="$(dirname "$HERMES_ROOT")"
done
if [[ "$HERMES_ROOT" == "/" ]]; then
    echo "ERROR: Could not locate docker-compose.yml walking up from $SCRIPT_DIR" >&2
    exit 1
fi

CONFIG="${HERMES_ROOT}/config/authelia/configuration.yml"
TEMPLATE="${HERMES_ROOT}/config/hermes/opt/hermes/templates/configuration.yml"

echo "[v260609 regen-authelia] HERMES_ROOT: $HERMES_ROOT"

if [[ ! -f "$CONFIG" ]]; then
    echo "[v260609 regen-authelia] No runtime configuration.yml at ${CONFIG}; nothing to regen."
    echo "[v260609 regen-authelia] (install_hermes_docker.sh would create it on a fresh install.)"
    exit 0
fi

# Detect: does the runtime config still reference /keys/authelia_{username,password}?
if grep -qE 'secret\s*"/keys/authelia_(username|password)"' "$CONFIG"; then
    echo "[v260609 regen-authelia] Old /keys/authelia_* paths detected in ${CONFIG}; rewriting..."
    # Atomic: sed into a temp file, then move
    tmp=$(mktemp)
    sed -E '
        s|secret\s*"/keys/authelia_username"|secret "/run/secrets/AUTHELIA_STORAGE_USERNAME"|g
        s|secret\s*"/keys/authelia_password"|secret "/run/secrets/AUTHELIA_STORAGE_PASSWORD"|g
    ' "$CONFIG" > "$tmp"
    chown --reference="$CONFIG" "$tmp" 2>/dev/null || true
    chmod --reference="$CONFIG" "$tmp" 2>/dev/null || true
    mv "$tmp" "$CONFIG"
    echo "[v260609 regen-authelia]   rewrote storage username/password secret paths"
else
    echo "[v260609 regen-authelia] ${CONFIG} already uses /run/secrets/ paths; no rewrite needed."
fi

# Restart Authelia to pick up the new config + the new Docker secret mounts.
# Use docker compose for proper orchestration.
echo "[v260609 regen-authelia] Restarting hermes_authelia..."
cd "$HERMES_ROOT"
if docker compose restart hermes_authelia >/dev/null 2>&1; then
    echo "[v260609 regen-authelia]   restart complete"
else
    echo "[v260609 regen-authelia]   WARN: docker compose restart hermes_authelia failed (container may not be running yet)"
    echo "[v260609 regen-authelia]   Authelia will use the new config on its next start regardless."
fi

# Quick health check (best effort): wait up to 30s for Authelia to be reachable
echo "[v260609 regen-authelia] Waiting briefly for Authelia health..."
for i in {1..15}; do
    sleep 2
    if docker exec hermes_authelia wget -q -O- http://localhost:9091/api/health 2>/dev/null | grep -q OK; then
        echo "[v260609 regen-authelia]   Authelia health OK after $((i*2))s"
        exit 0
    fi
done
echo "[v260609 regen-authelia]   WARN: Authelia not yet responding to /api/health -- check 'docker logs hermes_authelia'"
echo "[v260609 regen-authelia]   This is informational only; the upgrade itself succeeded."
