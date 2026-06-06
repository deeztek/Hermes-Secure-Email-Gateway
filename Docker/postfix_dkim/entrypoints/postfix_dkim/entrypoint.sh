#!/bin/bash

echo "Starting Hermes SEG Postfix OpenDKIM"

echo "Setting Permissions"
chown syslog:adm /var/log
chmod 0775 /var/log

echo "Configuring OpenDKIM"
usermod -a -G opendkim postfix

echo "Setting DKIM key permissions"
if [ -d "/opt/hermes/dkim" ]; then
    chown -R opendkim:opendkim /opt/hermes/dkim/
    chmod 600 /opt/hermes/dkim/keys/*.private 2>/dev/null || true
fi

echo "Starting Rsyslog"
/usr/sbin/rsyslogd

# Populate Postfix chroot with DNS/name resolution files (required without systemd)
echo "Setting up Postfix chroot..."
cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
cp /etc/nsswitch.conf /var/spool/postfix/etc/nsswitch.conf
cp /etc/services /var/spool/postfix/etc/services
cp /etc/hosts /var/spool/postfix/etc/hosts

echo "Starting Postfix"
service postfix start

echo "Starting OpenDKIM"
service opendkim start

# #232 multi-instance OpenDKIM: sign-only secondary instance bound to
# :8892 for the post-CipherMail re-injection at master.cf :10026. The
# primary instance above (sv mode, :8891) keeps verifying inbound at
# :25 and signing submission at :587/:465.
echo "Starting OpenDKIM (sign-only secondary instance for :10026)"
/usr/sbin/opendkim -x /etc/opendkim-sign.conf


echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
#exec tail -f /dev/null
exec tail -f /var/log/mail.log

