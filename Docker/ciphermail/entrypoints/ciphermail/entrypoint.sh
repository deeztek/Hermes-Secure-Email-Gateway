#!/bin/bash

echo "Starting Hermes SEG Ciphermail"


echo "Starting Ryslog"
/usr/sbin/rsyslogd

echo "Crating Syslog and setting permissions"
touch /var/log/syslog
chown syslog:adm /var/log/syslog

echo "Starting Ciphermail Back-End"
systemctl restart ciphermail-gateway-backend

echo "Starting Tomcat"
systemctl restart tomcat9


echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
#exec tail -f /dev/null
exec tail -f /var/log/syslog



