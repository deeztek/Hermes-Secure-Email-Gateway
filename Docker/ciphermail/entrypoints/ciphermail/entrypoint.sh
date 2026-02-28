#!/bin/bash

echo "Starting Hermes SEG Ciphermail"

# Create syslog and set permissions
echo "Setting up syslog..."
touch /var/log/syslog
chown syslog:adm /var/log/syslog

# Start Rsyslog
echo "Starting Rsyslog..."
/usr/sbin/rsyslogd

# Start Postfix
echo "Starting Postfix..."
postfix start

# Start Ciphermail Gateway Backend
echo "Starting Ciphermail Gateway Backend..."
/usr/share/djigzo/scripts/start-backend.sh &

# Start Tomcat (as tomcat user with required env vars)
echo "Starting Tomcat..."
export CATALINA_HOME=/usr/share/tomcat9
export CATALINA_BASE=/var/lib/tomcat9
export CATALINA_TMPDIR=/tmp
export JAVA_OPTS="-Djava.awt.headless=true"
# Run policy update and start tomcat as tomcat user
/usr/libexec/tomcat9/tomcat-update-policy.sh 2>/dev/null || true
su -s /bin/sh tomcat -c "/bin/sh /usr/libexec/tomcat9/tomcat-start.sh" &

echo "Startup Complete"

# Output to Docker logs and Keep Container Alive
exec tail -f /var/log/syslog
