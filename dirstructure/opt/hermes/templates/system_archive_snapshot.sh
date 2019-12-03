#!/bin/bash
ARCHIVE="/mnt/hermesemail_archive"
MYSQLUSER="MYSQL-USER"
MYSQLPASS="MYSQL-PASS"

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/bin/umount -f -l $ARCHIVE

#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,vers=SAMBAVER,username='USERNAME',domain='DOMAIN',password='PASSWORD' $ARCHIVE/  2>&1 | tee /opt/hermes/tmp/CUSTOM-TRANS_mount.log

#CHECK IF MOUNT EXISTS
if mount | grep $ARCHIVE; then

pid=$$

#echo $pid >/opt/hermes/tmp/archive-app.pid
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update archive_jobs set pid = '$pid' where customtrans = 'CUSTOM-TRANS'"

/usr/bin/rsync -azP --files-from=/opt/hermes/tmp/CUSTOM-TRANS_rsyncfiles / $ARCHIVE >> /opt/hermes/tmp/CUSTOM-TRANS.log

ip=/opt/hermes/tmp/CUSTOM-TRANS_rsynccheck
for i in `cat "$ip"`
do
if [ -r $ARCHIVE/mnt/data/amavis/$i ]; then
echo "file $ARCHIVE/mnt/data/amavis/$i exists" | tee -a /opt/hermes/tmp/CUSTOM-TRANS.log

/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update msgs set archive = 'Y', time_iso = time_iso where quar_loc = '$i'"

/bin/rm -rf /mnt/data/amavis/$i

echo "file /mnt/data/amavis/$i was removed from appliance storage and set to archived" | tee -a /opt/hermes/tmp/CUSTOM-TRANS.log

else
echo "file $ARCHIVE/mnt/data/amavis/$i does not exist. No action was taken" | tee -a /opt/hermes/tmp/CUSTOM-TRANS.log

fi

done

else
echo "Not mounted"

#SEND FAILURE EMAIL
/usr/bin/sendemail -f FROM -t TO -u "Failure `hostname --fqdn` Email Archive Job" -m "Failure `hostname --fqdn` Email Archive. Unable to to attach archive share. Attached log may assist in trouleshooting the problem"  -s localhost -a /opt/hermes/tmp/CUSTOM-TRANS_mount.log

#REMOVE MOUNT LOG
/bin/rm -rf /opt/hermes/tmp/CUSTOM-TRANS_mount.log

fi


DATE=`date +%Y-%m-%d:%H:%M:%S`

# DELETE OLDER SNAPSHOT AND LOG .7z FILES
/usr/bin/find $ARCHIVE/*.7z -mtime +RETENTION -exec rm {} \;

TIMESTAMP=`date +%m-%d-%Y-%H%M`

/usr/bin/7z a -t7z -ssc -m0=LZMA2:d64k:fb32 -ms=8m -mmt=8 -mx=1 $ARCHIVE/hermesemail_archive_$TIMESTAMP.7z $ARCHIVE/mnt/*  >> /opt/hermes/tmp/CUSTOM-TRANS.log

#SET ENDTIME ON ARCHIVE JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update archive_jobs set enddate = '$DATE' where customtrans = 'CUSTOM-TRANS'"

#SET STOPPED STATUS ON ARCHIVE JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update archive_jobs set status = '' where customtrans = 'CUSTOM-TRANS'"

#COMPRESS LOG FILE
/usr/bin/7z a -t7z -ssc -m0=LZMA2:d64k:fb32 -ms=8m -mmt=8 -mx=1 /opt/hermes/tmp/archive_log_CUSTOM-TRANS.7z /opt/hermes/tmp/CUSTOM-TRANS.log

#MOVE LOG FILE
/bin/mv /opt/hermes/tmp/archive_log_CUSTOM-TRANS.7z $ARCHIVE

#SEND SUCCESS EMAIL
/usr/bin/sendemail -f FROM -t TO -u "Success `hostname --fqdn` Email Archive" -m "Success `hostname --fqdn` Email Archive."  -s localhost

#REMOVE MOUNT LOG
/bin/rm -rf /opt/hermes/tmp/CUSTOM-TRANS_mount.log

#REMOVE THIS SCRIPT AND RSYNCFILES AND RSYNCCHECK FILES
/usr/bin/curl --data "trans=CUSTOM-TRANS" http://localhost:8888/schedule/delete_archive_task.cfm

