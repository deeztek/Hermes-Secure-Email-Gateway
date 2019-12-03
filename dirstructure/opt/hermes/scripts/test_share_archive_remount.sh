#!/bin/bash

volume="/mnt/hermesemail_archive"
if mount | grep "on ${volume} type" > /dev/null
then

/bin/cp /opt/hermes/scripts/testsmb /mnt/hermesemail_archive

else

/bin/cp /opt/hermes/scripts/testsmb /dev/null

fi
