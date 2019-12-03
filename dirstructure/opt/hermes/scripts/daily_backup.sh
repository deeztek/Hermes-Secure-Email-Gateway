#!/bin/bash

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/sbin/umount.cifs -f -l /mnt/backups

#MOUNT BACKUPS SHARE
#/sbin/mount.cifs //server/share /mnt/backups -o username=DOMAIN/username,password=password

#MOUNT BACKUPS SHARE
/sbin/mount.cifs //SERVER-NAME/SHARE-NAME /mnt/backups -o username=USER-NAME,password=PASS-WORD


BACKUPS="/mnt/backups"

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then

# DELETE FILES OLDER THAN 6 DAYS
/usr/bin/find $BACKUPS -mtime +6 -exec rm {} \;

#PERFORM THE BACKUP
/bin/tar cvpzf $BACKUPS/hermes_`date +%m-%d-%Y`.tgz --exclude=/proc --exclude=/lost+found --exclude=/backup.tar.bz2 --exclude=/mnt --exclude=/sys / >> $BACKUPS/hermes_`date +%m-%d-%Y`_backup.log

#BACKUP MYSQL DATABASES
/usr/bin/mysqldump --user=root --password=Lwtcdi2! --opt hermes>$BACKUPS/`date +%m-%d-%Y-%H%M`-hermes.sql

#BACKUP POSTGRES DATABASES
/bin/su - postgres
/usr/bin/pg_dump djigzo > $BACKUPS/`date +%m-%d-%Y-%H%M`-djigzo.sql

#SEND EMAIL CONFIRMATION
#/usr/bin/sendemail -f hermes@domain.tld -t to_someone@domain.tld -u "Success Hermes Backup" -m "Success Hermes Backup"  -s localhost

#SEND EMAIL CONFIRMATION
/usr/bin/sendemail -f FROM -t TO -u "Success HOST-NAME Backup" -m "Success HOST-NAME Backup"  -s localhost


#UNMOUNT BACKUP DIRECTORY ON BACKUP.MYDIRECTMAIL.LOCAL
/sbin/umount.cifs -f -l /mnt/backups

else

#SEND EMAIL MOUNT ERROR
#/usr/bin/sendemail -f hermes@domain.tld -t to_someone@domain.tld -u "Failure Hermes Backups" -m "Unable to mount backups share for Hermes Backup"  -s localhost

#SEND EMAIL MOUNT ERROR
/usr/bin/sendemail -f FROM -t TO -u "Failure HOST-NAME Backup" -m "Unable to mount backups share for HOST-NAME Backup"  -s localhost


fi
