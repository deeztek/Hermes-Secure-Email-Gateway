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
/usr/bin/unrar x -y $BACKUPS/$THEFILE -x'*.sql' -x'/var/lib/clamav' >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 10. COMPLETED FILE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 10. STARTED DATABASE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/bin/mkdir $BACKUPS/$TRANSACTION

/usr/bin/unrar x -y $BACKUPS/$THEFILE mnt/hermesbackups/dbbkup/* $BACKUPS/$TRANSACTION  >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 10. COMPLETED DATABASE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 10. STARTED HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS hermes < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/hermes.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 10. COMPLETED HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 10. STARTED DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS djigzo < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/djigzo.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 10. COMPLETED DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 10. STARTED SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS Syslog < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/syslog.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 10. COMPLETED SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 10. STARTED OPENDMARC DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -u $MYSQLUSER -p$MYSQLPASS opendmarc < $BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/opendmarc.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 10. COMPLETED OPENDMARC DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 10. STARTED PERMISSIONS ADJUST AND OTHER HOUSEKEEPING TASKS" >> $BACKUPS/restorelog-$TIMESTAMP.log

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

#Check if /var/www/html/admin/Application.cfc exists and if exists, delete /var/www/html/admin/Application.cfm
if [ -f "/var/www/html/admin/Application.cfc" ]; then
      /bin/rm /var/www/html/admin/Application.cfm
   fi

#Check if /var/www/html/users/Application.cfc exists and if exists, delete /var/www/html/users/Application.cfm
if [ -f "/var/www/html/users/Application.cfc" ]; then
      /bin/rm /var/www/html/users/Application.cfm
   fi

#Check if /var/www/html/schedule/Application.cfc exists and if exists, delete /var/www/html/schedule/Application.cfm
if [ -f "/var/www/html/schedule/Application.cfc" ]; then
      /bin/rm /var/www/html/schedule/Application.cfm
   fi

#Check if /var/www/html/main/Application.cfc exists and if exists, delete /var/www/html/main/Application.cfm
if [ -f "/var/www/html/main/Application.cfc" ]; then
      /bin/rm /var/www/html/main/Application.cfm
   fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 10. COMPLETED PERMISSIONS ADJUST AND OTHER HOUSEKEEPING TASKS" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 10. STARTED BACKUPS CLEANUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

/bin/rm -rf $BACKUPS/$TRANSACTION

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 10. COMPLETED BACKUPS CLEANUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 10. STARTED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Success `hostname --fqdn` Restore" -m "Success `hostname --fqdn` Restore"  -s localhost

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 10. COMPLETED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 10. STARTED RESET BACKUP JOBS STATUS" >> $BACKUPS/restorelog-$TIMESTAMP.log

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = ''"

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 10. COMPLETED RESET BACKUP JOBS STATUS" >> $BACKUPS/restorelog-$TIMESTAMP.log

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
