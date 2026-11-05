#!/usr/bin/env bash
#
# v261102 -- render the Recipient Delivery VERIFY map for existing installs (#393)
#
# The mysql-*.cf lookup files are rendered from their .HERMES templates by
# the INSTALLER, once. An upgrade never re-runs that step, so a release that
# introduces a new lookup table has to place the file itself. Same approach
# as v260815's internal-only map.
#
# ORDER MATTERS: main.cf must never reference a lookup file that does not
# exist. This runs in Phase 3; post_upgrade.cfm regenerates main.cf in
# Phase 5, and only then does Postfix consult the map. No domain is VERIFY
# after the upgrade, so the map matches nothing until an admin switches one.
#
# Idempotent: rewrites the same content from the same credentials each run.
#
# FRESH-INSTALL: covered-by scripts/install_hermes_docker.sh  generate_postfix_configs (renders every mysql-*.HERMES)

set -euo pipefail

log()  { echo "[v261102] $*"; }
warn() { echo "[v261102] WARNING: $*" >&2; }

# Locate the repo root by walking up for docker-compose.yml, rather than a
# dirname chain that breaks if this file ever moves.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$here"
while [[ "$root" != "/" && ! -f "$root/docker-compose.yml" ]]; do
    root="$(dirname "$root")"
done
if [[ ! -f "$root/docker-compose.yml" ]]; then
    warn "Could not locate the Hermes root; skipping the verify map."
    exit 0
fi

template="$root/config/hermes/opt/hermes/conf_files/mysql-verify-recipients.HERMES"
target="$root/config/postfix-dkim/etc/postfix/mysql-verify-recipients.cf"
donor="$root/config/postfix-dkim/etc/postfix/mysql-virtual.cf"

if [[ ! -f "$template" ]]; then
    warn "Template missing: $template"
    exit 0
fi

# Take the credentials from an existing rendered map rather than from the
# creds directory, so this matches whatever the running Postfix already
# uses, including after a credential rotation.
if [[ ! -f "$donor" ]]; then
    warn "Cannot read existing DB credentials from $donor; skipping."
    warn "Recipient Delivery VERIFY will not take effect until this file exists."
    exit 0
fi

db_user=$(grep -E '^user[[:space:]]*=' "$donor" | head -1 | cut -d= -f2- | xargs)
db_pass=$(grep -E '^password[[:space:]]*=' "$donor" | head -1 | cut -d= -f2- | xargs)

if [[ -z "$db_user" || -z "$db_pass" ]]; then
    warn "Could not parse DB credentials from $donor; skipping."
    exit 0
fi

sed -e "s|HERMES-USERNAME|${db_user}|g" \
    -e "s|HERMES-PASSWORD|${db_pass}|g" \
    "$template" > "$target"
chmod 644 "$target"

log "Rendered mysql-verify-recipients.cf"

exit 0
