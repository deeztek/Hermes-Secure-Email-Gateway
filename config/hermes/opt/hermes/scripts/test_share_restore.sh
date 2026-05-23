#!/bin/bash

volume="/mnt/hermesrestoretest"
if mount | grep "on ${volume} type" > /dev/null
then

/bin/cp /opt/hermes/scripts/testsmb /mnt/hermesrestoretest

else

/bin/cp /opt/hermes/scripts/testsmb /dev/null

fi
