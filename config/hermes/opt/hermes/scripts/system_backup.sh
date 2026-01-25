#!/bin/bash

#Backup Script Flags are as follows:
#-D = Number of Days Backups should be retained
#-P = The path to create the backups. Must be already mounted and available. Ensure it's encased in single quotes ('').
#-E = Email Addres to receive backups success and failure notifications. Ensure it's encased in single quotes ('').
#-F = Email Addres to send backups success and failure notifications from. Ensure it's encased in single quotes ('').
#-B = Backup Mode. Should be either 'system', 'archive' or 'all'. 'system' backups everything BUT the e-mail archive, 'archive' ONLY backups the e-mail archive and 'all' backups up everything including the e-mail archive.
#-R = The MySQL root password. Ensure it's encased in single quotes ('').

#Example Command to run Hermes SEG Backups. Substitute flags with actual data for your Hermes SEG Environment. The system_backup.sh script is located in /opt/hermes/scripts and it should NOT be moved or copied anywhere else.
#/opt/hermes/scripts/system_backup.sh -D '7' -P '/mnt/backups' -E 'to@domain.tld' -F 'from@domain.tld' -B 'system' -R 'Somepassword'

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root. Exiting..."
      exit 1
   fi

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`


while getopts D:P:E:F:B:R: flag
do
    case "${flag}" in
        D) RETENTION=${OPTARG};;
        P) BACKUP_PATH=${OPTARG};;
        E) EMAIL_TO=${OPTARG};;
	F) EMAIL_FROM=${OPTARG};;
        B) BACKUP=${OPTARG};;
        R) MYSQLROOT=${OPTARG};;
    esac
done

export RETENTION
export BACKUP_PATH
export EMAIL_TO
export EMAIL_FROM
export BACKUP
export MYSQLROOT

#Ensure Flags are passed in command
if [ -z ${RETENTION+x} ]; then
echo "${RED}Retention Flag (-D) is required. Exiting...${RESET}"

exit 1

fi

if [ -z ${BACKUP_PATH+x} ]; then
echo "${RED}Backup Path Flag (-P) is required. Exiting...${RESET}"

exit 1

fi

if [ -z ${EMAIL_TO+x} ]; then
echo "${RED}Email To Flag (-E) is required. Exiting...${RESET}"

exit 1

fi

if [ -z ${EMAIL_FROM+x} ]; then
echo "${RED}Email From Flag (-F) is required. Exiting...${RESET}"

exit 1

fi


if [ -z ${MYSQLROOT+x} ]; then
echo "${RED}MYSQL Root Password Flag (-R) is required. Exiting...${RESET}"
exit 1

fi


if [ "$BACKUP" = "system" ] || [ "$BACKUP" = "archive" ] || [ "$BACKUP" = "all" ]
then
echo ""
else
echo "${RED}What to Backup Flag (-B) must be system, archive or all. Exiting...${RESET}"
exit 1
fi


re='^[0-9]+$'
if ! [[ $RETENTION =~ $re ]] ; then
echo "${RED}The Retention Flag (-D) must be a number 0-9. Exiting...${RESET}"
exit 1
fi

if [ "$BACKUP" = "archive" ] || [ "$BACKUP" = "all" ]
then
if [ ! -d "/mnt/data" ]; then
      echo "${RED}Backup mode set to $BACKUP but /mnt/data does not exist. Exiting...${RESET}"
      exit 1

fi
fi

#CHECK IF $BACKUP_PATH EXISTS
if [ ! -d "$BACKUP_PATH" ]; then
      echo "${RED}Backup Path does not exist. Exiting...${RESET}"
      exit 1

fi



#GET DATABASE CREDENIALS
HERMES_DB_USERNAME=`cat /opt/hermes/creds/hermes_username`
HERMES_DB_PASSWORD=`cat /opt/hermes/creds/hermes_password`


#GET HERMES BUILD_NO TO BE USED AS BUILD_NO
BUILD_NO=$(mysql -h 127.0.0.1 -u $HERMES_DB_USERNAME -p$HERMES_DB_PASSWORD hermes -se "SELECT value from system_settings where parameter='build_no'")

if [[ -z "$BUILD_NO" ]]; then
      echo "${RED}The Hermes Build Number variable is empty. Exiting...${RESET}"
      /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "The Hermes Build Number variable is empty."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
      exit 1

fi


# BAT / CMD goto function
function goto
{
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 |
          grep -v ':$')
    eval "$cmd"
    exit
}


TIMESTAMP=`date +%m-%d-%Y-%H%M`

echo "The Backup Mode is $BACKUP"


echo "Starting Backup"
sleep 2


if [ "$BACKUP" = "system" ] || [ "$BACKUP" = "all" ]

then 

goto "system"

else

goto "archive"

fi


: system


#CREATE DATABASE TEMP BACKUP DIRECTORY
/bin/mkdir -p $BACKUP_PATH/dbbkup

#Check if $BACKUP/dbbackup exists and if not exit
if [ ! -d "$BACKUP_PATH/dbbkup" ]; then
      echo "${RED}Unable to create /$BACKUP_PATH/dbbkup directory. Exiting...${RESET}"
      exit 1

fi

echo "[`date +%m/%d/%Y-%H:%M`] [INFO] CREATING HERMES DATABASE BACKUP" > $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

echo "[INFO] CREATING HERMES DATABASE BACKUP..."

#PERFORM HERMES DATABASE BACKUP
databases=`mysql -u root -p$MYSQLROOT -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]] ; then
        echo "[`date +%m/%d/%Y-%H:%M`] [INFO] DUMPING DATABASE: $db" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        mysqldump -u root -p$MYSQLROOT --opt --databases $db>$BACKUP_PATH/dbbkup/$db.sql

fi

done

ERR=$?
if [ $ERR != 0 ]; then

echo "${RED}[ERROR] $ERR CREATING HERMES DATABASE BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR CREATING HERMES DATABASE BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR CREATING HERMES DATABASE BACKUP. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
exit 1
else
echo "${GREEN}[SUCCESS] CREATING HERMES DATABASE BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] CREATING HERMES DATABASE BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
fi


echo "[INFO] VERIFYING DATABASE BACKUPS"
echo "[`date +%m/%d/%Y-%H:%M`] [INFO] VERIFYING DATABASE BACKUPS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

if [ -s $BACKUP_PATH/dbbkup/djigzo.sql ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] CIPHERMAIL DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] CIPHERMAIL DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR CIPHERMAIL DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR CIPHERMAIL DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
	/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR CIPHERMAIL DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi


if [ -s $BACKUP_PATH/dbbkup/hermes.sql ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] HERMES DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] HERMES DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR HERMES DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR HERMES DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR HERMES DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY"  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi

if [ -s $BACKUP_PATH/dbbkup/mysql.sql ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] MYSQL DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] MYSQL DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR MYSQL DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR MYSQL DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR MYSQL DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi

if [ -s $BACKUP_PATH/dbbkup/opendmarc.sql ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] DMARC DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] DMARC DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR DMARC DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR DMARC DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR DMARC DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY"  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi

if [ -s $BACKUP_PATH/dbbkup/Syslog.sql ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] SYSLOG DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] SYSLOG DATABASE BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR SYSLOG DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR SYSLOG DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR SYSLOG DATABASE BACKUP FILE DOES NOT EXIST OR IS EMPTY. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi



echo "[`date +%m/%d/%Y-%H:%M`] [INFO] CREATING HERMES SYSTEM BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

echo "[INFO] CREATING HERMES SYSTEM BACKUP..."

#PERFORM SYSTEM BACKUP
tar -cvzf $BACKUP_PATH/hermes-system-$BUILD_NO-$TIMESTAMP.tar.gz /opt/hermes /etc/postfix /etc/amavis /etc/nginx /etc/authelia /etc/clamav /etc/rsyslog.d /etc/spamassassin /var/lib/clamav /etc/postfix-policyd-spf-python /etc/opendkim.conf /etc/opendmarc /etc/letsencrypt /etc/hosts /etc/netplan /var/www/html /usr/share/djigzo/conf/database/hibernate.mysql.connection.xml /etc/cron.d /etc/mailname /etc/hostname -C $BACKUP_PATH/dbbkup . >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1


ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR  CREATING HERMES SYSTEM BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR  CREATING HERMES SYSTEM BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR  CREATING HERMES SYSTEM BACKUP"  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
exit 1
else
echo "${GREEN}[SUCCESS] CREATING HERMES SYSTEM BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] CREATING HERMES SYSTEM BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
fi

echo "[INFO] CHECKING IF SYSTEM BACKUP FILE EXISTS AND IS NOT EMPTY..."

if [ -s $BACKUP_PATH/hermes-system-$BUILD_NO-$TIMESTAMP.tar.gz ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] SYSTEM BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] SYSTEM BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR SYSTEM BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR SYSTEM BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR SYSTEM BACKUP FILE DOES NOT EXIST OR IS EMPTY. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi



echo "[`date +%m/%d/%Y-%H:%M`] [INFO] CLEANING UP BACKUP TEMP FILES AND DIRECTORIES" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

echo "[INFO] CLEANING UP BACKUP TEMP FILES AND DIRECTORIES..."

/bin/rm -rf $BACKUP_PATH/dbbkup >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1


ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR CLEANING UP BACKUP TEMP FILES AND DIRECTORIES${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR CLEANING UP BACKUP TEMP FILES AND DIRECTORIES" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR CLEANING UP BACKUP TEMP FILES AND DIRECTORIES"  -s 127.0.0.1:10026  >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
exit 1
else
echo "${GREEN}[SUCCESS] CLEANING UP BACKUP TEMP FILES AND DIRECTORIES${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] CLEANING UP BACKUP TEMP FILES AND DIRECTORIES" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
fi

echo "[INFO] DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS" 
echo "[`date +%m/%d/%Y-%H:%M`] [INFO] DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

# DELETE FILES OLDER THAN $RETENTION FLAG
/usr/bin/find $BACKUP_PATH/hermes-system-*.gz -mtime +$RETENTION -exec rm {} \; >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
/usr/bin/find $BACKUP_PATH/*.log -mtime +$RETENTION -exec rm {} \; >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026  >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
exit 1
else
echo "${GREEN}[SUCCESS] DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] DELETING HERMES SYSTEM BACKUPS OLDER THAN $RETENTION DAYS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
fi



if [ "$BACKUP" = "all" ]

then

goto "archive"

else

goto "end"

fi

: archive


echo "[`date +%m/%d/%Y-%H:%M`] [INFO] CREATING HERMES ARCHIVE BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

echo "[INFO] CREATING HERMES ARCHIVE BACKUP"

#PERFORM ARCHIVE BACKUP.
tar -cvzf $BACKUP_PATH/hermes-archive-$BUILD_NO-$TIMESTAMP.tar.gz /mnt/data/amavis >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

ERR=$?
echo "[ERROR] $ERR CREATING HERMES ARCHIVE BACKUP"
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR CREATING HERMES ARCHIVE BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR CREATING HERMES ARCHIVE BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR CREATING HERMES ARCHIVE BACKUP"  -s 127.0.0.1:10026  >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
exit 1
else
echo "${GREEN}[SUCCESS] CREATING HERMES ARCHIVE BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] CREATING HERMES ARCHIVE BACKUP" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
fi

echo "[INFO] CHECKING IF ARCHIVE BACKUP FILE EXISTS AND IS NOT EMPTY..."

if [ -s $BACKUP_PATH/hermes-archive-$BUILD_NO-$TIMESTAMP.tar.gz ]; then
        # The file is not-empty.
        echo "${GREEN}[SUCCESS] ARCHIVE BACKUP FILE EXISTS AND IS NOT EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] ARCHIVE BACKUP FILE EXISTS AND IS NOT EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

else
        # The file is empty.
        echo "${RED}[ERROR] $ERR ARCHIVE BACKUP FILE DOES NOT EXIST OR IS EMPTY${RESET}"
        echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR ARCHIVE BACKUP FILE DOES NOT EXIST OR IS EMPTY" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
        /usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR ARCHIVE BACKUP FILE DOES NOT EXIST OR IS EMPTY. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

exit 1
fi


echo "[INFO] DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS"
echo "[`date +%m/%d/%Y-%H:%M`] [INFO] DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

# DELETE FILES OLDER THAN $RETENTION FLAG
/usr/bin/find $BACKUP_PATH/hermes-archive-*.gz -mtime +$RETENTION -exec rm {} \; >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
/usr/bin/find $BACKUP_PATH/*.log -mtime +$RETENTION -exec rm {} \; >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[FAILED] `hostname --fqdn` Backup" -m "ERROR $ERR DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026  >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1
exit 1
else
echo "${GREEN}[SUCCESS] DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] DELETING HERMES ARCHIVE BACKUPS OLDER THAN $RETENTION DAYS" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log
fi



goto "end"

: end

echo "${GREEN}[SUCCESS] BACKUP COMPLETED!${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] BACKUP COMPLETED!" >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log

/usr/bin/sendemail -f $EMAIL_FROM -t $EMAIL_TO -u "[SUCCESS] `hostname --fqdn` Backup" -m "BACKUP SUCCESSFUL. Details can be found in $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log file."  -s 127.0.0.1:10026 >> $BACKUP_PATH/hermes-$BACKUP-$TIMESTAMP.log 2>&1

