#!/bin/bash

#This patch will fix the mising queue_type column in the postfix_queue table when attempting to access System --> Mail Queue on fresh Hermes SEG 18.04 Build: 220410 install.

#Download script patch from https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/master/patches/fb7d8e3_issue_29.sh

#Install script patch by running the following command in a command prompt as root:
#bash fb7d8e3_issue_29.sh

HERMES_SQL_USERNAME=`cat /opt/hermes/creds/hermes_username`
HERMES_SQL_PASSWORD=`cat /opt/hermes/creds/hermes_password`

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root, Exiting..."
      exit 1
   fi

#Set the script path
SCRIPTPATH=$(pwd)

#Set install_log Date/Time Stamp
TIMESTAMP=`date +%m-%d-%Y-%H%M`

echo "[`date +%m/%d/%Y-%H:%M`] Fixing postfix_queue table"

#FIX POSTFIX_QUEUE TABLE
/usr/bin/mysql -h localhost -u $HERMES_SQL_USERNAME -p$HERMES_SQL_PASSWORD -e "use hermes; DROP TABLE IF EXISTS postfix_queue; CREATE TABLE postfix_queue (id int(11) NOT NULL AUTO_INCREMENT, trans_id varchar(255) DEFAULT NULL, msg_id varchar(255) DEFAULT NULL, queue_type varchar(255) DEFAULT NULL, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=latin1;"

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] Failure $ERR occurred during Fixing postfix_queue table"
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] Success Fixing postfix_queue table"
fi

echo "Finished Patch Installation."
