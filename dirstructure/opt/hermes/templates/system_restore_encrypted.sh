#!/bin/bash

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/bin/umount -f -l /mnt/hermesrestore

#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,username='USERNAME',domain='DOMAIN',password='PASSWORD' /mnt/hermesrestore/



THEFILE="THE-FILE"
TRANSACTION="THE-TRANSACTION"
BACKUPS="/mnt/hermesrestore"

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then


#DECRYPT ARCHIVE
/usr/bin/openssl aes-256-cbc -d -a -pass pass:UIeocFdAeq3k/ewFUS/k2Ol+EEsRlNMHz21WWabsZXE= -in $BACKUPS/$THEFILE -out $BACKUPS/$TRANSACTION.rar

#PERFORM THE RESTORE
cd /
/usr/bin/unrar x -y $BACKUPS/$TRANSACTION.rar  -x'*.sql'
/bin/mkdir $BACKUPS/$TRANSACTION
/usr/bin/unrar x -y $BACKUPS/$TRANSACTION.rar  mnt/hermesbackups/dbbkup/* $BACKUPS/$TRANSACTION

/usr/bin/mysql -u root -pLwtcdi2! hermes < $BACKUPS/mnt/hermesbackups/dbbkup/hermes.sql
/usr/bin/mysql -u root -pLwtcdi2! djigzo < $BACKUPS/mnt/hermesbackups/dbbkup/djigzo.sql
/usr/bin/mysql -u root -pLwtcdi2! Syslog < $BACKUPS/mnt/hermesbackups/dbbkup/syslog.sql


#ADJUST PERMISSIONS
/bin/chown amavis:amavis /etc/postfix/relay_domains
/bin/chown -R amavis:amavis /mnt/data/amavis
/bin/chown -R amavis:amavis /opt/hermes/sa-bayes

#REMOVE SCHEDULED TASK AND TEMPORARY RESTORE TASK
/usr/bin/curl --data "trans=$TRANSACTION" http://localhost:8080/schedule/delete_restore_task.cfm

/bin/rm -rf $BACKUPS/$TRANSACTION
/bin/rm -rf $BACKUPS/$TRANSACTION.rar

/usr/bin/sendemail -f FROM -t TO -u "Success `hostname --fqdn` Backup" -m "Success `hostname --fqdn` Restore"  -s localhost

/bin/umount -f -l $BACKUPS

#SET STOPPED STATUS ON RESTORE JOB
/usr/bin/mysql -h localhost -u hermes -plwtcdi2 -e "use hermes; update restore_jobs set status = ''"


#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u hermes -plwtcdi2 -e "use hermes; update backup_jobs set status = ''"

#REBOOT SYSTEM
/sbin/reboot

else

#SET STOPPED STATUS ON RESTORE JOB
/usr/bin/mysql -h localhost -u hermes -plwtcdi2 -e "use hermes; update restore_jobs set status = ''"


#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u hermes -plwtcdi2 -e "use hermes; update backup_jobs set status = ''"

/usr/bin/sendemail -f FROM -t TO -u "Failed `hostname --fqdn` Backup" -m "Failed `hostname --fqdn` Restore. Unable to attach restore share"  -s localhost


fi
