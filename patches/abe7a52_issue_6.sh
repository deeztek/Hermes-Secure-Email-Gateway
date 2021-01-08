#!/bin/bash

#This patch will fix failed opendmarc installation on fresh Hermes SEG 18.04 Build: 200125 install.

#Install patch by running the following command in a command prompt as root:
#bash abe7a52_issue_6.sh

#This patch will most likely generate an error during Opendmarc configuration. This is expected behavior with Ubuntu 18.04 and Opendmarc should work normally after a reboot. 

#Reboot and verify opendmarc is running by issuing the following command: 
#systemctl status opendmarc
#If you don't see a active (running) status submit an issue at: https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues and attach the abe7a52_issue_6_patch_install_log-$TIMESTAMP.log this patch generated.

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root, Exiting..."
      exit 1
   fi

#Set the script path
SCRIPTPATH=$(pwd)

#Set install_log Date/Time Stamp
TIMESTAMP=`date +%m-%d-%Y-%H%M`

/bin/cp /etc/apt/sources.list /etc/apt/sources.list.ORIGINAL && \
/bin/echo "deb http://mirrors.kernel.org/ubuntu focal main universe" | sudo tee -a /etc/apt/sources.list && \
/usr/bin/apt update && /usr/bin/apt install opendmarc -y && \
/bin/cp /etc/apt/sources.list.ORIGINAL /etc/apt/sources.list && \
/usr/bin/apt update && \
/bin/cp /etc/opendmarc.conf /etc/opendmarc.ORIGINAL && \
/usr/bin/wget https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/master/download/opendmarc/opendmarc.conf $SCRIPTPATH && \
/bin/cp $SCRIPTPATH/opendmarc.conf /etc/opendmarc.conf && \
/bin/systemctl restart opendmarc && \
/bin/chown -R opendmarc:opendmarc /var/run/opendmarc/ 2>> $SCRIPTPATH/abe7a52_issue_6_patch_install_log-$TIMESTAMP.log

echo "Finished Patch Installation. An error most likely occurred during Opendmarc configuration. This is expected behavior with Ubuntu 18.04 and Opendmarc should work normally after a reboot."



