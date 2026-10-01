#!/usr/bin/env bash
# FRESH-INSTALL: covered-by scripts/install_hermes_docker.sh  generate_postfix_configs() renders every mysql-*.cf from its template, so a fresh install already has the new query
#
# v260929 -- re-render mysql-transport.cf so the per-recipient backend
#            override can actually route (#157)
#
# WHY THIS EXISTS
#
# recipients.backend_server / backend_port / backend_tls have been storable
# since the Docker rewrite and have never affected delivery, because nothing
# read them. #157 fixes that by moving transport_maps from a hash file to a
# MySQL lookup whose query falls back from the recipient override to the
# domain row.
#
# Both halves of that live in templates: conf_files/mysql-transport.HERMES and
# conf_files/main.cf.HERMES. Templates are rendered by generate_postfix_configs()
# in the install script, which the update orchestrator never calls, so an
# existing install would keep its old lookup indefinitely.
#
# main.cf has an in-app path: generate_postfix_configuration.cfm rewrites it
# from the template and several admin page saves trigger that. mysql-transport.cf
# has none. This closes that gap.
#
# ORDER DOES NOT MATTER. If main.cf starts using the MySQL map before this runs,
# the old query still resolves domains correctly and behaviour is unchanged from
# today; overrides simply stay inert until this executes. There is no window in
# which mail stops.
#
# CREDENTIALS are taken from the file being replaced rather than regenerated.
# The database user and password already in it are correct by definition, and
# reading them here avoids this script needing access to the secrets directory.
#
# Idempotent: a file already carrying the new query is left alone.

set -euo pipefail

# ---- Self-locate HERMES_ROOT (walk up to find docker-compose.yml) ----
# Same sentinel as system_backup.sh: docker-compose.yml alone, not .git.
# Upload-deployed installs have no .git/ at all.
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

TEMPLATE="${HERMES_ROOT}/config/hermes/opt/hermes/conf_files/mysql-transport.HERMES"
LIVE="${HERMES_ROOT}/config/postfix-dkim/etc/postfix/mysql-transport.cf"

if [[ ! -f "$TEMPLATE" ]]; then
    echo "  Template not found at ${TEMPLATE}; skipping."
    exit 0
fi

if [[ ! -f "$LIVE" ]]; then
    echo "  No rendered mysql-transport.cf on this install; nothing to re-render."
    exit 0
fi

if grep -q '^query[[:space:]]*=' "$LIVE"; then
    echo "  mysql-transport.cf already carries the recipient override query; nothing to do."
    exit 0
fi

# Check the SOURCE, not just the destination. Without this the script will
# happily render an old template over an old live file and report success,
# because both ends look the same and neither is the new query. That is a
# silent no-op dressed up as a fix, and it costs more to diagnose than it
# saves. An install whose conf_files/ predates this release hits exactly that.
if ! grep -q '^query[[:space:]]*=' "$TEMPLATE"; then
    echo "  WARNING: ${TEMPLATE} does not carry the override query." >&2
    echo "  This install has an older copy of the template, so there is nothing to render." >&2
    echo "  Left unchanged. Per-recipient backend overrides will not route until it is updated." >&2
    exit 0
fi

# Pull the credentials out of the file we are replacing.
DB_USER="$(sed -n 's/^user[[:space:]]*=[[:space:]]*//p' "$LIVE" | head -1)"
DB_PASS="$(sed -n 's/^password[[:space:]]*=[[:space:]]*//p' "$LIVE" | head -1)"

if [[ -z "$DB_USER" || -z "$DB_PASS" ]]; then
    echo "  WARNING: could not read the database user or password from ${LIVE}." >&2
    echo "  Left unchanged. Per-recipient backend overrides will not route until this is resolved." >&2
    exit 0
fi

cp -a "$LIVE" "${LIVE}.BACKUP-$(date +%Y%m%d%H%M%S)"

# Substitute with awk rather than sed: the password is arbitrary text and may
# contain characters sed would treat as delimiters or backreferences.
awk -v u="$DB_USER" -v p="$DB_PASS" '
    { gsub(/HERMES-USERNAME/, u); gsub(/HERMES-PASSWORD/, p); print }
' "$TEMPLATE" > "${LIVE}.new"

chmod --reference="$LIVE" "${LIVE}.new" 2>/dev/null || chmod 640 "${LIVE}.new"
chown --reference="$LIVE" "${LIVE}.new" 2>/dev/null || true
mv "${LIVE}.new" "$LIVE"

echo "  Re-rendered mysql-transport.cf with the per-recipient override query."

# Postfix re-reads lookup tables on reload. If the container is not running
# the new file is still in place and takes effect whenever it next starts.
if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx hermes_postfix_dkim; then
    if docker exec hermes_postfix_dkim /usr/sbin/postfix reload >/dev/null 2>&1; then
        echo "  Reloaded Postfix."
    else
        echo "  WARNING: postfix reload failed; the new lookup applies at the next restart." >&2
    fi
else
    echo "  hermes_postfix_dkim is not running; the new lookup applies when it starts."
fi
