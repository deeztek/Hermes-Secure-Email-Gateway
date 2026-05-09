#!/bin/bash
set -e

echo "Starting Hermes SEG Body Milter"

# Verify config root exists. The volume mount in docker-compose.yml
# brings host-side ./config/body_milter/etc/hermes/body_milter/ in here.
# If a feature subdirectory hasn't been populated yet (no signatures
# or disclaimers configured), the milter loads an empty map for that
# feature and passes all mail through unmodified - safe default.
if [ ! -d /etc/hermes/body_milter ]; then
    echo "Creating /etc/hermes/body_milter (no host volume mount? running with default)"
    mkdir -p /etc/hermes/body_milter/disclaimers/files
    mkdir -p /etc/hermes/body_milter/signatures/files
fi

# Touch placeholder maps so the first-load mtime check has something to
# stat. Empty file = no map entries = the corresponding modifier never
# fires.
[ -e /etc/hermes/body_milter/disclaimers/disclaimer_by_sender ] || \
    touch /etc/hermes/body_milter/disclaimers/disclaimer_by_sender
mkdir -p /etc/hermes/body_milter/signatures/files
[ -e /etc/hermes/body_milter/signatures/signature_by_sender ] || \
    touch /etc/hermes/body_milter/signatures/signature_by_sender
# #226 Phase 2B: empty JSON object so the milter can parse without
# error before the first CFML resolver run.
[ -e /etc/hermes/body_milter/signatures/sender_data.json ] || \
    echo '{}' > /etc/hermes/body_milter/signatures/sender_data.json

# Hand off to the milter daemon. Foreground mode so dumb-init is the
# direct parent and signals propagate cleanly.
exec /usr/local/bin/hermes-body-milter
