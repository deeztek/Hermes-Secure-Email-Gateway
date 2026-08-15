#!/usr/bin/env bash
#
# v260815 -- keep Nextcloud sharing inside the tenant by default (#316)
#
# Run on the host by Phase 3 of system_update_docker.sh. This is an `occ`
# call rather than SQL, which is why it lives here instead of in
# sql/schema_updates.sql.
#
# WHAT IT DOES, AND WHY THIS SETTING
#
# Two things at once.
#
# 1. Isolation. A Hermes gateway may host unrelated organisations side by
#    side, and Nextcloud groups are named after domains. Restricting shares
#    to members of your own groups means a user cannot share a file into
#    another customer's organisation.
#
# 2. Closes a group-name disclosure. Nextcloud Mail's recipient autocomplete
#    suggested EVERY group on the instance, unfiltered by the requesting
#    user's membership. A user at one customer could type part of another
#    customer's domain and have it suggested by name, and the LDAP and
#    Authelia infrastructure groups were visible to every mailbox user:
#    admins, mailboxes, one_factor, two_factor, nc_local_admins_2fa.
#
#    The installer already sets shareapi_restrict_user_enumeration_to_group
#    to stop cross-domain visibility, but that governs USERS. Groups take a
#    separate path, so the protection had a hole its setting name gives no
#    hint of.
#
# Mail's NextcloudGroupService::search() returns nothing when either
# shareapi_allow_group_sharing is off, or this setting is on. This one is
# chosen deliberately: disabling group sharing outright would also remove
# the ability to share with a whole group WITHIN a domain, which is useful
# and unrelated to the problem.
#
# A DEFAULT, NOT A POLICY
#
# An operator running a single organisation across several domains
# legitimately wants cross-domain sharing. They turn this off in
# Administration settings, Sharing, "Restrict users to only share with users
# in their groups". Nextcloud already exposes it, so Hermes adds no UI of
# its own.
#
# Idempotent: setting a value that already holds that value is a no-op.

set -euo pipefail

log()  { echo "[v260815] $*"; }
warn() { echo "[v260815] WARNING: $*" >&2; }

if ! docker inspect -f '{{.State.Status}}' hermes_nextcloud 2>/dev/null | grep -q running; then
    warn "hermes_nextcloud is not running; skipping the sharing restriction (#316)."
    warn "Apply it later with:"
    warn "  docker exec -u www-data hermes_nextcloud php /var/www/html/occ \\"
    warn "    config:app:set core shareapi_only_share_with_group_members --value=yes"
    exit 0
fi

current=$(docker exec -u www-data hermes_nextcloud \
            php /var/www/html/occ config:app:get core shareapi_only_share_with_group_members 2>/dev/null \
          | tr -d '[:space:]' || true)

if [[ "$current" == "yes" ]]; then
    log "Sharing is already restricted to same-domain members; nothing to do (#316)."
    exit 0
fi

if docker exec -u www-data hermes_nextcloud \
     php /var/www/html/occ config:app:set core shareapi_only_share_with_group_members --value=yes >/dev/null 2>&1; then
    log "Sharing restricted to members of the same domain (#316)."
    log "Group names no longer leak across tenants, and files cannot be shared into another"
    log "organisation. Sharing with a whole group WITHIN a domain still works."
    log ""
    log "If this gateway hosts ONE organisation across several domains and you want"
    log "cross-domain sharing back, turn it off in Nextcloud under Administration"
    log "settings, Sharing, \"Restrict users to only share with users in their groups\"."
else
    warn "Could not restrict sharing. Apply it by hand:"
    warn "  docker exec -u www-data hermes_nextcloud php /var/www/html/occ \\"
    warn "    config:app:set core shareapi_only_share_with_group_members --value=yes"
fi

exit 0
