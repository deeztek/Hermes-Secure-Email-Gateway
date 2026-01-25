#!/bin/bash

echo "Starting Hermes SEG DMARC"

echo "Setting Permissions"
chown -R opendmarc:opendmarc /etc/opendmarc

echo "Starting Ryslog"
/usr/sbin/rsyslogd

echo "Crating Syslog and setting permissions"
touch /var/log/syslog
chown syslog:adm /var/log/syslog

echo "Starting OpenDMARC"
/usr/sbin/opendmarc -c /etc/opendmarc/opendmarc.conf


echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
#exec tail -f /dev/null
exec tail -f /var/log/syslog

