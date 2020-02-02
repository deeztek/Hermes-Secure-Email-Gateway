#!/bin/bash
ARCHIVE="/mnt/hermesemail_archive"
MYSQLUSER="MYSQL-USER"
MYSQLPASS="MYSQL-PASS"
LOGTIMESTAMP=`date +%m-%d-%Y-%H%M`
THETRANS="CUSTOM-TRANS"
THERECIPIENT="THE-RECIPIENT"
THESENDER="THE-SENDER"
THERETENTION="THE-RETENTION"

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 12: Started attempting to unmount busy archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#ATTEMPT UMOUNT BUSY CIFS SHARE
/bin/umount -f -l $ARCHIVE >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 12: Finished attempting to unmount busy archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 12: Started attempting to mount archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,vers=SAMBAVER,username='USERNAME',domain='DOMAIN',password='PASSWORD' $ARCHIVE/ 2>> /opt/hermes/tmp/$THETRANS-mount.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 12: Finished attempting to mount archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 12: Checking if archive SMB share exists" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#CHECK IF MOUNT EXISTS
if mount | grep $ARCHIVE; then
echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 12: Archive SMB share seems to exist. Proceeding with archive" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
pid=$$

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 12: Started setting script pid" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#echo $pid >/opt/hermes/tmp/archive-app.pid
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update archive_jobs set pid = '$pid' where customtrans = '$THETRANS'" 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 12: Finished setting script pid" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 12: Started syncing email files to archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
/usr/bin/rsync -azP --files-from=/opt/hermes/tmp/$THETRANS-rsyncfiles / $ARCHIVE 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 12: Finished syncing email files to archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 12: Started verification of email files in archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
ip=/opt/hermes/tmp/$THETRANS-rsynccheck
for i in `cat "$ip"`
do
if [ -r $ARCHIVE/mnt/data/amavis/$i ]; then
echo "file $ARCHIVE/mnt/data/amavis/$i exists" | tee -a $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update msgs set archive = 'Y', time_iso = time_iso where quar_loc = '$i'" 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

/bin/rm -rf /mnt/data/amavis/$i  2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "file /mnt/data/amavis/$i was removed from appliance storage and set to archived" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

else
echo "file $ARCHIVE/mnt/data/amavis/$i does not exist. No action was taken" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

fi

done

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 12: Finished verification of email files in archive SMB share" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
else
echo "[`date +%m/%d/%Y-%H:%M`] Archive SMB share does NOT exist. Archive job has failed" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] Sending archive job failed notification to $THERECIPIENT with mount log" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#SEND FAILURE EMAIL
/usr/bin/sendemail -f $THESENDER -t $THERECIPIENT -u "Failure `hostname --fqdn` Email Archive Job" -m "Failure `hostname --fqdn` Email Archive. Unable to to attach archive share. Attached log may assist in trouleshooting the problem"  -s localhost -a /opt/hermes/tmp/$THETRANS-mount.log 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] Removing mount log" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#REMOVE MOUNT LOG
/bin/rm -rf /opt/hermes/tmp/$THETRANS-mount.log 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

fi

DATE=`date +%Y-%m-%d:%H:%M:%S`

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 12: Started setting archive job endate/endtime in database" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#SET ENDTIME ON ARCHIVE JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update archive_jobs set jobenddate = '$DATE' where customtrans = '$THETRANS'" 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 12: Finished setting archive job endate/endtime in database" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 12: Started removing archive job running status from database" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#SET STOPPED STATUS ON ARCHIVE JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update archive_jobs set status = '' where customtrans = '$THETRANS'" 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 12: Finished removing archive job running status from database" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

#echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 12: Started compressing archive job log file" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#COMPRESS LOG FILE
#/usr/bin/7z a -t7z -ssc -m0=LZMA2:d64k:fb32 -ms=8m -mmt=8 -mx=1 $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.7z $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 12: Finished compressing archive job log file" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 12: Started removing archive job snapshots and log files older than $THERETENTION days" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
# DELETE OLDER THAN 14 DAYS .7z LOG FILES
/usr/bin/find $ARCHIVE/*.7z -mtime +$THERETENTION -exec rm {} \; 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
/usr/bin/find $ARCHIVE/*.log -mtime +THERETENTION -exec rm {} \; 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 12: Finished removing archive job snapshots and log files older than $THERETENTION days" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 12: Started creating email archive snapshots" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
/usr/bin/7z a -t7z -ssc -m0=LZMA2:d64k:fb32 -ms=8m -mmt=8 -mx=1 $ARCHIVE/hermesemail_archive_$TIMESTAMP.7z $ARCHIVE/mnt/*  >> $ARCHIVE/archivelog_$LOGTIMESTAMP_$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 12: Finished creating email archive snapshots" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 11 OF 12: Started sending archive job success notification to $THERECIPIENT" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#SEND SUCCESS EMAIL
/usr/bin/sendemail -f $THESENDER -t $THERECIPIENT -u "Success `hostname --fqdn` Email Archive" -m "Success `hostname --fqdn` Email Archive"  -s localhost 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
echo "[`date +%m/%d/%Y-%H:%M`] STEP 11 OF 12: Finished sending archive job success notification to $THERECIPIENT" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 12 OF 12: Archive job has finished successfully. Cleaning up" >> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#REMOVE MOUNT LOG
/bin/rm -rf /opt/hermes/tmp/$THETRANS-mount.log 2>> $ARCHIVE/archivelog-$LOGTIMESTAMP-$THETRANS.log
#REMOVE THIS SCRIPT AND RSYNCFILES AND RSYNCCHECK FILES
/usr/bin/curl --data "trans=$THETRANS" http://localhost:8888/schedule/delete_archive_task.cfm


