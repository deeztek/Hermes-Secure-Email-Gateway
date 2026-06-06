#!/bin/bash
# Get ARCHIVE_MOUNT filesystem usage (#260)
# Returns the disk usage percentage of the host disk backing the Archive tier
# (Amavis quarantine).
# Probes /mnt/data/amavis in the commandbox container -- that path is bound
# from the amavis_data volume, which post-#260 lives under ${ARCHIVE_MOUNT}/amavis.

if [ -d /mnt/data/amavis ]; then
    /bin/df /mnt/data/amavis 2>/dev/null | tail -1 | awk '{print $5}'
else
    # Return 0% if not available
    echo "0%"
fi
