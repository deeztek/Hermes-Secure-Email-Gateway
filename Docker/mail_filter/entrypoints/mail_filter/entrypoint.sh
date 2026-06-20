#!/bin/bash

echo "Starting Hermes SEG Mail Filter"

echo "Settings Permission on Amavis Directories"
chown -R amavis:amavis /var/lib/amavis
chown -R amavis:amavis /mnt/data/amavis

echo "Settings Persmissions on SpamAssassin Directories"
chown -R amavis:amavis /sa-bayes

echo "Setting Permissions on ClamAV Directory"
chown -R clamav /var/lib/clamav

echo "Setting Permissions on Fangfrisch files"

chmod +x /usr/local/bin/setup-clamav-sigs && \
chown root:clamav /etc/fangfrisch/fangfrisch.conf && \
chmod 640 /etc/fangfrisch/fangfrisch.conf && \
chown -R clamav /var/lib/fangfrisch/

echo "Checking to see if Fangfrisch Database Exists"
if [ ! -f "/var/lib/fangfrisch/db.sqlite" ]; then
      echo "Fangfisch Database does not exist, creating..."
      /bin/su -c "/usr/bin/fangfrisch --conf /etc/fangfrisch/fangfrisch.conf initdb" -s /bin/bash clamav
   fi

echo "Enabling Spamassasin Automatic Updates"
sed -i 's/CRON=0/CRON=1/g' /etc/cron.daily/spamassassin

echo "Starting Syslog"
/usr/sbin/rsyslogd

echo "Starting Cron"
service cron start

echo "Starting ClamAV"
service clamav-daemon start

echo "Staring ClamAV Freshclam"
service clamav-freshclam start

# amavisd refuses to load any /etc/amavis/conf.d/* file not owned by
# root:root (see Amavis::Conf hardening). Volume-mounted files from the
# host can land with non-root ownership; normalize before start so a
# fresh upload doesn't break the container.
echo "Normalizing ownership on Amavis config files"
chown root:root /etc/amavis/conf.d/* 2>/dev/null || true

echo "Starting Amavis"
service amavis start

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
#exec tail -f /dev/null
exec tail -f /var/log/syslog

