#!/bin/bash

echo "Starting Hermes SEG Nginx"

echo "Checking if /opt/hermes/ssl has been mounted"

#Check if /opt/hermes/ssl exists and if not exit
if [ ! -d "/opt/hermes/ssl" ]; then
      echo "/opt/hermes/ssl is nout mounted. Please mount and restart the container. Exiting for now..."
      exit 1
else

echo "Checking for Snakeoil Certificate"

#Check if /opt/hermes/ssl/ssl-cert-snakeoil_hermes.pem exists and if not generate it
if [ ! -f "/opt/hermes/ssl/ssl-cert-snakeoil_hermes.pem" ]; then

echo "Snakeoil Certificate not found, generating..."

#Create snakeoil default cert
/usr/bin/openssl req -x509 -newkey rsa:4096 -keyout /opt/hermes/ssl/ssl-cert-snakeoil_hermes.key -out /opt/hermes/ssl/ssl-cert-snakeoil_hermes.pem -sha256 -days 3650 -nodes -subj "/C=/ST=/L=/O=/OU=/CN="

echo "Snakeoil certificate has been generated., continuing..."

else

echo "Snakeoil Certificate found, continuing..."

   fi

echo "Setting Permissions"
chown syslog:adm /var/log
chmod 0775 /var/log


echo "Starting Ryslog"
/usr/sbin/rsyslogd

echo "Starting Nginx"
nginx -g 'daemon off;'

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
exec tail -f /dev/null
#exec tail -f /var/log/syslog

   fi
