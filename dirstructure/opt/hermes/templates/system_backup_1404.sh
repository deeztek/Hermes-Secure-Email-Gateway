#!/bin/bash

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/sbin/umount.cifs -f -l /mnt/hermesbackups

#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,username='USERNAME',domain='DOMAIN',password='PASSWORD' /mnt/hermesbackups/

JID="JOB-ID"
BACKUPS="/mnt/hermesbackups"

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then

#SET RUNNING STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u hermes -plwtcdi2 -e "use hermes; update backup_jobs set status = 'running' where id = '$JID'"

# DELETE FILES OLDER THAN 6 DAYS
/usr/bin/find $BACKUPS/*.backup -mtime +RETENTION -exec rm {} \;
/usr/bin/find $BACKUPS/*.rar -mtime +RETENTION -exec rm {} \;

TIMESTAMP=`date +%m-%d-%Y-%H%M`

/bin/mkdir $BACKUPS/dbbkup

#BACKUP MYSQL DATABASES
/usr/bin/mysqldump --user=root --password=Lwtcdi2! --create-options --opt hermes>$BACKUPS/dbbkup/hermes.sql

/usr/bin/mysqldump --user=root --password=Lwtcdi2! --create-options --opt Syslog>$BACKUPS/dbbkup/syslog.sql

/usr/bin/mysqldump --user=root --password=Lwtcdi2! --create-options --opt djigzo>$BACKUPS/dbbkup/djigzo.sql


#PERFORM THE BACKUP

#/bin/tar cvpzf $BACKUPS/hermes_$TIMESTAMP.gz /opt/hermes /opt/railo /opt/scripts /var/www /usr/share/UUID /usr/share/UUID2 /usr/share/UUID3 /usr/share/djigzo/ADDITIONAL-NOTES.TXT /usr/share/djigzo/DOCS.TXT $BACKUPS/*.sql

/usr/bin/rar a $BACKUPS/hermes_sys_$TIMESTAMP.rar /etc/network/interfaces /etc/resolv.conf /etc/postfix /etc/amavis /etc/spamassassin /etc/hostname /etc/hosts /etc/mailname /etc/apache2/sites-enabled /etc/apache2/sites-available /opt/hermes /opt/scripts /var/www /usr/share/UUID /usr/share/UUID2 /usr/share/UUID3 /usr/share/djigzo/ADDITIONAL-NOTES.TXT /usr/share/djigzo/DOCS.TXT $BACKUPS/dbbkup/hermes.sql $BACKUPS/dbbkup/syslog.sql $BACKUPS/dbbkup/djigzo.sql

/bin/rm -rf $BACKUPS/dbbkup


#/usr/bin/openssl aes-256-cbc -pass pass:UIeocFdAeq3k/ewFUS/k2Ol+EEsRlNMHz21WWabsZXE= -a -salt -in $BACKUPS/hermes_$TIMESTAMP.gz -out $BACKUPS/hermes_$TIMESTAMP.backup

#DECRYPT COMMAND NOT USED
#openssl aes-256-cbc -d -a -pass pass:UIeocFdAeq3k/ewFUS/k2Ol+EEsRlNMHz21WWabsZXE= -in /mnt/hermesbackups/hermes_01-29-2014.backup -out /mnt/hermesbackups/hermes_`date +%m-%d-%Y`.tgz

#/bin/rm -rf $BACKUPS/hermes_$TIMESTAMP.gz

/usr/bin/sendemail -f FROM -t TO -u "Success `hostname --fqdn` Backup" -m "Success `hostname --fqdn` Backup"  -s localhost

/bin/umount -f -l /mnt/hermesbackups

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u hermes -plwtcdi2 -e "use hermes; update backup_jobs set status = '' where id = '$JID'"


else

/usr/bin/sendemail -f FROM -t TO -u "Failed `hostname --fqdn` Backup" -m "Failed `hostname --fqdn` Backup. Unable to attach backup share"  -s localhost


fi
