#!/bin/bash

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/bin/umount.cifs -f -l /mnt/hermesbackups

#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,vers=SAMBAVER,username='USERNAME',domain='DOMAIN',password='PASSWORD' /mnt/hermesbackups/ 2>&1 | tee /opt/hermes/tmp/backup_mount.log


JID="JOB-ID"
BACKUPS="/mnt/hermesbackups"
MYSQLUSER="MYSQL-USER"
MYSQLPASS="MYSQL-PASS"
FILENAME="hermes_sys"
TIMESTAMP=`date +%m-%d-%Y-%H%M`

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 10. STARTED SET RUNNING STATUS ON BACKUP JOB" >> $BACKUPS/backuplog-$TIMESTAMP.log

#SET RUNNING STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = 'running' where id = '$JID'"

echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 10. COMPLETED SET RUNNING STATUS ON BACKUP JOB" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 10. STARTED DELETE OLDER BACKUPS" >> $BACKUPS/backuplog-$TIMESTAMP.log

# DELETE FILES OLDER THAN 6 DAYS
/usr/bin/find $BACKUPS/*.backup -mtime +RETENTION -exec rm {} \;
/usr/bin/find $BACKUPS/*.rar -mtime +RETENTION -exec rm {} \;
/usr/bin/find $BACKUPS/*.log -mtime +RETENTION -exec rm {} \;

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 10. COMPLETED DELETE OLDER BACKUPS" >> $BACKUPS/backuplog-$TIMESTAMP.log

/bin/mkdir $BACKUPS/dbbkup

#BACKUP MYSQL DATABASES
echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 10. STARTED HERMES DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt hermes>$BACKUPS/dbbkup/hermes.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 10. COMPLETED HERMES DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 10. STARTED SYSLOG DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt Syslog>$BACKUPS/dbbkup/syslog.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 10. COMPLETED SYSLOG DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 10. STARTED DJIGZO DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt djigzo>$BACKUPS/dbbkup/djigzo.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 10. COMPLETED DJIGZO DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 10. STARTED OPENDMARC DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt opendmarc>$BACKUPS/dbbkup/opendmarc.sql

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 10. COMPLETED OPENDMARC DATABASE BACKUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 10. STARTED FILE BACKUPS" >> $BACKUPS/backuplog-$TIMESTAMP.log


#PERFORM THE BACKUP

/usr/bin/rar a -m1 -mt8  $BACKUPS/$FILENAME-$TIMESTAMP.rar /var/run/opendmarc/opendmarc.dat /var/run/opendmarc/opendmarc_import.dat /etc/clamav/clamd.conf /etc/clamav-unofficial-sigs/user.conf /var/lib/clamav /etc/postfix/amavis_senderbypass /etc/postfix/amavis_senderbypass.db /etc/postfix/main.cf /etc/postfix/networks /etc/postfix/networks.db /etc/postfix/postscreen_access.cidr /etc/postfix/postscreen_access.cidr.db /etc/postfix/relay_domains /etc/postfix/relay_domains.db /etc/postfix/relay_passwd /etc/postfix/relay_passwd.db /etc/postfix/relay_recipients /etc/postfix/relay_recipients.db /etc/postfix/sender_access /etc/postfix/sender_access.db /etc/postfix/tls_policy /etc/postfix/tls_policy.db /etc/postfix/transport /etc/postfix/transport.db /etc/postfix/virtual /etc/postfix/virtual.db /etc/postfix/bcc_maps /etc/postfix/bcc_maps.db /etc/amavis/mynetworks /etc/amavis/black.lst /etc/amavis/white.lst /etc/amavis/conf.d/15-av_scanners /etc/amavis/conf.d/50-user /etc/spamassassin/local.cf /opt/hermes/ssl /opt/hermes/backups /opt/hermes/CA /opt/hermes/dkim /opt/hermes/HermesExternalCACerts /opt/hermes/keys /opt/hermes/root_ca /opt/hermes/sa-bayes /opt/hermes/schedule /opt/hermes/scheduled_tasks /opt/hermes/.gnupg /var/www/schedule /var/www/html/schedule /var/www/WEB-INF/railo/scheduler/scheduler.xml /var/www/html/WEB-INF/lucee/scheduler/scheduler.xml $BACKUPS/dbbkup/hermes.sql $BACKUPS/dbbkup/syslog.sql $BACKUPS/dbbkup/djigzo.sql $BACKUPS/dbbkup/opendmarc.sql >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 10. COMPLETED FILE BACKUPS" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 10. STARTED BACKUP FILE CLEANUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

/bin/rm -rf $BACKUPS/dbbkup

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 10. COMPLETED BACKUP FILE CLEANUP" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 10. STARTED EMAIL NOTIFICATION" >> $BACKUPS/backuplog-$TIMESTAMP.log

/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Success `hostname --fqdn` Backup" -m "Success `hostname --fqdn` Backup"  -s localhost

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 10. COMPLETED EMAIL NOTIFICATION" >> $BACKUPS/backuplog-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 10. STARTED SET BACKUP JOB STOPPED STATUS" >> $BACKUPS/backuplog-$TIMESTAMP.log

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = '' where id = '$JID'"

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 10. COMPLETED SET BACKUP JOB STOPPED STATUS" >> $BACKUPS/backuplog-$TIMESTAMP.log

#REMOVE MOUNT LOG
/bin/rm -rf /opt/hermes/tmp/backup_mount.log

echo "[`date +%m/%d/%Y-%H:%M`] BACKUP IS COMPLETE!!" >> $BACKUPS/backuplog-$TIMESTAMP.log

/bin/umount -f -l /mnt/hermesbackups

else

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = '' where id = '$JID'"

/usr/bin/sendemail -f FROM-EMAIL -t TO-EMAIL -u "Failed `hostname --fqdn` Backup" -m "Failed `hostname --fqdn` Backup. Unable to attach backup share. Attached backup mount log may assist in troubleshooting the problem"  -s localhost -a /opt/hermes/tmp/backup_mount.log

#REMOVE MOUNT LOG
/bin/rm -rf /opt/hermes/tmp/backup_mount.log


fi
