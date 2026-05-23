#!/bin/bash

#Backup Script Flags are as follows:
#-F = The full path to the backup file you wish to restore (Ex: /mnt/backups/hermes-archive-220410-08-11-2024-0822.tar.gz). Ensure it's encased in single quotes ('').
#-M = The Restore Mode you wish to perform. Should be either 'system' or 'archive'.
#-R = The MySQL root password. Ensure you supply it regardless if you are restoring 'system' or 'archive' backup file types. Ensure it's encased in single quotes ('').

#Example Command to run Hermes SEG Restore. Substitute flags with actual data for your Hermes SEG Environment. The system_restore.sh script is located in /opt/hermes/scripts and it should NOT be moved or copied anywhere else.
#/opt/hermes/scripts/system_restore.sh -F '/mnt/backups/hermes-system-220410-08-11-2024-0822.tar.gz' -M 'system' -R 'Somepassword'

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root. Exiting..."
      exit 1
   fi

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`


while getopts F:M:R: flag
do
    case "${flag}" in
        F) BACKUP_FILE=${OPTARG};;
        M) RESTORE=${OPTARG};;
        R) MYSQLROOT=${OPTARG};;
    esac
done

export BACKUP_FILE
export RESTORE
export MYSQLROOT

#Ensure Flags are passed in command
if [ -z ${BACKUP_FILE+x} ]; then
echo "${RED}Backup File Flag (-F) is required. Exiting...${RESET}"

exit 1

fi


if [ -z ${MYSQLROOT+x} ]; then
echo "${RED}MYSQL Root Password Flag (-R) is required. Exiting...${RESET}"
exit 1

fi

if [ -z ${RESTORE+x} ]; then
echo "${RED}The Restore Mode Flag (-M) is required. Exiting...${RESET}"
exit 1

fi


if [ "$RESTORE" = "system" ] || [ "$RESTORE" = "archive" ]
then
echo ""
else
echo "${RED}The Restore Mode Flag (-M) must be 'system' or 'archive'. Exiting...${RESET}"
exit 1
fi


if [ "$RESTORE" = "archive" ]
then
if [ ! -d "/mnt/data" ]; then
      echo "${RED}Restore mode set to $RESTORE but /mnt/data does not exist. Exiting...${RESET}"
      exit 1

fi

#CHECK IF $BACKUP_FILE EXISTS
if [ ! -f "$BACKUP_FILE" ]; then
      echo "${RED}Backup File does not exist. Exiting...${RESET}"
      exit 1

fi

fi

if [ "$RESTORE" = "system" ] && [[ $BACKUP_FILE == *"archive"* ]]; then
  echo "${RED}You specified 'system' Restore Mode however you specified an 'archive' type of backup file to restore. Exiting...${RESET}"
  exit 1
fi


if [ "$RESTORE" = "archive" ] && [[ $BACKUP_FILE == *"system"* ]]; then
echo "${RED}You specified 'archive' Restore Mode however you specified a 'system' type of backup file to restore. Exiting...${RESET}"
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



if [ "$RESTORE" = "system" ]

then 

goto "system"

else

goto "archive"

fi


: system

TIMESTAMP=`date +%m-%d-%Y-%H%M`

echo "The Restore Mode is $RESTORE"


echo "Starting Restore and logging to /tmp/hermes-$RESTORE-$TIMESTAMP.log"
sleep 2


echo "[`date +%m/%d/%Y-%H:%M`] [INFO] RESTORING SYSTEM BACKUP" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING SYSTEM BACKUP"

#PERFORM THE RESTORE
cd /
tar -xvzf $BACKUP_FILE >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING SYSTEM BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING SYSTEM BACKUP" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING SYSTEM BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING SYSTEM BACKUP" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] [INFO] RESTORING HERMES DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING HERMES DATABASE"

mysql -u root -p$MYSQLROOT hermes < hermes.sql >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING HERMES DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING HERMES DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING HERMES DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING HERMES DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi


echo "[`date +%m/%d/%Y-%H:%M`] [INFO]  RESTORING CIPHERMAIL DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING CIPHERMAIL DATABASE"

mysql -u root -p$MYSQLROOT djigzo < djigzo.sql >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING CIPHERMAIL DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING CIPHERMAIL DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING CIPHERMAIL DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING CIPHERMAIL DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] [INFO] RESTORING DMARC DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING DMARC DATABASE"

mysql -u root -p$MYSQLROOT opendmarc < opendmarc.sql >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING DMARC DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING DMARC DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING DMARC DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING DMARC DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] [INFO] RESTORING SYSLOG DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING SYSLOG DATABASE"

mysql -u root -p$MYSQLROOT Syslog < Syslog.sql >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING SYSLOG DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING SYSLOG DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING SYSLOG DATABASE{RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING SYSLOG DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] [INFO] RESTORING MYSQL DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING MYSQL DATABASE"

mysql -u root -p$MYSQLROOT mysql < mysql.sql >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING MYSQL DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING MYSQL DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING MYSQL DATABASE${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING MYSQL DATABASE" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[INFO] SETTING PERMISSIONS"
echo "[`date +%m/%d/%Y-%H:%M`] SETTING PERMISSIONS" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

#ADJUST PERMISSIONS
chown amavis:amavis /etc/postfix/relay_domains && \
chown -R amavis:amavis /mnt/data/amavis && \
chown -R amavis:amavis /opt/hermes/sa-bayes && \
chmod -R go-rwx /opt/hermes/.gnupg/ && \
chmod +x /opt/hermes/scripts/* && \
chmod +x /opt/hermes/templates/*.sh && \
dos2unix /opt/hermes/scripts/* && \
dos2unix /opt/hermes/templates/*.sh && \
chown -R opendkim /opt/hermes/dkim/ && \
chown -R opendkim:opendkim /opt/hermes/dkim/keys/ && \
chown -R opendmarc:opendmarc /var/run/opendmarc/ >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR SETTING PERMISSIONS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR SETTING PERMISSIONS" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] SETTING PERMISSIONS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] SETTING PERMISSIONS" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[INFO] DELETING TEMP FILES"
echo "[`date +%m/%d/%Y-%H:%M`] DELETING TEMP FILES" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

#REMOVE TEMP FILES
rm /Syslog.sql && \
rm /djigzo.sql && \
rm /hermes.sql && \
rm /mysql.sql && \
rm /opendmarc.sql >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR DELETING TEMP FILES${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR DELETING TEMP FILES" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] DELETING TEMP FILES${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] DELETING TEMP FILES" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORE COMPLETE. PLEASE REBOOT YOUR COMPUTER" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
echo "${GREEN}[SUCCESS] RESTORE COMPLETED. PLEASE REBOOT YOUR COMPUTER${RESET}"
fi


: archive

TIMESTAMP=`date +%m-%d-%Y-%H%M`

echo "The Restore Mode is $RESTORE"


echo "Starting Restore and logging to /tmp/hermes-$RESTORE-$TIMESTAMP.log"
sleep 2

echo "[`date +%m/%d/%Y-%H:%M`] [INFO] RESTORING ARCHIVE BACKUP" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

echo "[INFO] RESTORING ARCHIVE BACKUP"

#PERFORM THE RESTORE
cd /
tar -xvzf $BACKUP_FILE >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR RESTORING ARCHIVE BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR RESTORING ARCHIVE BACKUP" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] RESTORING ARCHIVE BACKUP${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORING ARCHIVE BACKUP" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
fi

echo "[INFO] SETTING PERMISSIONS"
echo "[`date +%m/%d/%Y-%H:%M`] SETTING PERMISSIONS" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log

#ADJUST PERMISSIONS

chown -R amavis:amavis /mnt/data/amavis/ >> /tmp/hermes-$RESTORE-$TIMESTAMP.log 2>&1

ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR SETTING PERMISSIONS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [ERROR] $ERR SETTING PERMISSIONS" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[SUCCESS] SETTING PERMISSIONS${RESET}"
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] SETTING PERMISSIONS" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
echo "[`date +%m/%d/%Y-%H:%M`] [SUCCESS] RESTORE COMPLETE. PLEASE REBOOT YOUR COMPUTER" >> /tmp/hermes-$RESTORE-$TIMESTAMP.log
echo "${GREEN}[SUCCESS] RESTORE COMPLETED. PLEASE REBOOT YOUR COMPUTER${RESET}"

fi


