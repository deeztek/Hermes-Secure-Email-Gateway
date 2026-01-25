#!/bin/bash

#Remove any existing update directories
/bin/rm -rf /opt/hermes/tmp/CUSTOMTRANS

#Create update directory
/bin/mkdir -p /opt/hermes/tmp/CUSTOMTRANS

#Extract Hermes Update
/bin/tar -xvzf /opt/hermes/updates/UPDATEFILE -C /opt/hermes/tmp/CUSTOMTRANS

#Make update script executable
/bin/chmod +x /opt/hermes/tmp/CUSTOMTRANS/install.sh

#Inject CUSTOMTRANS in install.sh directory
sed -i -e "s|THETRANS|CUSTOMTRANS|g" "/opt/hermes/tmp/CUSTOMTRANS/install.sh"

#Run Hermes Update script
/opt/hermes/tmp/CUSTOMTRANS/install.sh

