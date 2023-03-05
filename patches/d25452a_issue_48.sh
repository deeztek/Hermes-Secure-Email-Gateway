#!/bin/bash

#This patch will fix issue #48 at https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/48

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root, Exiting..."
      exit 1
   fi

#Set the script path
SCRIPTPATH=$(pwd)

#Set install_log Date/Time Stamp
TIMESTAMP=`date +%m-%d-%Y-%H%M`

echo "Installing new version of files"

echo "[`date +%m/%d/%Y-%H:%M`] Installing new version of files" 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log

rm /var/www/html/admin/2/view_message_history.cfm 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log

rm /var/www/html/admin/2/inc/messages_block_sender.cfm 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log

rm /var/www/html/admin/2/inc/messages_allow_sender.cfm 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log

wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/dirstructure/var/www/html/admin/2/view_message_history.cfm -P /var/www/html/admin/2/ 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log

wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/dirstructure/var/www/html/admin/2/inc/messages_allow_sender.cfm -P /var/www/html/admin/2/inc/ 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log


wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/dirstructure/var/www/html/admin/2/inc/messages_block_sender.cfm -P /var/www/html/admin/2/inc/ 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "Failure $ERR occurred during Installing new version of files"
echo "[`date +%m/%d/%Y-%H:%M`] Failure $ERR occurred during Installing new version of files" 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log
exit 1
else
echo "Success Installing new version of files"
echo "[`date +%m/%d/%Y-%H:%M`] Success Installing new version of files" 2>> $SCRIPTPATH/d25452a_issue_48_patch_install_log-$TIMESTAMP.log
fi

echo "Finished Issue #48 Patch Installation."
