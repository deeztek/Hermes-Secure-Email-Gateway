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

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`


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

echo "Downloading spinner.sh"
#Download spinner.sh
wget https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/spinner.sh > /dev/null 2>&1

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}Error $THEERROR, occurred Downloading spinner.sh ${RESET}"
exit 1
else
echo "${GREEN}Completed Downloading spinner.sh ${RESET}"
fi

source "$(pwd)/spinner.sh"

# test success
start_spinner 'sleeping for 2 secs...'
sleep 2
stop_spinner $?


PS3='This script will attempt to either migrate your Hermes SEG from Lucee to Commandbox if applicable or upgrade Lucee in existing Commandbox installations. Ensure that you have a fresh and valid backup of your machine before proceeding. This script is offered with absolutely no warrranty or guarantee of any kind. We cannot be held liable for any damage that may occur to your system. Do you agree with the terms of this script?: '

options=("Yes - I agree" "No - I do not agree")
select opt in "${options[@]}"
do
    case $opt in
        "Yes - I agree")

            echo "${GREEN}Starting Upgrade...${RESET}" | boxes -d stone -p a2v1
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

# BAT / CMD goto function
function goto
{
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 |
          grep -v ':$')
    eval "$cmd"
    exit
}

# Just for the heck of it: how to create a variable where to jump to:
start=${1:-"start"}
goto "start"

: start

#If Lucee is enabled goto install
STR=`systemctl is-enabled lucee_ctl`
SUB='enabled'
if [[ "$STR" == *"$SUB"* ]]; then
  echo "Commandbox not found. Proceeding with installation..."
  goto "migrate"
  else
  goto "checkcommandbox"
fi


: checkcommandbox

#If Commandbox has Lucee 5.2.9 goto upgrade
File="/var/www/html/server.json"
if grep -q lucee@5.3.5 "$File"; then
  echo "Commandbox with Lucee 5.3.5 Found. Nothing to do. Exiting...."
  exit 1
else
   echo "Commandbox with Lucee 5.2.9 Found. Proceeding with upgrade..."
   goto "upgrade"
fi



: migrate

echo "[`date +%m/%d/%Y-%H:%M`] Cloning Repo...." >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Cloning Repo...'
sleep 1

#Clone Repo
git clone http://gitlab.deeztek.com/dedwards/hermes-seg-18.04.git  $SCRIPTPATH/hermes-seg-18.04 >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Disabling Lucee Service" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Disabling Lucee Service...'
sleep 1

#Disable Lucee Service
systemctl disable lucee_ctl >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Uninstalling Lucee" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Uninstalling Lucee...'
sleep 1

#Uninstall Lucee
/opt/lucee/uninstall --mode unattended >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Commandbox" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Installing Commandbox...'
sleep 1

#Install Commandbox
curl -fsSl https://downloads.ortussolutions.com/debs/gpg | sudo apt-key add - >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
echo "deb https://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
apt-get update >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
apt-get install apt-transport-https commandbox -y >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Commandbox Server Parameters" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Configuring Commandbox Server Parameters...'
sleep 1

#Configure Commandbox
cp $SCRIPTPATH/hermes-seg-18.04/download/commandbox/server_5.3.5.json /var/www/html/server.json >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring and Starting Hermes SEG Service" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Configuring and Starting Hermes SEG Service...'
sleep 1

#Configure Hermes SEG Service
cp $SCRIPTPATH/hermes-seg-18.04/download/commandbox/hermesseg.service /etc/systemd/system/hermesseg.service >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
systemctl enable --now hermesseg.service >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
systemctl restart hermesseg.service >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Generating Random Commandbox Lucee Server and Web Administrator Password" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Generating Random Commandbox Lucee Server and Web Administrator Password...'
sleep 1

LUCEE_ADMIN_PASSWORD=`openssl rand -hex 20`

#Export the variable
export LUCEE_ADMIN_PASSWORD

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Random Password is: $LUCEE_ADMIN_PASSWORD" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

echo "Random Password is:${GREEN} $LUCEE_ADMIN_PASSWORD ${RESET}" | boxes -d stone -p a2v1

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Commandbox Lucee Server and Web Administrator Password" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Configuring Commandbox Lucee Server and Web Administrator Password...'
sleep 1

#Configure Lucee Server and Web Administrator Password
cp $SCRIPTPATH/hermes-seg-18.04/download/commandbox/password.txt /opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-server/context/password.txt  >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1 && \
sed -i -e "s|LUCEE-PASSWORD|$LUCEE_ADMIN_PASSWORD|g" "/opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-server/context/password.txt" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Copying NEW Compiled Files..." >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Copying NEW Compiled Files...'
sleep 1

#Copy new compiled files
cp -rf $SCRIPTPATH/hermes-seg-18.04/proprietary_535/* /var/www/html/admin 2>> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

stop_spinner $?

goto "done"


: upgrade

echo "[`date +%m/%d/%Y-%H:%M`] Cloning Repo...." >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Cloning Repo...'
sleep 1

#Clone Repo
git clone http://gitlab.deeztek.com/dedwards/hermes-seg-18.04.git  $SCRIPTPATH/hermes-seg-18.04 >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Upgrading Lucee to 5.3.5 in Commandbox" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Upgrading Lucee to 5.3.5 in Commandbox...'
sleep 1

#Upgrade Lucee in commandbox
cp $SCRIPTPATH/hermes-seg-18.04/download/commandbox/server_5.3.5.json /var/www/html/server.json >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

start_spinner 'Removing Lucee Artifacts from Commandbox...'
sleep 1

#Remove artifacts
yes | /usr/local/bin/box artifacts remove lucee >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?

start_spinner 'Deleting Commandbox Home Directory...'
sleep 1

#Delete commandbox home directory
rm -rf /opt/CommandBox/ >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Copying NEW Compiled Files..." >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

start_spinner 'Copying NEW Compiled Files...'
sleep 1

#Copy new compiled files
cp -rf $SCRIPTPATH/hermes-seg-18.04/proprietary_535/* /var/www/html/admin 2>> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

stop_spinner $?

goto "done"

: done

echo "[`date +%m/%d/%Y-%H:%M`] ==== FINISHED INSTALLATION ==== Ensure no errors were logged during installation" >> $SCRIPTPATH/migrate_log-$TIMESTAMP.log

echo "${GREEN}FINISHED INSTALLATION. PLEASE REBOOT YOUR MACHINE!!${RESET}" | boxes -d stone -p a2v1


echo "Take a look at the ${GREEN}$SCRIPTPATH/migrate_log-$TIMESTAMP.log${RESET} file for any errors"