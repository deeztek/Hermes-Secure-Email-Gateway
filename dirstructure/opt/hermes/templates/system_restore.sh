#!/bin/bash

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/bin/umount -f -l /mnt/hermesrestore

#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,vers=SAMBAVER,username='USERNAME',domain='DOMAIN',password='PASSWORD' /mnt/hermesrestore/ 2>&1 | tee /opt/hermes/tmp/restore_mount.log




THEFILE="THE-FILE"
TRANSACTION="THE-TRANSACTION"
BACKUPS="/mnt/hermesrestore"
MYSQLUSER="MYSQL-USER"
MYSQLPASS="MYSQL-PASS"
TIMESTAMP=`date +%m-%d-%Y-%H%M`
THEBUILD="THE-BUILD"

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 9. STARTED FILE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

#PERFORM THE RESTORE
cd /
/usr/bin/unrar x -y $BACKUPS/$THEFILE -x'*.sql' >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 9. COMPLETED FILE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 9. STARTED DATABASE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/bin/mkdir $BACKUPS/$TRANSACTION

/usr/bin/unrar x -y $BACKUPS/$THEFILE mnt/hermesbackups/dbbkup/* $BACKUPS/$TRANSACTION  >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 9. COMPLETED DATABASE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 9. STARTED HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS hermes < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/hermes.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 9. COMPLETED HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 9. STARTED DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS djigzo < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/djigzo.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 9. COMPLETED DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 9. STARTED SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS Syslog < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/syslog.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 9. COMPLETED SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 9. STARTED PERMISSIONS ADJUST" >> $BACKUPS/restorelog-$TIMESTAMP.log

#ADJUST PERMISSIONS
/bin/chown amavis:amavis /etc/postfix/relay_domains
/bin/chown -R amavis:amavis /mnt/data/amavis
/bin/chown -R amavis:amavis /opt/hermes/sa-bayes
/bin/chmod -R go-rwx /opt/hermes/.gnupg/
/bin/chmod +x /opt/hermes/scripts/*
/bin/chmod +x /opt/hermes/templates/*.sh
/usr/bin/dos2unix /opt/hermes/scripts/*
/usr/bin/dos2unix /opt/hermes/templates/*.sh
/bin/chown -R opendkim /opt/hermes/dkim/
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/keys/
/bin/chown -R opendmarc:opendmarc /var/run/opendmarc/

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 9. COMPLETED PERMISSIONS ADJUST" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 9. STARTED BACKUPS CLEANUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

/bin/rm -rf $BACKUPS/$TRANSACTION

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 9. COMPLETED BACKUPS CLEANUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 9. STARTED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Success `hostname --fqdn` Restore" -m "Success `hostname --fqdn` Restore"  -s localhost

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 9. COMPLETED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 9. STARTED RESET BACKUP JOBS STATUS" >> $BACKUPS/restorelog-$TIMESTAMP.log

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = ''"

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 9. COMPLETED RESET BACKUP JOBS STATUS" >> $BACKUPS/restorelog-$TIMESTAMP.log

#REBOOT SYSTEM
#/sbin/reboot

echo "[`date +%m/%d/%Y-%H:%M`] RESTORE IS COMPLETE. SYSTEM MUST BE REBOOTED FOR CHANGES TO TAKE EFFECT" >> $BACKUPS/restorelog-$TIMESTAMP.log

#UNOUNT SHARE
/bin/umount -f -l $BACKUPS

#DELETE THIS SCRIPT
/bin/rm "$0"

else

#SET STOPPED STATUS ON RESTORE JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update restore_jobs set status = ''"


/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Failed `hostname --fqdn` Restore" -m "Failed `hostname --fqdn` Restore. Unable to attach restore share"  -s localhost

#DELETE THIS SCRIPT
/bin/rm "$0"

fi
