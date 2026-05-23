#!/bin/bash
# Get amavis_data volume filesystem usage
# Returns the disk usage percentage
# The amavis_data volume is mounted at /mnt/data/amavis in the commandbox container

if [ -d /mnt/data/amavis ]; then
    /bin/df /mnt/data/amavis 2>/dev/null | tail -1 | awk '{print $5}'
else
    # Return 0% if not available
    echo "0%"
fi
