#!/bin/bash

# Hermes SEG - Authelia Log Rotation Script
# Rotates /logs/authelia.log to date-stamped files and cleans up old logs.
# Requires Authelia 4.39+ for SIGHUP log file reopening.
# Scheduled via Ofelia (daily).

LOG_DIR="/opt/hermes/logs/authelia"
LOG_FILE="${LOG_DIR}/authelia.log"
DATE_STAMP=$(date +%Y-%m-%d)
ROTATED_FILE="${LOG_DIR}/authelia.${DATE_STAMP}.log"

# Get database credentials
HERMESUSERNAME=$(</opt/hermes/creds/hermes_username)
HERMESPASSWORD=$(</opt/hermes/creds/hermes_password)

# Get retention days from database (default 30)
RETENTION_DAYS=$(mysql -h hermes_db_server -u $HERMESUSERNAME -p$HERMESPASSWORD hermes -sNe "SELECT value2 FROM parameters2 WHERE parameter='log.retention_days' AND module='authelia'" 2>/dev/null)
if [ -z "$RETENTION_DAYS" ] || ! [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    RETENTION_DAYS=30
fi

echo "$(date) - Authelia log rotation started (retention: ${RETENTION_DAYS} days)"

# Check if log file exists and has content
if [ ! -f "$LOG_FILE" ] || [ ! -s "$LOG_FILE" ]; then
    echo "$(date) - Log file does not exist or is empty. Nothing to rotate."
    exit 0
fi

# If today's rotated file already exists, append to it instead of overwriting
if [ -f "$ROTATED_FILE" ]; then
    cat "$LOG_FILE" >> "$ROTATED_FILE"
else
    cp "$LOG_FILE" "$ROTATED_FILE"
fi

# Truncate the active log file
> "$LOG_FILE"

# Send SIGHUP to Authelia to reopen log file (4.39+ feature)
/usr/local/bin/docker kill --signal=SIGHUP hermes_authelia 2>/dev/null
if [ $? -eq 0 ]; then
    echo "$(date) - SIGHUP sent to hermes_authelia"
else
    echo "$(date) - WARNING: Could not send SIGHUP to hermes_authelia"
fi

# Delete logs older than retention period
DELETED=0
find "$LOG_DIR" -name "authelia.*.log" -type f -mtime +${RETENTION_DAYS} | while read -r OLD_LOG; do
    rm -f "$OLD_LOG"
    echo "$(date) - Deleted old log: $(basename "$OLD_LOG")"
    DELETED=$((DELETED + 1))
done

echo "$(date) - Authelia log rotation completed"
