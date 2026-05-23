#!/bin/bash
# Get root filesystem usage from host (host root mounted at /host/root)
# Returns the disk usage percentage of the host's / filesystem

# Check if host root filesystem is mounted
if [ -d /host/root ]; then
    # Get disk usage of the host's root filesystem via the mounted path
    /bin/df /host/root 2>/dev/null | tail -1 | awk '{print $5}'
else
    # Fallback to container's root if host mount not available
    /bin/df / | tail -1 | awk '{print $5}'
fi
