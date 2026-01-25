#!/bin/bash
# Get nextcloud volume filesystem usage
# Returns the disk usage percentage
# The nextcloud volume is mounted at /mnt/data/nextcloud in the commandbox container

if [ -d /mnt/data/nextcloud ]; then
    /bin/df /mnt/data/nextcloud 2>/dev/null | tail -1 | awk '{print $5}'
else
    # Return 0% if not available
    echo "0%"
fi
