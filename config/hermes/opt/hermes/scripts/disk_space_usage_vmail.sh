#!/bin/bash
# Get dovecot_mail volume filesystem usage
# Returns the disk usage percentage
# The dovecot_mail volume is mounted at /mnt/data/vmail in the commandbox container

if [ -d /mnt/data/vmail ]; then
    /bin/df /mnt/data/vmail 2>/dev/null | tail -1 | awk '{print $5}'
else
    # Return 0% if not available
    echo "0%"
fi
