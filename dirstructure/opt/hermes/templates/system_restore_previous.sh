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
THEERROR=0

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then


# ===== THE SETTINGS BELOW ONLY VALID FOR RESTORING HERMES SEG 14.04 BACKUP TO HERMES SEG 16.04 ===

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 26. STARTED SYSTEM_SETTINGS TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysqldump -v --user=$MYSQLUSER --password=$MYSQLPASS hermes system_settings>$BACKUPS/system_settings.sql 2> $BACKUPS/mysqlbackup-system_settings-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSTEM_SETTINGS TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 26. COMPLETED SYSTEM_SETTINGS TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 26. STARTED SYSTEM_UPDATES TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

/usr/bin/mysqldump -v --user=$MYSQLUSER --password=$MYSQLPASS hermes system_updates>$BACKUPS/system_updates.sql 2> $BACKUPS/mysqlbackup-system_updates-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSTEM_UPDATES TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 26. COMPLETED SYSTEM_UPDATES TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 26. STARTED SYSTEM_USERS TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

/usr/bin/mysqldump -v --user=$MYSQLUSER --password=$MYSQLPASS hermes system_users>$BACKUPS/system_users.sql 2> $BACKUPS/mysqlbackup-system_users-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSTEM_USERS TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 26. COMPLETED SYSTEM_USERS TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 26. STARTED PARAMETERS2 TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

/usr/bin/mysqldump -v --user=$MYSQLUSER --password=$MYSQLPASS hermes parameters2>$BACKUPS/parameters2.sql 2> $BACKUPS/mysqlbackup-parameters2-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING PARAMETERS2 TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 26. COMPLETED PARAMETERS2 TABLE BACKUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

# ===== THE SETTINGS ABOVE ONLY VALID FOR RESTORING HERMES SEG 14.04 BACKUP TO HERMES SEG 16.04 ===


echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 26. STARTED FILE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

#PERFORM THE RESTORE

cd /

# === EXTRACT ALL WITHOUT THE DATABASE .SQL BACKUP FILES AND WITHOUT /VAR/WWW/* AND WITHOUT THE /VAR/LIB/CLAMAV DIRECTORIES AND CONTENTS ===

/usr/bin/unrar x -y $BACKUPS/$THEFILE -x'*.sql' -x'/var/www/schedule' -x'/var/www/html/schedule' -x'/var/www/WEB-INF/railo/scheduler' -x'/var/www/html/WEB-INF/lucee/scheduler' -x'/var/lib/clamav' >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 26. COMPLETED FILE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 11 OF 26. STARTED DATABASE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/bin/mkdir $BACKUPS/$TRANSACTION

# === EXTRACT ONLY THE DATABASE .SQL BACKUP FILES ===

/usr/bin/unrar x -y $BACKUPS/$THEFILE mnt/hermesbackups/dbbkup/* $BACKUPS/$TRANSACTION >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 12 OF 26. COMPLETED DATABASE EXTRACTION" >> $BACKUPS/restorelog-$TIMESTAMP.log

# === IMPORT THE .SQL BACKUP FILES ===

echo "[`date +%m/%d/%Y-%H:%M`] STEP 13 OF 26. STARTED HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost hermes<$BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/hermes.sql 2> $BACKUPS/mysqlrestore-hermes-output-$TIMESTAMP.log


ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 14 OF 26. COMPLETED HERMES DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 15 OF 26. STARTED DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost djigzo<$BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/djigzo.sql 2> $BACKUPS/mysqlrestore-djigzo-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 16 OF 26. COMPLETED DJIGZO DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 17 OF 26. STARTED SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost Syslog<$BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/syslog.sql 2> $BACKUPS/mysqlrestore-syslog-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 17 OF 26. COMPLETED SYSLOG DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 18 OF 26. STARTED OPENDMARC DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost opendmarc<$BACKUPS/$TRANSACTION/mnt/hermesbackups/dbbkup/opendmarc.sql 2> $BACKUPS/mysqlrestore-opendmarc-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING OPENDMARC DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 18 OF 26. COMPLETED OPENDMARC DATABASE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 19 OF 26. STARTED PERMISSIONS ADJUST AND OTHER HOUSEKEEPING TASKS" >> $BACKUPS/restorelog-$TIMESTAMP.log


#ADJUST PERMISSIONS
/bin/chown amavis:amavis /etc/postfix/relay_domains && \
/bin/chown -R amavis:amavis /mnt/data/amavis && \
/bin/chown -R amavis:amavis /opt/hermes/sa-bayes && \
/bin/chmod -R go-rwx /opt/hermes/.gnupg/ && \
/bin/chmod +x /opt/hermes/scripts/* && \
/bin/chmod +x /opt/hermes/templates/*.sh && \
/usr/bin/dos2unix /opt/hermes/scripts/* && \
/usr/bin/dos2unix /opt/hermes/templates/*.sh && \
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/ && \
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/keys/ && \
/bin/chown -R opendkim:opendkim /var/run/opendkim/ && \
/bin/chown -R opendmarc:opendmarc /var/run/opendmarc/ >> $BACKUPS/restorelog-$TIMESTAMP.log

#Check if /var/www/html/admin/Application.cfc exists and if exists, delete /var/www/html/admin/Application.cfm
if [ -f "/var/www/html/admin/Application.cfc" ]; then
      /bin/rm /var/www/html/admin/Application.cfm >> $BACKUPS/restorelog-$TIMESTAMP.log
   fi

#Check if /var/www/html/users/Application.cfc exists and if exists, delete /var/www/html/users/Application.cfm
if [ -f "/var/www/html/users/Application.cfc" ]; then
      /bin/rm /var/www/html/users/Application.cfm >> $BACKUPS/restorelog-$TIMESTAMP.log
   fi

#Check if /var/www/html/schedule/Application.cfc exists and if exists, delete /var/www/html/schedule/Application.cfm
if [ -f "/var/www/html/schedule/Application.cfc" ]; then
      /bin/rm /var/www/html/schedule/Application.cfm >> $BACKUPS/restorelog-$TIMESTAMP.log
   fi

#Check if /var/www/html/main/Application.cfc exists and if exists, delete /var/www/html/main/Application.cfm
if [ -f "/var/www/html/main/Application.cfc" ]; then
      /bin/rm /var/www/html/main/Application.cfm >> $BACKUPS/restorelog-$TIMESTAMP.log
   fi



echo "[`date +%m/%d/%Y-%H:%M`] STEP 19 OF 26. COMPLETED PERMISSIONS ADJUST AND OTHER HOUSEKEEPING TASKS" >> $BACKUPS/restorelog-$TIMESTAMP.log


echo "[`date +%m/%d/%Y-%H:%M`] STEP 20 OF 26. STARTED SYSTEM_SETTINGS AND SYSTEM_UPDATES TABLES RESTORE" >> $BACKUPS/restorelog-$TIMESTAMP.log

#RESTORE PREVIOUSLY BACKED UP SYSTEM_SETTINGS & SYSTEM_UPDATES TABLES

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost hermes<$BACKUPS/system_settings.sql 2> $BACKUPS/mysqlrestore-system_settings-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSTEM_SETTINGS AND SYSTEM_UPDATES TABLES RESTORE" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 20 OF 26. COMPLETED SYSTEM_SETTINGS AND SYSTEM UPDATES TABLES RESTORE" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 21 OF 26. STARTED SYSTEM_UPDATES TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost hermes<$BACKUPS/system_updates.sql 2> $BACKUPS/mysqlrestore-system_updates-output-$TIMESTAMP.log



ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSTEM_UPDATES TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 21 OF 26. COMPLETED SYSTEM_UPDATES TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 22 OF 26. STARTED SYSTEM_USERS TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost hermes<$BACKUPS/system_users.sql 2> $BACKUPS/mysqlrestore-system_users-output-$TIMESTAMP.log


ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING SYSTEM_USERS TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 22 OF 26. COMPLETED SYSTEM_USERS TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 23 OF 26. STARTED PARAMETERS TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/mysql -v -u $MYSQLUSER -p$MYSQLPASS -h localhost hermes<$BACKUPS/parameters2.sql 2> $BACKUPS/mysqlrestore-parameters2-output-$TIMESTAMP.log

ERR=$?

if [ $ERR != 0 ]; then

THEERROR=$(($THEERROR+$ERR))

echo "[`date +%m/%d/%Y-%H:%M`] ERROR: $ERR, OCCURED DURING PARAMETERS2 TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 23 OF 26. COMPLETED PARAMETER2 TABLE IMPORT" >> $BACKUPS/restorelog-$TIMESTAMP.log

fi


#DELETE RESTORED SYSTEM-SETTINGS.SQL, SYSTEM_UPDATES.SQL, SYSTEM_USERS.SQL AND PARAMETERS2.SQL FILES
/bin/rm -rf $BACKUPS/system_settings.sql
/bin/rm -rf $BACKUPS/system_updates.sql
/bin/rm -rf $BACKUPS/system_users.sql
/bin/rm -rf $BACKUPS/parameters2.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 24 OF 26. STARTED BACKUPS, RESTORE, ARCHIVE JOBS CLEANUP, SYSTEM SETTINGS RESET" >> $BACKUPS/restorelog-$TIMESTAMP.log

#DELETE BACKUP, RESTORE AND EMAIL ARCHIVE JOBS
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; delete from backup_jobs"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; delete from restore_jobs"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; delete from archive_jobs"

#RESET HERMES, DJIGZO AND SYSLOG USERNAME AND PASSWORDS IN SYSTEM_SETTINGS
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_username_hermes'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_password_hermes'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_username_djigzo'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_password_djigzo'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_username_syslog'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_password_syslog'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_username_opendmarc'"
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '' where parameter = 'mysql_password_opendmarc'"


#SET WIZARD_SETTINGS TO 2
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update system_settings set value = '2' where parameter = 'wizard_settings'"

echo "[`date +%m/%d/%Y-%H:%M`] STEP 24 OF 26. COMPLETED BACKUPS, RESTORE, ARCHIVE JOBS CLEANUP, SYSTEM SETTINGS RESET" >> $BACKUPS/restorelog-$TIMESTAMP.log


# ===== THE SETTINGS ABOVE ONLY VALID FOR RESTORING HERMES SEG 14.04 BACKUP TO HERMES SEG 16.04 ===



# ===== CLEAN UP THE BACKUPS === 

echo "[`date +%m/%d/%Y-%H:%M`] STEP 25 OF 26. STARTED BACKUPS CLEANUP" >> $BACKUPS/restorelog-$TIMESTAMP.log

/bin/rm -rf $BACKUPS/$TRANSACTION

echo "[`date +%m/%d/%Y-%H:%M`] STEP 25 OF 26. COMPLETED BACKUPS CLEANUP" >> $BACKUPS/restorelog-$TIMESTAMP.log


# === IF ANY ERRORS DURING SCRIPT, THEN LOG FAILURE AND SEND FAILED RESTORE MESSAGE ===

if [ $THEERROR != 0 ]; then

echo "[`date +%m/%d/%Y-%H:%M`] STEP 26 OF 26. STARTED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Failure `hostname --fqdn` Restore" -m "Failure `hostname --fqdn` Restore. Please review restorelog to identify problems with the restore, correct them and retry restore operation."  -s localhost

echo "[`date +%m/%d/%Y-%H:%M`] STEP 26 OF 26. COMPLETED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log


echo "[`date +%m/%d/%Y-%H:%M`] RESTORE COMPLETED WITH ERRORS. PLEASE REVIEW RESTORELOG TO IDENTIFY PROBLEMS WITH THE RESTORE, CORRECT THEM AND RETRY RESTORE OPERATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

# === IF NO ERRORS DURING SCRIPT, THEN LOG SUCCES AND SEND SUCCESS RESTORE MESSAGE ===

else

echo "[`date +%m/%d/%Y-%H:%M`] STEP 26 OF 26. STARTED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log

/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Success `hostname --fqdn` Restore" -m "Success `hostname --fqdn` Restore"  -s localhost

echo "[`date +%m/%d/%Y-%H:%M`] STEP 26 OF 26. COMPLETED EMAIL NOTIFICATION" >> $BACKUPS/restorelog-$TIMESTAMP.log


echo "[`date +%m/%d/%Y-%H:%M`] RESTORE COMPLETED SUCCESSFULLY. SYSTEM MUST BE REBOOTED FOR CHANGES TO TAKE EFFECT" >> $BACKUPS/restorelog-$TIMESTAMP.log


fi


#UNMOUNT SHARE
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
