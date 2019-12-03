#!/bin/bash

volume="/mnt/hermesbackuptest"
if mount | grep "on ${volume} type" > /dev/null
then

/bin/cp /opt/hermes/scripts/testsmb /mnt/hermesbackuptest

else

/bin/cp /opt/hermes/scripts/testsmb /dev/null

fi
