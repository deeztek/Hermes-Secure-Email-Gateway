#!/bin/bash

echo "Starting Hermes SEG Commandbox"

/usr/local/bin/box server start /var/www/html/server.json

echo "Startup Complete"


#Output to Docker logs and Keep Container Alive
exec tail -f /dev/null
#exec tail -f /var/log/syslog

