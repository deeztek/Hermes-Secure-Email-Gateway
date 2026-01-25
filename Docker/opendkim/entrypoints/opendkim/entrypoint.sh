#!/bin/bash

echo "Starting Hermes SEG Opendkim"

echo "Starting Ryslog"
/usr/sbin/rsyslogd

echo "Starting Openkim"
service opendkim start

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
exec tail -f /dev/null
#exec tail -f /var/log/mail.log

