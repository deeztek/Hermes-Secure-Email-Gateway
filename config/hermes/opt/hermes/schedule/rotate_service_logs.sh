#!/bin/bash
#
# Hermes SEG - rotate the service log volumes that nothing else bounds
#
# Every Hermes image is FROM ubuntu:24.04 with no cron and no systemd. Ubuntu's
# packages install /etc/logrotate.d/* files, and nothing ever runs logrotate, so
# every file-based log in every container grows forever unless something here
# bounds it explicitly. Two already were: Authelia (rotate_authelia_logs.sh) and
# Dovecot (rotate_dovecot_logs.sh). This covers the remaining six volumes.
#
# A full data volume defers all mail, so this is the same class of problem as
# the MariaDB logs (GitHub #339) and the missing disk alert (#341).
#
# WHY ONE SCRIPT IN hermes_commandbox rather than one per container:
# each log volume is mounted in exactly one service, so a per-container job
# would need this file placed inside six images and six Ofelia entries to keep
# in step. Mounting the volumes here instead gives one script, one job and one
# retention setting. commandbox already holds the Authelia log volume for the
# same reason.
#
# WHY NO RELOAD SIGNAL: this truncates in place rather than renaming, which is
# logrotate's copytruncate. The file keeps its inode, so every already-open
# handle keeps working and there is no gap to lose lines in. rsyslog and nginx
# both open their logs O_APPEND, so writes resume at the new end of file. The
# same reasoning is written out in rotate_dovecot_logs.sh.
#
# Scheduled daily by Ofelia. Safe to run by hand.

set -u

LOG_ROOT="/opt/hermes/logs"
DATE_STAMP=$(date +%Y-%m-%d)

# The six volumes. Each is one host directory on the Data tier, mounted here by
# docker-compose.yml. A directory that is absent is skipped rather than warned
# about, so this stays quiet on an install where a service is not deployed.
TARGETS="postfix_dkim mail_filter dmarc openarc ldap nginx"

# Retention comes from parameters2.system_log_retention, the setting behind
# System > System Logs. The same value already governs how long rows survive in
# the Syslog database (schedule/message_cleanup.cfm), so one control now covers
# the rows and the files they came from.
HERMESUSERNAME=$(</opt/hermes/creds/hermes_username)
HERMESPASSWORD=$(</opt/hermes/creds/hermes_password)

RETENTION_DAYS=$(mysql -h hermes_db_server -u "$HERMESUSERNAME" -p"$HERMESPASSWORD" hermes -sNe \
    "SELECT value2 FROM parameters2 WHERE parameter='system_log_retention' LIMIT 1" 2>/dev/null)
if [ -z "$RETENTION_DAYS" ] || ! [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    RETENTION_DAYS=30
fi

echo "$(date) - service log rotation started (retention: ${RETENTION_DAYS} days)"

ROTATED_COUNT=0

for TARGET in $TARGETS; do
    DIR="${LOG_ROOT}/${TARGET}"
    [ -d "$DIR" ] || continue

    # maxdepth 2 because one service nests its log (clamav/clamav.log under
    # mail_filter). Globbing *.log is also what keeps this from re-rotating its
    # own output, since an archive is named <name>.log.<date>.gz.
    find "$DIR" -maxdepth 2 -type f -name '*.log' 2>/dev/null | while read -r LOG_FILE; do

        # Empty is the normal case for several of these and not a problem.
        [ -s "$LOG_FILE" ] || continue

        ROTATED="${LOG_FILE}.${DATE_STAMP}"

        # Append if this already ran today, so a second run does not discard
        # the first one's output.
        if [ -f "${ROTATED}.gz" ]; then
            gunzip "${ROTATED}.gz" 2>/dev/null || true
        fi
        if [ -f "$ROTATED" ]; then
            cat "$LOG_FILE" >> "$ROTATED"
        else
            cp "$LOG_FILE" "$ROTATED"
        fi

        # Truncate in place. See the copytruncate note in the header.
        : > "$LOG_FILE"

        SIZE=$(wc -c < "$ROTATED" 2>/dev/null || echo 0)
        echo "$(date) - rotated ${LOG_FILE#$LOG_ROOT/} (${SIZE} bytes), compressing"

        # nice because the first run on a host that has never rotated can be
        # compressing gigabytes, and this runs on a live mail server.
        nice -n 19 gzip -f "$ROTATED" 2>/dev/null \
            || echo "$(date) - WARNING: gzip failed for ${ROTATED}"

        # Match the archive to the live log rather than leaving it root-owned.
        # These volumes belong to different services (rsyslog as root, nginx,
        # slapd as openldap), so the owner is read off the file instead of
        # being hardcoded. This is the bug that had to be fixed after the
        # Dovecot script shipped: archives were root while the logs were vmail.
        if [ -f "${ROTATED}.gz" ]; then
            OWNER=$(stat -c '%u:%g' "$LOG_FILE" 2>/dev/null)
            MODE=$(stat -c '%a' "$LOG_FILE" 2>/dev/null)
            [ -n "$OWNER" ] && chown "$OWNER" "${ROTATED}.gz" 2>/dev/null || true
            [ -n "$MODE" ]  && chmod "$MODE"  "${ROTATED}.gz" 2>/dev/null || true
        fi
    done

    DELETED=$(find "$DIR" -maxdepth 2 -type f -name '*.log.*.gz' \
        -mtime +"${RETENTION_DAYS}" -print -delete 2>/dev/null | wc -l)
    if [ "$DELETED" -gt 0 ]; then
        echo "$(date) - ${TARGET}: deleted ${DELETED} archive(s) older than ${RETENTION_DAYS} days"
    fi
done

echo "$(date) - service log rotation finished"

exit 0
