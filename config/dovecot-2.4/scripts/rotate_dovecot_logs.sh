#!/bin/sh
#
# Hermes SEG - rotate Dovecot's log files
#
# Nothing rotated these. Dovecot writes dovecot.log, dovecot-info.log and
# dovecot-debug.log and grows all three forever. On a host that had debug
# logging switched on at some point, dovecot-debug.log reached 1.5 GB and
# dovecot-info.log 116 MB, with no mechanism anywhere to bound either. A full
# data volume defers all mail, so this is the same class of problem as the
# MariaDB logs (GitHub #339) and the missing disk alert (#341).
#
# Modelled on /opt/hermes/schedule/rotate_authelia_logs.sh, with two
# differences: it runs inside hermes_dovecot rather than hermes_commandbox,
# because the log volume is only mounted there, and retention is a constant
# rather than a database setting, because this container has no MySQL client
# and adding one to bound a log file is not a good trade.
#
# Scheduled daily by Ofelia. Safe to run by hand.

set -u

LOG_DIR="/logs"
RETENTION_DAYS=30
DATE_STAMP=$(date +%Y-%m-%d)

echo "$(date) - Dovecot log rotation started (retention: ${RETENTION_DAYS} days)"

for NAME in dovecot.log dovecot-info.log dovecot-debug.log; do
    LOG_FILE="${LOG_DIR}/${NAME}"

    # Absent or empty is the normal case for the debug log, and not a problem.
    if [ ! -f "$LOG_FILE" ] || [ ! -s "$LOG_FILE" ]; then
        continue
    fi

    ROTATED="${LOG_DIR}/${NAME}.${DATE_STAMP}"

    # Append if this already ran today, so a second run does not discard the
    # first one's output.
    if [ -f "${ROTATED}.gz" ]; then
        gunzip "${ROTATED}.gz" 2>/dev/null || true
    fi
    if [ -f "$ROTATED" ]; then
        cat "$LOG_FILE" >> "$ROTATED"
    else
        cp "$LOG_FILE" "$ROTATED"
    fi

    # Truncate in place rather than deleting. The file keeps its inode, so
    # Dovecot's already-open handles keep working whether or not the reopen
    # below succeeds, and nothing is lost in the gap.
    : > "$LOG_FILE"

    SIZE=$(wc -c < "$ROTATED" 2>/dev/null || echo 0)
    echo "$(date) - rotated ${NAME} (${SIZE} bytes), compressing"

    # nice/ionice because the first run on a host that has never rotated can
    # be compressing well over a gigabyte, and this runs on a live mail server.
    nice -n 19 gzip -f "$ROTATED" 2>/dev/null || echo "$(date) - WARNING: gzip failed for ${ROTATED}"
done

# Tell Dovecot to reopen its log files. Only needed if anything above replaced
# a file rather than truncating it, which this script does not do, so a failure
# here is not a problem.
if doveadm log reopen 2>/dev/null; then
    echo "$(date) - doveadm log reopen done"
else
    echo "$(date) - WARNING: doveadm log reopen failed (not fatal, logs were truncated in place)"
fi

DELETED=$(find "$LOG_DIR" -maxdepth 1 -name 'dovecot*.log.*.gz' -mtime +${RETENTION_DAYS} -print -delete 2>/dev/null | wc -l)
echo "$(date) - deleted ${DELETED} archive(s) older than ${RETENTION_DAYS} days"
echo "$(date) - Dovecot log rotation finished"

exit 0
