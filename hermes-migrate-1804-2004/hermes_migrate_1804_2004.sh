#!/bin/bash

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root, Exiting..."
      exit 1
   fi

#Ensure Ubuntu 20.04
string=`lsb_release -d`
if [[ $string == *"Ubuntu 18.04"* ]]; then
      echo "You must be running Ubuntu 20.04 before running this script, Exiting..."
      exit 1
fi

#Set the script path
SCRIPTPATH=$(pwd)

#Set install_log Date/Time Stamp
TIMESTAMP=`date +%m-%d-%Y-%H%M`


#Set Tomcat Version
TOMCATVERSION="tomcat9"
TOMCATUSER="tomcat"


echo "Installing Boxes Prerequisite if necessary"
#Install boxes
apt-get install boxes -y > /dev/null 2>&1

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}Error $THEERROR, occurred Installing Boxes Prerequisite ${RESET}"
exit 1
else
echo "${GREEN}Completed Installing Boxes Prerequisite ${RESET}"
fi

echo "Installing Spinner Prerequisite if necessary"
#Install spinner
apt-get install spinner -y  > /dev/null 2>&1

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}Error $THEERROR, occurred Installing Spinner Prerequisite ${RESET}"
exit 1
else
echo "${GREEN}Completed Installing Spinner Prerequisite ${RESET}"
fi

PS3='This script will attempt to install various packages and migrate various settings for a Hermes SEG installation that was successfully upgraded from Ubuntu 18.04 to Ubuntu 20.04 using the do-release-upgrade command. Ensure that you have a fresh and valid backup of your machine before proceeding. This script is offered with absolutely no warrranty or guarantee of any kind. We cannot be held liable for any damage that may occur to your system. Do you agree with the terms of this script?: '

options=("Yes - I agree" "No - I do not agree")
select opt in "${options[@]}"
do
    case $opt in
        "Yes - I agree")

            echo "${GREEN}Starting package installation and settings migration${RESET}" | boxes -d stone -p a2v1
            echo "During installation a ${RED}$SCRIPTPATH/install_log-$TIMESTAMP.log${RESET} log file will be created. It's highly recommended that you open a separate shell window and tail that file in order to view progress of the installation and/or any errors that may occur."

            echo "[`date +%m/%d/%Y-%H:%M`] Starting package installation and settings migration." >> $SCRIPTPATH/install_log-$TIMESTAMP.log
          break
            ;;
        "No - I do not agree")

            echo "Exiting ... ";
            exit
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done


echo "[`date +%m/%d/%Y-%H:%M`] Installing Apache Tomcat" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Apache Tomcat...'
sleep 1

#Install Tomcat
apt-get install $TOMCATVERSION -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Apache Tomcat for Ciphermail...'
sleep 1

#Configure Apache Tomcat for ciphermail
wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/hermes-migrate-1804-2004/$TOMCATVERSION -P /etc/default/$TOMCATVERSION
wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/hermes-migrate-1804-2004/ciphermail.xml -P /etc/$TOMCATVERSION/Catalina/localhost/ciphermail.xml
wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/hermes-migrate-1804-2004/web.xml -P /etc/$TOMCATVERSION/Catalina/localhost/web.xml
wget https://raw.githubusercontent.com/deeztek/Hermes-Secure-Email-Gateway/master/hermes-migrate-1804-2004/server.xml -P /etc/$TOMCATVERSION/server.xml
chown $TOMCATUSER:djigzo /usr/share/djigzo-web/ssl/sslCertificate.p12
systemctl restart $TOMCATVERSION

stop_spinner $?
