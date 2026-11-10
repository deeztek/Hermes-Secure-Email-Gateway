#!/bin/bash

echo "Starting Hermes SEG Commandbox"

# Start haveged for entropy generation (improves GPG/SSL key generation speed)
if [ -x /usr/sbin/haveged ]; then
    /usr/sbin/haveged -w 1024
    echo "Started haveged entropy daemon"
fi

# Driver bundles baked into the image (#402), so Lucee never has to download
# them. The server home is a volume, so copy them in on every start; a copy
# already there is left as is.
mkdir -p /serverhome/WEB-INF/lucee-server/bundles
cp -n /opt/lucee-bundles/*.jar /serverhome/WEB-INF/lucee-server/bundles/ 2>/dev/null || true

/usr/local/bin/box server start /var/www/html/server.json

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
exec tail -f /dev/null
#exec tail -f /var/log/syslog

