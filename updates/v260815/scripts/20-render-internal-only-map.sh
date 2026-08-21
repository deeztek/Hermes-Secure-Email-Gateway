#!/usr/bin/env bash
#
# v260815 -- render the internal-only recipient map for existing installs
#
# The mysql-*.cf lookup files are rendered from their .HERMES templates by
# the INSTALLER, once, at install time. An upgrade never re-runs that step,
# so a release that introduces a new lookup table has to place the file
# itself. That is all this does.
#
# It deliberately does NOT touch main.cf. Rewriting a live main.cf from an
# unattended upgrade script is a good way to stop a gateway accepting mail,
# and there is no need: the restriction reaches main.cf on its own later in
# this upgrade, because the schema step seeds it into the parameters table
# and the post-upgrade phase runs generate_postfix_configuration.cfm, which
# rebuilds smtpd_recipient_restrictions from those rows. The flag also
# defaults to 0 on every existing address, so until an admin turns it on
# there is nothing for the map to reject either way.
#
# ORDER MATTERS, and this is why the file is written now rather than later:
# main.cf must never reference a lookup file that does not exist. Placing
# the file first means that whenever main.cf does pick up the new
# restriction, its target is already there.
#
# Idempotent: rewrites the same content from the same credentials each run.

set -euo pipefail

log()  { echo "[v260815] $*"; }
warn() { echo "[v260815] WARNING: $*" >&2; }

# Locate the repo root by walking up for docker-compose.yml, rather than a
# dirname chain that breaks if this file ever moves.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$here"
while [[ "$root" != "/" && ! -f "$root/docker-compose.yml" ]]; do
    root="$(dirname "$root")"
done
if [[ ! -f "$root/docker-compose.yml" ]]; then
    warn "Could not locate the Hermes root; skipping the internal-only map."
    exit 0
fi

template="$root/config/hermes/opt/hermes/conf_files/mysql-internal-only-recipients.HERMES"
target="$root/config/postfix-dkim/etc/postfix/mysql-internal-only-recipients.cf"
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
    warn "The internal-only flag will record intent but not be enforced."
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

log "Rendered mysql-internal-only-recipients.cf"
log "Reachable By is armed later in this same upgrade: the schema step seeds the"
log "restriction into the parameters table, and the post-upgrade phase regenerates"
log "main.cf from it. Nothing further is required from you."

exit 0
