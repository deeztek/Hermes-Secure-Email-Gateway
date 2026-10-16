#!/usr/bin/env bash
# FRESH-INSTALL: n/a  a fresh install renders mysql.conf from the corrected templates
#
# v261017 -- valid rsyslog selector in the rendered Syslog forwarding config (#365)
#
# The OpenDMARC and mail filter containers forward their log lines to the
# Syslog database through config/<svc>/etc/rsyslog.d/mysql.conf, rendered at
# install from mysql.conf.template (untracked: it holds the database
# credentials). Line 5 used `syslog` as the selector, which is not a valid
# facility.priority pair; rsyslog warned at every start but still forwarded.
# The templates now use `*.*`, which forwards the same lines without the
# warning. This corrects files rendered by earlier installs. Runs before the
# containers are recreated, so they start on the corrected file.
#
# Idempotent: a file without the old selector is left alone.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]]; do
        [[ -f "$HERMES_ROOT/docker-compose.yml" ]] && break
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "  Could not locate docker-compose.yml walking up from $SCRIPT_DIR; skipping." >&2
        exit 0
    fi
fi

for svc in opendmarc mail_filter; do
    f="${HERMES_ROOT}/config/${svc}/etc/rsyslog.d/mysql.conf"
    if [[ ! -f "$f" ]]; then
        echo "  ${svc}: no rendered mysql.conf; nothing to correct."
        continue
    fi
    if grep -qE '^syslog[[:space:]]*:ommysql:' "$f"; then
        cp -p "$f" "${f}.pre-v261017"
        # Write in place (not sed -i, which replaces the file): a single-file
        # bind mount keeps pointing at the original inode.
        sed -E 's/^syslog[[:space:]]*:ommysql:/*.* :ommysql:/' "${f}.pre-v261017" > "$f"
        echo "  ${svc}: corrected the rsyslog selector (backup: ${f}.pre-v261017)."
    else
        echo "  ${svc}: rsyslog selector already valid."
    fi
done
