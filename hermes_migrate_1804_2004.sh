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

#Set migrate_log Date/Time Stamp
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
            echo "During installation a ${RED}$SCRIPTPATH/migrate_log-$TIMESTAMP.log${RESET} log file will be created. It's highly recommended that you open a separate shell window and tail that file in order to view progress of the installation and/or any errors that may occur."

            echo "[`date +%m/%d/%Y-%H:%M`] Starting package installation and settings migration." >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log
          break
            ;;
        "No - I do not agree")

            echo "Exiting ... ";
            exit
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done


start_spinner 'Installing Apache Tomcat...'
sleep 1

#Install Tomcat
apt-get install $TOMCATVERSION -y >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Configuring Apache Tomcat for Ciphermail...'
sleep 1

#Configure Apache Tomcat for ciphermail
cp /etc/default/$TOMCATVERSION /etc/default/$TOMCATVERSION.ORIGINAL >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
echo "JAVA_OPTS=\"\$JAVA_OPTS -Ddjigzo-web.home=/usr/share/djigzo-web -Ddjigzo.home=/usr/share/djigzo\"" | sudo tee -a /etc/default/$TOMCATVERSION >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
echo "JAVA_OPTS=\"\$JAVA_OPTS -Djava.awt.headless=true -Xmx256M\"" | sudo tee -a /etc/default/$TOMCATVERSION >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
echo "<Context docBase=\"/usr/share/djigzo-web/djigzo.war\" />" | sudo tee /etc/$TOMCATVERSION/Catalina/localhost/ciphermail.xml >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
echo "<Context docBase=\"/usr/share/djigzo-web/djigzo-portal.war\" />" | sudo tee /etc/$TOMCATVERSION/Catalina/localhost/web.xml >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
cp /etc/$TOMCATVERSION/server.xml /etc/$TOMCATVERSION/server.ORIGINAL >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
cp /usr/share/djigzo-web/conf/tomcat/server.xml /etc/$TOMCATVERSION/ >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
sed -i 's/unpackWARs="false"/unpackWARs="true"/' /etc/$TOMCATVERSION/server.xml >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
chown $TOMCATUSER:djigzo /usr/share/djigzo-web/ssl/sslCertificate.p12 >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
systemctl restart $TOMCATVERSION >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

start_spinner 'Cleaning Up Old Apache Tomcat Files...'
sleep 1

#Delete Tomcat8
rm -rf /etc/tomcat8 >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1  && \
rm -rf /etc/default/tomcat8 >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] ==== FINISHED INSTALLATION ==== Ensure no errors were logged during installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

echo "${GREEN}FINISHED INSTALLATION. PLEASE REBOOT YOUR MACHINE!!${RESET}" | boxes -d stone -p a2v1


echo "Take a look at the ${GREEN}$SCRIPTPATH/migrate_log-$TIMESTAMP.log${RESET} file for any errors"
