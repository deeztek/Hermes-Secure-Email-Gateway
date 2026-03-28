#!/bin/bash

echo "Starting Hermes SEG Opendkim"

echo "Setting Permissions"
chown opendkim:opendkim /etc/opendkim.conf
chown -R opendkim:opendkim /opt/hermes/dkim/

echo "Starting Ryslog"
/usr/sbin/rsyslogd

echo "Starting Opendkim"
service opendkim start

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
exec tail -f /dev/null
#exec tail -f /var/log/mail.log

