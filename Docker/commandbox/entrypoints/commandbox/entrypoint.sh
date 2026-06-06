#!/bin/bash

echo "Starting Hermes SEG Commandbox"

# Start haveged for entropy generation (improves GPG/SSL key generation speed)
if [ -x /usr/sbin/haveged ]; then
    /usr/sbin/haveged -w 1024
    echo "Started haveged entropy daemon"
fi

/usr/local/bin/box server start /var/www/html/server.json

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
exec tail -f /dev/null
#exec tail -f /var/log/syslog

