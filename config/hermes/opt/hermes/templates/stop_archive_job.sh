#!/bin/bash

if ps -p THE-PID > /dev/null
then
/bin/kill -9 THE-PID
fi

FILE1=/opt/hermes/tmp/CUSTOM-TRANS-rsynccheck
if [ -f $FILE1 ]; then
/bin/rm $FILE1
fi

FILE2=/opt/hermes/tmp/CUSTOM-TRANS-rsyncfiles
if [ -f $FILE2 ]; then
/bin/rm $FILE2
fi

FILE3=/opt/hermes/tmp/CUSTOM-TRANS_system_archive.sh
if [ -f $FILE3 ]; then
/bin/rm $FILE3
fi

FILE4=/mnt/hermesemail_archive/*-CUSTOM-TRANS.log
if [ -f $FILE4 ]; then
/bin/rm $FILE4
fi

#FILE5=/opt/hermes/tmp/CUSTOM-TRANS.7z
#if [ -f $FILE5 ]; then
#/bin/rm $FILE5
#fi

FILE6=/opt/hermes/tmp/CUSTOM-TRANS-mount.log
if [ -f $FILE6 ]; then
/bin/rm $FILE6
fi

/usr/bin/pgrep 7z >> /opt/hermes/tmp/CUSTOM-TRANS_7z_pid

