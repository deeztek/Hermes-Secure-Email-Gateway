#!/bin/bash

volume="/mnt/hermesarchivetest"
if mount | grep "on ${volume} type" > /dev/null
then

/bin/cp /opt/hermes/scripts/testsmb /mnt/hermesarchivetest

else

/bin/cp /opt/hermes/scripts/testsmb /dev/null

fi
