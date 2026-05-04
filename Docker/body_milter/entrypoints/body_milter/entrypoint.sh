#!/bin/bash
set -e

echo "Starting Hermes SEG Body Milter"

# Verify config root exists. The volume mount in docker-compose.yml
# brings host-side ./config/body_milter/etc/hermes/body_milter/ in here.
# If the disclaimer subdirectory hasn't been populated yet (no
# disclaimers configured by the admin), the milter will load with an
# empty map and pass all mail through unmodified - safe default.
if [ ! -d /etc/hermes/body_milter ]; then
    echo "Creating /etc/hermes/body_milter (no host volume mount? running with default)"
    mkdir -p /etc/hermes/body_milter/disclaimers/files
fi

# Touch placeholder map so the first-load mtime check has something to
# stat. Empty file = no map entries = no modifier ever fires.
[ -e /etc/hermes/body_milter/disclaimers/disclaimer_by_sender ] || \
    touch /etc/hermes/body_milter/disclaimers/disclaimer_by_sender

# Hand off to the milter daemon. Foreground mode so dumb-init is the
# direct parent and signals propagate cleanly.
exec /usr/local/bin/hermes-body-milter
