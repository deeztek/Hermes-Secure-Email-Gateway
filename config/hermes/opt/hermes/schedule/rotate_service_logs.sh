#!/bin/bash
#
# Hermes SEG - rotate every service log volume
#
# WHY THIS EXISTS AT ALL
#
# No Hermes container image runs cron or systemd. Every image is FROM
# ubuntu:24.04 (or a slim/official base), so the /etc/logrotate.d/* files that
# Ubuntu's own packages install inside those images are present and never
# execute. A log file written to disk is therefore bounded only where something
# schedules it explicitly, and for most of the stack nothing did. One volume
# reached 20 GB and a Dovecot debug log 1.5 GB. A full data volume makes Postfix
# defer every message with "452 Insufficient system storage", which reads as a
# mail problem and is not one.
#
# WHY ONE SCRIPT IN hermes_commandbox
#
# There are eight log volumes and each is mounted at /var/log or /logs inside
# its own service, so they cannot share a path in one container. docker-compose
# mounts all eight into this container under /servicelogs/<name> instead, which
# makes one job enough. The alternative, a job per container, would mean this
# file placed inside eight images, eight Ofelia entries kept in step, and no
# database access to read the retention setting from (which is exactly why the
# script this replaces had to hardcode 30 days).
#
# /servicelogs rather than /opt/hermes/logs: /opt/hermes is a bind mount of the
# repo working tree, so nesting mounts under it creates empty directories in the
# checkout, and mail_archive.sh already writes mailarchive.log there.
#
# WHY NO RELOAD SIGNAL
#
# This copies then truncates in place, which is logrotate's copytruncate. The
# file keeps its inode, so every already-open handle keeps working and there is
# no gap in which lines are lost. rsyslog, nginx and Dovecot all open their logs
# O_APPEND, so writes resume at the new end of file. That is also what lets one
# script serve every daemon here: no per-daemon reopen signal is needed, so
# there is nothing to get wrong per service.
#
# Scheduled daily by Ofelia. Safe to run by hand, and safe to run twice in a day
# (the second run appends to the same archive rather than replacing it).

set -u

LOG_ROOT="/servicelogs"
DATE_STAMP=$(date +%Y-%m-%d)

HERMESUSERNAME=$(</opt/hermes/creds/hermes_username)
HERMESPASSWORD=$(</opt/hermes/creds/hermes_password)

# Read one parameters2 value, or print nothing.
db_value() {  # <parameter> <module>
    mysql -h hermes_db_server -u "$HERMESUSERNAME" -p"$HERMESPASSWORD" hermes -sNe \
        "SELECT value2 FROM parameters2 WHERE parameter='$1' AND module='$2' LIMIT 1" 2>/dev/null
}

# The global default, from System > System Logs. The same setting already
# governs how long entries survive in the Syslog database, so one control now
# covers the rows and the files those rows came from.
DEFAULT_RETENTION=$(db_value 'system_log_retention' 'systemlog')
if [ -z "$DEFAULT_RETENTION" ] || ! [[ "$DEFAULT_RETENTION" =~ ^[0-9]+$ ]]; then
    DEFAULT_RETENTION=30
fi

# Authelia is the one exception, and it is not arbitrary: it has its own
# retention control on the Authentication Settings page, stored separately. If
# this used the global value for it, that control would silently stop doing
# anything.
AUTHELIA_RETENTION=$(db_value 'log.retention_days' 'authelia')
if [ -z "$AUTHELIA_RETENTION" ] || ! [[ "$AUTHELIA_RETENTION" =~ ^[0-9]+$ ]]; then
    AUTHELIA_RETENTION="$DEFAULT_RETENTION"
fi

# One directory per log volume, named as docker-compose.yml mounts it. A
# directory that is absent is skipped silently, so this stays quiet on an
# install where a service is not deployed.
TARGETS="authelia dovecot postfix_dkim mail_filter dmarc openarc ldap nginx"

retention_for() {
    case "$1" in
        authelia) echo "$AUTHELIA_RETENTION" ;;
        *)        echo "$DEFAULT_RETENTION" ;;
    esac
}

# Tell a service to reopen its log file, where that service needs telling.
#
# Truncating in place normally makes this unnecessary: the inode is kept, and a
# daemon that opened its log O_APPEND resumes writing at the new end of file.
# That holds for rsyslog, nginx, slapd and Dovecot.
#
# Authelia is the exception and it is not a guess: the script this replaced sent
# SIGHUP after truncating and documented it as requiring Authelia 4.39+ for log
# file reopening. Without it there is a real failure mode, where Authelia keeps
# writing at its pre-truncation offset and the file reads as hundreds of MB of
# leading NUL bytes. Harmless if it turns out to be unnecessary, so it stays.
#
# Non-fatal. A failure here means the log may need a container restart to
# resume, which is not worth aborting the other seven volumes over.
post_rotate() {  # <target>
    case "$1" in
        authelia)
            if /usr/local/bin/docker kill --signal=SIGHUP hermes_authelia 2>/dev/null; then
                echo "$(date) - SIGHUP sent to hermes_authelia (reopen log)"
            else
                echo "$(date) - WARNING: could not SIGHUP hermes_authelia; its log may need a container restart to resume"
            fi
            ;;
        dovecot)
            # The script this replaced ran `doveadm log reopen` and judged it
            # unnecessary, since it truncates rather than renames. That is
            # probably right. It is here anyway, because the identical
            # inference about Authelia's SIGHUP was wrong, and the cost of
            # being wrong twice is higher than the cost of one docker exec.
            if /usr/local/bin/docker exec hermes_dovecot doveadm log reopen 2>/dev/null; then
                echo "$(date) - doveadm log reopen done"
            else
                echo "$(date) - WARNING: doveadm log reopen failed (not fatal, the logs were truncated in place)"
            fi
            ;;
    esac
}

# Rotate one file: copy aside, compress, truncate in place. Used for the
# per-directory scan below and for the explicit files after it.
rotate_one() {  # <path> [dead]
    LOG_FILE="$1"
    DEAD="${2:-}"

    # Empty is the normal case for several of these (Dovecot's debug log above
    # all) and is not a problem.
    [ -s "$LOG_FILE" ] || return 0

    ROTATED="${LOG_FILE}.${DATE_STAMP}"

    # Same-day second run: decompress, append, recompress. You cannot append to
    # a gzip stream, so this path needs the intermediate file. It only happens
    # on a manual re-run, when the live log holds minutes rather than days.
    if [ -f "${ROTATED}.gz" ]; then
        if ! gunzip "${ROTATED}.gz" 2>/dev/null; then
            echo "$(date) - WARNING: could not read ${ROTATED}.gz, leaving ${LOG_FILE} intact"
            return 0
        fi
        if ! cat "$LOG_FILE" >> "$ROTATED"; then
            echo "$(date) - WARNING: append failed, leaving ${LOG_FILE} intact"
            nice -n 19 gzip -f "$ROTATED" 2>/dev/null
            return 0
        fi
        SIZE=$(wc -c < "$ROTATED" 2>/dev/null || echo 0)
        : > "$LOG_FILE"
        echo "$(date) - rotated ${LOG_FILE} (${SIZE} bytes, appended), compressing"
        nice -n 19 gzip -f "$ROTATED" 2>/dev/null \
            || echo "$(date) - WARNING: gzip failed for ${ROTATED}"
        _match_owner "$LOG_FILE" "${ROTATED}.gz"
        return 0
    fi

    # First rotation today: compress STRAIGHT to the archive rather than copying
    # first. A 10.4 GB mail.log was observed on a live server, and copy-then-gzip
    # needs peak disk of twice the log size on the very volume that is short of
    # space. Streaming needs the log plus the compressed copy, roughly 1.07x.
    #
    # The truncate is gated on gzip succeeding. Copy-then-truncate without
    # checking would destroy the log if the copy ran out of space, which is
    # exactly the condition this script exists to prevent.
    SIZE=$(wc -c < "$LOG_FILE" 2>/dev/null || echo 0)
    echo "$(date) - rotating ${LOG_FILE} (${SIZE} bytes), compressing"

    # nice because the first run on a server that has never rotated can be
    # compressing gigabytes, and this runs on a live mail server.
    if nice -n 19 gzip -c "$LOG_FILE" > "${ROTATED}.gz" 2>/dev/null; then
        if [ -n "$DEAD" ]; then
            # A dead archive another rotator left behind. Nothing writes to it,
            # so truncating would leave a 0-byte file forever.
            rm -f "$LOG_FILE"
            echo "$(date) - archived and removed ${LOG_FILE}"
        else
            : > "$LOG_FILE"
        fi
        _match_owner "$LOG_FILE" "${ROTATED}.gz"
    else
        rm -f "${ROTATED}.gz"
        echo "$(date) - WARNING: compress failed for ${LOG_FILE}, left intact (check free space)"
    fi
}

# Match the archive to the live log rather than leaving it root-owned. These
# volumes belong to different services, so the owner is read off the file
# instead of being hardcoded: on one install Dovecot's logs turned out to be
# ubuntu-owned, not vmail, which the old hardcoded chown got wrong.
_match_owner() {  # <reference> <archive>
    [ -f "$2" ] || return 0
    if [ -e "$1" ]; then
        OWNER=$(stat -c '%u:%g' "$1" 2>/dev/null)
        MODE=$(stat -c '%a' "$1" 2>/dev/null)
        [ -n "$OWNER" ] && chown "$OWNER" "$2" 2>/dev/null || true
        [ -n "$MODE" ]  && chmod "$MODE"  "$2" 2>/dev/null || true
    fi
}

echo "$(date) - service log rotation started (retention: ${DEFAULT_RETENTION} days, authelia: ${AUTHELIA_RETENTION})"

for TARGET in $TARGETS; do
    DIR="${LOG_ROOT}/${TARGET}"
    [ -d "$DIR" ] || continue

    KEEP=$(retention_for "$TARGET")

    # maxdepth 2 because services nest logs (clamav/clamav.log under
    # mail_filter, nginx/*.log under nginx). Matching *.log is also what stops
    # this re-rotating its own output, since an archive is named
    # <name>.log.<date>.gz.
    #
    # The exclusions are Debian build artifacts, not logs. Docker seeds a new
    # named volume from the image's own /var/log, so dpkg.log, alternatives.log,
    # bootstrap.log, apt/* and dbconfig-common/* arrive in every one of these
    # volumes. They record what the image installed at build time and never
    # change again, so rotating them destroys install history to save nothing
    # and buries the real logs in output. faillog and lastlog are excluded for
    # a different reason: they are sparse binary files, not text.
    ROTATED_ANY=0
    for f in $(find "$DIR" -maxdepth 2 -type f -name '*.log' \
                    -not -path '*/apt/*' \
                    -not -path '*/dbconfig-common/*' \
                    -not -name 'dpkg.log' \
                    -not -name 'alternatives.log' \
                    -not -name 'bootstrap.log' \
                    -not -name 'faillog' \
                    -not -name 'lastlog' \
                    2>/dev/null); do
        if [ -s "$f" ]; then
            rotate_one "$f"
            ROTATED_ANY=1
        fi
    done

    # Only signal if something was actually rotated, so a quiet service does
    # not get a pointless SIGHUP every night.
    [ "$ROTATED_ANY" -eq 1 ] && post_rotate "$TARGET"

    DELETED=$(find "$DIR" -maxdepth 2 -type f -name '*.log.*.gz' \
        -mtime +"${KEEP}" -print -delete 2>/dev/null | wc -l)
    if [ "$DELETED" -gt 0 ]; then
        echo "$(date) - ${TARGET}: deleted ${DELETED} archive(s) older than ${KEEP} days"
    fi
done

# ----------------------------------------------------------------------------
# Nextcloud, by explicit path rather than by scanning a directory.
#
# nextcloud.log does not live in a dedicated log volume. It sits in the
# Nextcloud data directory, which commandbox already mounts for other reasons,
# so no new mount is needed. It is NOT added to TARGETS above because that
# would point the *.log scan at the whole Nextcloud data tree: slow, and it
# would rotate any file a user happened to upload with a .log extension.
#
# Nextcloud does have its own size-based rotation, and relying on it was a
# mistake. That rotation is a background job, and nothing on Hermes runs
# Nextcloud's cron: there is no scheduler entry, no cron in the image, and
# background_jobs mode is unset, so jobs fall back to AJAX mode where one
# queued job fires per page load. Observed result on a live server: 580 MB
# live, a 496 MB archive, and exactly one rotation in six months. The
# installer therefore sets log_rotate_size to 0, handing the job to this
# script, which runs on a scheduler that actually works.
#
# nextcloud.log.1 is included so the archive Nextcloud left behind is
# compressed and then aged out, rather than sitting there forever.
#
# Nextcloud background jobs not running is a broader problem than logs and is
# tracked separately.
# ----------------------------------------------------------------------------
NEXTCLOUD_DATA="/mnt/data/nextcloud/data"

# nextcloud.log is live. nextcloud.log.1 is a dead archive Nextcloud left
# behind before its internal rotation was switched off, so it is compressed and
# then REMOVED rather than truncated: nothing writes to it, and truncating would
# leave a 0-byte file sitting there forever.
rotate_one "${NEXTCLOUD_DATA}/nextcloud.log"
rotate_one "${NEXTCLOUD_DATA}/nextcloud.log.1" dead

if [ -d "$NEXTCLOUD_DATA" ]; then
    DELETED=$(find "$NEXTCLOUD_DATA" -maxdepth 1 -type f -name 'nextcloud.log*.gz' \
        -mtime +"${DEFAULT_RETENTION}" -print -delete 2>/dev/null | wc -l)
    if [ "$DELETED" -gt 0 ]; then
        echo "$(date) - nextcloud: deleted ${DELETED} archive(s) older than ${DEFAULT_RETENTION} days"
    fi
fi

echo "$(date) - service log rotation finished"

exit 0
