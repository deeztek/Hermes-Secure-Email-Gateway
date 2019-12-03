#!/bin/bash

#ATTEMPT TO UMOUNT BUSY CIFS SHARE
/bin/umount.cifs -f -l /mnt/hermesbackups

#MOUNT BACKUPS SHARE
/bin/mount '//SERVER/SHARE/DIRECTORY' -t cifs -o uid=1000,gid=1000,username='USERNAME',domain='DOMAIN',password='PASSWORD' /mnt/hermesbackups/


JID="JOB-ID"
BACKUPS="/mnt/hermesbackups"
MYSQLUSER="MYSQL-USER"
MYSQLPASS="MYSQL-PASS"
FILENAME="hermes_sys_enc"

#CHECK IF MOUNT EXISTS
if mount | grep $BACKUPS; then

#SET RUNNING STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = 'running' where id = '$JID'"

# DELETE FILES OLDER THAN 6 DAYS
/usr/bin/find $BACKUPS/*.backup -mtime +RETENTION -exec rm {} \;
/usr/bin/find $BACKUPS/*.rar -mtime +RETENTION -exec rm {} \;
/usr/bin/find $BACKUPS/*.7z -mtime +RETENTION -exec rm {} \;
/usr/bin/find $BACKUPS/*.log -mtime +RETENTION -exec rm {} \;

TIMESTAMP=`date +%m-%d-%Y-%H%M`

/bin/mkdir $BACKUPS/dbbkup

#BACKUP MYSQL DATABASES
#BACKUP MYSQL DATABASES
/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt hermes>$BACKUPS/dbbkup/hermes.sql >> $BACKUPS/$FILENAME_$TIMESTAMP.log

/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt Syslog>$BACKUPS/dbbkup/syslog.sql >> $BACKUPS/$FILENAME_$TIMESTAMP.log

/usr/bin/mysqldump --user=$MYSQLUSER --password=$MYSQLPASS --create-options --opt djigzo>$BACKUPS/dbbkup/djigzo.sql >> $BACKUPS/$FILENAME_$TIMESTAMP.log

#PERFORM THE BACKUP

#/usr/bin/rar a $BACKUPS/hermes_sys_enc_$TIMESTAMP.rar /etc/network/interfaces /etc/resolv.conf /etc/postfix /etc/amavis /etc/spamassassin /etc/hostname /etc/hosts /etc/mailname /etc/apache2/sites-enabled /etc/apache2/sites-available /opt/hermes /opt/scripts /var/www /usr/share/UUID /usr/share/UUID2 /usr/share/UUID3 /usr/share/djigzo/ADDITIONAL-NOTES.TXT /usr/share/djigzo/DOCS.TXT $BACKUPS/dbbkup/hermes.sql $BACKUPS/dbbkup/syslog.sql $BACKUPS/dbbkup/djigzo.sql

/usr/bin/7z a -t7z -ssc -m0=LZMA2:d64k:fb32 -ms=8m -mmt=8 -mx=1 $BACKUPS/$FILENAME_$TIMESTAMP.7z /etc/postfix/main.cf /etc/postfix/networks /etc/postfix/networks.db /etc/postfix/postscreen_access.cidr /etc/postfix/postscreen_access.cidr.db /etc/postfix/relay_domains /etc/postfix/relay_domains.db /etc/postfix/relay_passwd /etc/postfix/relay_passwd.db /etc/postfix/relay_recipients /etc/postfix/relay_recipients.db /etc/postfix/sender_access /etc/postfix/sender_access.db /etc/postfix/tls_policy /etc/postfix/tls_policy.db /etc/postfix/transport /etc/postfix/transport.db /etc/postfix/virtual /etc/postfix/virtual.db /etc/amavis/mynetworks /etc/amavis/black.list /etc/amavis/white.lst /etc/amavis/conf.d/15-av_scanners /etc/amavis/conf.d/50-user /etc/spamassassin/local.cf /opt/hermes /var/www/schedule /var/www/html/schedule /var/www/WEB-INF/railo/scheduler/scheduler.xml /var/www/html/WEB-INF/lucee/scheduler/scheduler.xml $BACKUPS/dbbkup/hermes.sql $BACKUPS/dbbkup/syslog.sql $BACKUPS/dbbkup/djigzo.sql  >> $BACKUPS/$FILENAME_$TIMESTAMP.log

/bin/rm -rf $BACKUPS/dbbkup

/usr/bin/openssl aes-256-cbc -pass pass:UIeocFdAeq3k/ewFUS/k2Ol+EEsRlNMHz21WWabsZXE= -a -salt -in $BACKUPS/$FILENAME_$TIMESTAMP.7z -out $BACKUPS/$FILENAME_$TIMESTAMP.backup

#DECRYPT COMMAND NOT USED
#openssl aes-256-cbc -d -a -pass pass:UIeocFdAeq3k/ewFUS/k2Ol+EEsRlNMHz21WWabsZXE= -in /mnt/hermesbackups/hermes_01-29-2014.backup -out /mnt/hermesbackups/hermes_`date +%m-%d-%Y`.tgz

/bin/rm -rf $BACKUPS/$FILENAME_$TIMESTAMP.7z

/usr/bin/sendemail -f FROM -t TO -u "Success `hostname --fqdn` Backup" -m "Success `hostname --fqdn` Backup"  -s localhost

/bin/umount -f -l /mnt/hermesbackups

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = '' where id = '$JID'"


else

#SET STOPPED STATUS ON BACKUP JOB
/usr/bin/mysql -h localhost -u $MYSQLUSER -p$MYSQLPASS -e "use hermes; update backup_jobs set status = '' where id = '$JID'"

/usr/bin/sendemail -f FROM -t TO -u "Failed `hostname --fqdn` Backup" -m "Failed `hostname --fqdn` Backup. Unable to attach backup share"  -s localhost


fi
