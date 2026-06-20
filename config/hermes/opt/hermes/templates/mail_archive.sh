#!/bin/bash
MYSQLUSER="MYSQL-USER"
MYSQLPASS="MYSQL-PASS"
THETRANS="CUSTOM-TRANS"


#Check if /opt/hermes/logs exists and if not create it
if [ ! -d "/opt/hermes/logs" ]; then
      /bin/mkdir -p /opt/hermes/logs
      
   fi

#Check if /opt/hermes/logs exists and if not exit
if [ ! -d "/opt/hermes/logs" ]; then
      echo "The /opt/hermes/logs directory does not exist even after attempting to create automatically. Exiting..."
      exit 1
   fi

#Check if /opt/hermes/logs/mailarchive.log exists and if exists compress it
if [ -f "/opt/hermes/logs/mailarchive.log" ]; then
      /bin/gzip /opt/hermes/logs/mailarchive.log
      
   fi

# DELETE LOGS OLDER THAN 14 DAYS
/usr/bin/find /opt/hermes/logs/mailarchive.* -mtime +14 -exec rm {} \;

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 11: Started moving messages from Hermes to Hermes Archive" >> /opt/hermes/logs/mailarchive.log
ip=/opt/hermes/tmp/$THETRANS-archivedfiles

for i in `cat "$ip"`
do

/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "insert into hermes_archive.msgs select * from hermes.msgs where hermes.msgs.mail_id like binary '$i'" 2>> /opt/hermes/logs/mailarchive.log

echo "$i was inserted into hermes_archive.msgs"  >> /opt/hermes/logs/mailarchive.log

/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "insert into hermes_archive.msgrcpt select * from hermes.msgrcpt where hermes.msgrcpt.mail_id like binary '$i'" 2>> /opt/hermes/logs/mailarchive.log

echo "$i was inserted into hermes_archive.msgrcpt"  >> /opt/hermes/logs/mailarchive.log

done

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 11: Finished moving messages from Hermes to Hermes Archive" >> /opt/hermes/logs/mailarchive.log


#echo "[`date +%m/%d/%Y-%H:%M`] STEP 11 OF 11: Archive job has finished successfully. Cleaning up" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#REMOVE MOUNT LOG
#/bin/rm -rf /opt/hermes/tmp/$THETRANS-mount.log 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#REMOVE THIS SCRIPT AND RSYNCFILES AND RSYNCCHECK FILES
#/usr/bin/curl --data "trans=$THETRANS" http://localhost:8888/schedule/delete_archive_task.cfm


