#!/usr/bin/env bash
# FRESH-INSTALL: covered-by config/hermes/opt/hermes/conf_files/mysql-virtual-mailbox-domains.HERMES
#
# v261027 -- hybrid domains must not be mailbox-only domains in Postfix
#
# v261026 (#371) gave every hybrid domain a mailbox_domains row, its
# certificate binding. Postfix's virtual_mailbox_domains lookup listed every
# mailbox_domains row, so a hybrid domain became mailbox-only and Postfix
# rejected its relay recipients: "550 5.1.1 User unknown in virtual mailbox
# table". A hybrid domain's mail runs through the relay path (converted
# mailboxes by their per-recipient lmtp route), so the lookup now leaves
# hybrid domains out.
#
# The live map is rendered once at install and upgrades do not re-render it,
# so the query line is rewritten here. Postfix is reloaded so the change
# applies even when its container is not recreated. Idempotent.

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

map="${HERMES_ROOT}/config/postfix-dkim/etc/postfix/mysql-virtual-mailbox-domains.cf"
query="query = SELECT 1 FROM mailbox_domains md WHERE md.domain='%s' AND NOT EXISTS (SELECT 1 FROM domains d WHERE d.domain = md.domain AND d.type = 'hybrid')"

if [[ ! -f "$map" ]]; then
    echo "  mysql-virtual-mailbox-domains.cf not found; nothing to change."
    exit 0
fi
if grep -q "type = 'hybrid'" "$map"; then
    echo "  mysql-virtual-mailbox-domains.cf already leaves hybrid domains out."
    exit 0
fi

cp -p "$map" "${map}.pre-v261027.bak"
sed -i "s|^query = .*|${query}|" "$map"
echo "  mysql-virtual-mailbox-domains.cf: hybrid domains left out (backup: ${map##*/}.pre-v261027.bak)."

if docker ps --format '{{.Names}}' | grep -qx hermes_postfix_dkim; then
    docker exec hermes_postfix_dkim postfix reload >/dev/null 2>&1 \
        && echo "  Postfix reloaded." \
        || echo "  Postfix reload failed; it picks the change up when its container restarts." >&2
fi
exit 0
