#!/usr/bin/env bash
# FRESH-INSTALL: covered-by scripts/install_hermes_docker.sh  seed_ciphermail_admin() creates the account during phase 2
#
# v261012 -- create the CipherMail admin console account where none exists (#306)
#
# Fresh Docker installs before v261012 imported only the djigzo schema, so
# CipherMail had NO admin account and its console at /ciphermail could not be
# logged into (the documented admin/admin never existed). This creates
# 'admin' with a random password, saved to
# config/hermes/opt/hermes/creds/ciphermail_admin_password.
#
# Idempotent and conservative: does nothing if ANY admin account exists, so
# installs migrated from legacy, or fixed by hand, keep their own accounts.

set -uo pipefail

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

CREDS="${HERMES_ROOT}/config/hermes/opt/hermes/creds/ciphermail_admin_password"

# Root DB access differs per host: socket first, then the mounted secret.
dbq() {
    if docker exec hermes_db_server mariadb -u root -N -s djigzo -e "SELECT 1" >/dev/null 2>&1; then
        docker exec hermes_db_server mariadb -u root -N -s djigzo -e "$1"
    else
        docker exec hermes_db_server sh -c 'MYSQL_PWD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD) exec mariadb -u root -N -s djigzo -e "$1"' _ "$1"
    fi
}

if ! docker ps --format '{{.Names}}' 2>/dev/null | grep -qx hermes_db_server; then
    echo "  hermes_db_server is not running; skipping CipherMail admin check."
    exit 0
fi

admins="$(dbq "SELECT COUNT(*) FROM cm_admin;" 2>/dev/null)"
if [[ ! "$admins" =~ ^[0-9]+$ ]]; then
    echo "  Could not read CipherMail's admin table; skipping."
    exit 0
fi
if (( admins > 0 )); then
    echo "  CipherMail already has ${admins} admin account(s); nothing to do."
    exit 0
fi

roles="$(dbq "SELECT COUNT(*) FROM cm_authority WHERE cm_role IN ('ROLE_LOGIN','ROLE_ADMIN');" 2>/dev/null)"
if [[ "$roles" != "2" ]]; then
    echo "  WARNING: CipherMail roles not found; admin account not created. See issue #306." >&2
    exit 0
fi

if [[ ! -s "$CREDS" ]]; then
    umask 077
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 16 > "$CREDS"
    chmod 600 "$CREDS"
fi
pass="$(tr -d '[:space:]' < "$CREDS")"

if dbq "INSERT INTO cm_admin (cm_built_in, cm_enabled, cm_password, cm_password_encoding, cm_salt, cm_username) VALUES (false, true, '${pass}', 0, '', 'admin');
        INSERT INTO cm_admin_cm_authorities (cm_admin, cm_authorities) VALUES
          ((SELECT cm_id FROM cm_admin WHERE cm_username='admin'), (SELECT cm_id FROM cm_authority WHERE cm_role='ROLE_LOGIN')),
          ((SELECT cm_id FROM cm_admin WHERE cm_username='admin'), (SELECT cm_id FROM cm_authority WHERE cm_role='ROLE_ADMIN'));"; then
    echo "  Created CipherMail admin account 'admin'. Password: ${CREDS}"
    echo "  Sign in at https://<console>/ciphermail and change it."
else
    echo "  WARNING: could not create the CipherMail admin account (see #306)." >&2
fi
