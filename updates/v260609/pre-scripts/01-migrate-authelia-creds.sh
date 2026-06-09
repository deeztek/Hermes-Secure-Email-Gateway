#!/bin/bash
# ============================================================================
# v260609 pre-container migration: move Authelia DB credentials keys/ -> creds/
# ============================================================================
# Architectural cleanup: authelia_username + authelia_password are DB service
# account credentials -- they belong in creds/ alongside hermes_username/
# password, opendmarc_*, syslog_*, ciphermail_*, nextcloud_mysql_*. They were
# historically in keys/ which is for Authelia's auth-layer crypto (session
# signing, 2FA encryption, OIDC JWKs).
#
# This script runs in Phase 2's pre-scripts/ hook (BEFORE docker compose up)
# because v260609's docker-compose.yml introduces new Docker secrets
# AUTHELIA_STORAGE_USERNAME + AUTHELIA_STORAGE_PASSWORD sourced from
# creds/authelia_username + creds/authelia_password. If those files don't
# exist when compose up runs, it fails on "bind source path does not exist".
#
# Idempotent:
#   - Only copies if source (keys/) exists AND destination (creds/) is missing
#   - Subsequent runs are no-ops (files already exist in creds/)
# ============================================================================

set -euo pipefail

# Self-locate HERMES_ROOT (walk-up pattern, matches install/backup/restore)
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

KEYS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/keys"
CREDS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/creds"

echo "[v260609 pre-migrate] HERMES_ROOT: $HERMES_ROOT"
echo "[v260609 pre-migrate] Moving authelia DB credentials keys/ -> creds/"

[[ -d "$CREDS_DIR" ]] || { echo "ERROR: creds/ dir not found at ${CREDS_DIR}" >&2; exit 1; }

migrated_count=0
for f in authelia_username authelia_password; do
    if [[ -f "${CREDS_DIR}/${f}" ]]; then
        echo "[v260609 pre-migrate]   ${f}: already in creds/, skipping"
    elif [[ -f "${KEYS_DIR}/${f}" ]]; then
        echo "[v260609 pre-migrate]   ${f}: copying keys/ -> creds/"
        cp "${KEYS_DIR}/${f}" "${CREDS_DIR}/${f}"
        chmod 600 "${CREDS_DIR}/${f}"
        chown root:root "${CREDS_DIR}/${f}" 2>/dev/null || true
        migrated_count=$((migrated_count + 1))
    else
        # Neither location has it -- this is a fresh install path (install
        # script's generate_secrets will create them in creds/). Safe to skip.
        echo "[v260609 pre-migrate]   ${f}: not in either location -- fresh install path"
    fi
done

if (( migrated_count > 0 )); then
    echo "[v260609 pre-migrate] Migrated ${migrated_count} file(s)."
    echo "[v260609 pre-migrate] The keys/ originals are LEFT IN PLACE for safety."
    echo "[v260609 pre-migrate] After validating Authelia auth on the upgraded install,"
    echo "[v260609 pre-migrate] they can be removed:"
    echo "[v260609 pre-migrate]   rm ${KEYS_DIR}/authelia_username ${KEYS_DIR}/authelia_password"
fi
