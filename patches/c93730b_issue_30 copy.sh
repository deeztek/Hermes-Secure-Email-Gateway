#!/bin/bash

#This patch will download the new get_system_root_filesystem_usage.cfm to your system in order to fix issue #30 at https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/30

#Updated 11/11/2022 to reflect new method of getting data usage as well as including the /mnt/data usage in addition to the / usage.


#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root, Exiting..."
      exit 1
   fi

#Set install_log Date/Time Stamp
TIMESTAMP=`date +%m-%d-%Y-%H%M`

echo "[`date +%m/%d/%Y-%H:%M`] Installing new version of get_system_root_filesystem_usage.cfm"

rm /var/www/html/admin/2/inc/get_system_root_filesystem_usage.cfm

rm /var/www/html/admin/2/inc/get_system_root_filesystem_usage.cfm.*

rm -rf /var/www/html/admin/2/inc/get_system_root_filesystem_usage.cfm/

wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/dirstructure/var/www/html/admin/2/inc/get_system_root_filesystem_usage.cfm -P /var/www/html/admin/2/inc/

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] Failure $ERR occurred during Installing new version of get_system_root_filesystem_usage.cfm"
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] Success Installing new version of get_system_root_filesystem_usage.cfm"
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing new version of get_system_data_filesystem_usage.cfm"

rm /var/www/html/admin/2/inc/get_system_data_filesystem_usage.cfm

rm /var/www/html/admin/2/inc/get_system_data_filesystem_usage.cfm.*

rm -rf /var/www/html/admin/2/inc/get_system_data_filesystem_usage.cfm/

wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/dirstructure/var/www/html/admin/2/inc/get_system_data_filesystem_usage.cfm -P /var/www/html/admin/2/inc/

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] Failure $ERR occurred during Installing new version of get_system_dat_filesystem_usage.cfm"
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] Success Installing new version of get_system_data_filesystem_usage.cfm"
fi

echo "Finished Issue #30 Patch Installation."
