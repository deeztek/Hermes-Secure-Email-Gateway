#!/bin/bash
# Get memory usage from host /proc (mounted at /host/proc)
# Reads /proc/meminfo to calculate memory usage percentage

# Check if host /proc is mounted
if [ -f /host/proc/meminfo ]; then
    PROC_PATH="/host/proc"
else
    PROC_PATH="/proc"
fi

# Read memory info
MEM_TOTAL=$(grep '^MemTotal:' "$PROC_PATH/meminfo" | awk '{print $2}')
MEM_AVAILABLE=$(grep '^MemAvailable:' "$PROC_PATH/meminfo" | awk '{print $2}')

# If MemAvailable is not present (older kernels), calculate from Free + Buffers + Cached
if [ -z "$MEM_AVAILABLE" ]; then
    MEM_FREE=$(grep '^MemFree:' "$PROC_PATH/meminfo" | awk '{print $2}')
    BUFFERS=$(grep '^Buffers:' "$PROC_PATH/meminfo" | awk '{print $2}')
    CACHED=$(grep '^Cached:' "$PROC_PATH/meminfo" | awk '{print $2}')
    MEM_AVAILABLE=$((MEM_FREE + BUFFERS + CACHED))
fi

# Calculate memory usage percentage
if [ $MEM_TOTAL -gt 0 ]; then
    MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))
    MEM_USAGE=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED / $MEM_TOTAL) * 100}")
else
    MEM_USAGE=0
fi

echo "$MEM_USAGE"
