#!/bin/bash
# Get CPU usage from host /proc (mounted at /host/proc)
# Reads /proc/stat twice with a 1 second delay to calculate CPU usage

# Check if host /proc is mounted
if [ -f /host/proc/stat ]; then
    PROC_PATH="/host/proc"
else
    PROC_PATH="/proc"
fi

# Read CPU stats
read_cpu_stats() {
    grep '^cpu ' "$PROC_PATH/stat" | awk '{print $2+$3+$4+$5+$6+$7+$8, $5}'
}

# First reading
STATS1=$(read_cpu_stats)
TOTAL1=$(echo $STATS1 | awk '{print $1}')
IDLE1=$(echo $STATS1 | awk '{print $2}')

# Wait 1 second
sleep 1

# Second reading
STATS2=$(read_cpu_stats)
TOTAL2=$(echo $STATS2 | awk '{print $1}')
IDLE2=$(echo $STATS2 | awk '{print $2}')

# Calculate CPU usage
TOTAL_DIFF=$((TOTAL2 - TOTAL1))
IDLE_DIFF=$((IDLE2 - IDLE1))

if [ $TOTAL_DIFF -gt 0 ]; then
    CPU_USAGE=$(awk "BEGIN {printf \"%.0f\", (($TOTAL_DIFF - $IDLE_DIFF) / $TOTAL_DIFF) * 100}")
else
    CPU_USAGE=0
fi

echo "${CPU_USAGE}%"
