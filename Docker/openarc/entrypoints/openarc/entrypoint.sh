#!/bin/bash

echo "Starting Hermes SEG OpenARC"

# OpenARC needs its config + working dirs writable by the openarc user.
# /opt/hermes/arc/ holds keys, KeyTable, SigningTable — provisioned by the
# CFML admin UI (docker exec) on the host side.

echo "Setting Permissions"
mkdir -p /etc/openarc
mkdir -p /opt/hermes/arc/keys
mkdir -p /var/run/openarc
chown -R openarc:openarc /etc/openarc /opt/hermes/arc /var/run/openarc 2>/dev/null || true

# Bootstrap AuthservID: if the runtime config still has the literal sentinel
# from the in-repo starter (config/openarc/etc/openarc/openarc.conf), replace
# it with the container's actual hostname. This makes ARC-Authentication-
# Results headers on inbound mail show a real hostname instead of the
# placeholder string during the window between fresh install and the
# admin's first Save in the ARC Settings UI. After first Save, the CFML
# regenerator writes the admin-chosen value and this sed is a no-op.
if [ -f /etc/openarc/openarc.conf ] && grep -q 'AuthservID[[:space:]]*HERMES-AUTHSERV-ID' /etc/openarc/openarc.conf; then
    HOST_FOR_AUTHSERV="$(hostname)"
    echo "Bootstrap: substituting AuthservID placeholder with $HOST_FOR_AUTHSERV"
    sed -i "s/^AuthservID[[:space:]]*HERMES-AUTHSERV-ID/AuthservID              ${HOST_FOR_AUTHSERV}/" /etc/openarc/openarc.conf
fi

# Touch generated files if missing so KeyTable/SigningTable refdb lookups don't error
# on a brand-new install before the admin has generated any keys yet.
touch /opt/hermes/arc/KeyTable /opt/hermes/arc/SigningTable
chown openarc:openarc /opt/hermes/arc/KeyTable /opt/hermes/arc/SigningTable 2>/dev/null || true

echo "Starting Rsyslog"
/usr/sbin/rsyslogd

echo "Creating Syslog and setting permissions"
touch /var/log/syslog
chown syslog:adm /var/log/syslog

echo "Starting OpenARC"
/usr/sbin/openarc -c /etc/openarc/openarc.conf

echo "Startup Complete"

# Output to Docker logs and keep container alive
exec tail -f /var/log/syslog
