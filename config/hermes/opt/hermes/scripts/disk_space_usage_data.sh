#!/bin/bash
# Get DATA_MOUNT filesystem usage
# Returns the disk usage percentage of the host disk backing the Data tier.
# Probes /mnt/data/sieve in the commandbox container -- that path is bound
# from the dovecot_sieve volume, which lives under ${DATA_MOUNT}/dovecot/sieve.
# (Pre-#260 this script probed /mnt/data/amavis, but the amavis_data volume
# was moved to its own ARCHIVE tier in #260; /mnt/data/amavis now reflects
# the archive disk. /mnt/data/sieve stays on the Data tier and is a safe
# probe path.)

if [ -d /mnt/data/sieve ]; then
    /bin/df /mnt/data/sieve 2>/dev/null | tail -1 | awk '{print $5}'
else
    # Return 0% if not available
    echo "0%"
fi
