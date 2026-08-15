#!/usr/bin/env bash
#
# v260815 -- close the cross-tenant group name disclosure (#316)
#
# Run on the host by Phase 3 of system_update_docker.sh. This is an `occ`
# call rather than SQL, which is why it lives here instead of in
# sql/schema_updates.sql.
#
# WHAT IT FIXES
#
# Nextcloud Mail's recipient autocomplete suggests every group on the
# instance, unfiltered by the requesting user's membership. Hermes names its
# Nextcloud groups after domains, so a user at one customer could type part
# of another customer's domain and have it suggested by name. The LDAP and
# Authelia infrastructure groups were visible to every mailbox user too:
# admins, mailboxes, one_factor, two_factor, nc_local_admins_2fa.
#
# The installer already sets shareapi_restrict_user_enumeration_to_group=yes
# to stop cross-domain visibility, but that governs USERS. Groups take a
# separate path, so the protection had a hole the setting name gives no hint
# of.
#
# Mail's NextcloudGroupService::search() bails out and returns nothing when
# either of two core settings is off its default. We change
# shareapi_allow_group_sharing. The alternative,
# shareapi_only_share_with_group_members=yes, also closes it but restricts
# sharing to users within your own groups, which would break the cross-domain
# full-email-match sharing Hermes deliberately enables.
#
# COST: a file can no longer be shared with an entire group. User-to-user
# sharing, including cross-domain, is unaffected. Verified on a test
# instance: the cross-tenant domain name and the infrastructure group names
# both stop appearing, shared address book contacts still autocomplete, and
# sharing a file with a named colleague still works.
#
# Idempotent: setting a config value that already holds that value is a
# no-op, so re-running costs nothing.

set -euo pipefail

log()  { echo "[v260815] $*"; }
warn() { echo "[v260815] WARNING: $*" >&2; }

if ! docker inspect -f '{{.State.Status}}' hermes_nextcloud 2>/dev/null | grep -q running; then
    warn "hermes_nextcloud is not running; skipping the group-sharing fix (#316)."
    warn "Apply it later with:"
    warn "  docker exec -u www-data hermes_nextcloud php /var/www/html/occ \\"
    warn "    config:app:set core shareapi_allow_group_sharing --value=no"
    exit 0
fi

current=$(docker exec -u www-data hermes_nextcloud \
            php /var/www/html/occ config:app:get core shareapi_allow_group_sharing 2>/dev/null \
          | tr -d '[:space:]' || true)

if [[ "$current" == "no" ]]; then
    log "Group sharing already disabled; nothing to do (#316)."
    exit 0
fi

if docker exec -u www-data hermes_nextcloud \
     php /var/www/html/occ config:app:set core shareapi_allow_group_sharing --value=no >/dev/null 2>&1; then
    log "Group sharing disabled. Group names no longer leak across tenants (#316)."
    log "Sharing a file with an entire group is no longer possible; user-to-user sharing is unaffected."
else
    warn "Could not disable group sharing. Apply it by hand:"
    warn "  docker exec -u www-data hermes_nextcloud php /var/www/html/occ \\"
    warn "    config:app:set core shareapi_allow_group_sharing --value=no"
fi

exit 0
