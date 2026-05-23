#!/bin/bash

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`


#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root. Exiting...."
      exit 1
   fi

echo "Checking for newer update files..."
#Download the latest versions of the update files
wget -q https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/dirstructure/var/www/html/admin/2/inc/generate_customtrans.cfm?ref_type=heads -O /opt/hermes/tmp/generate_customtrans.cfm
wget -q https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/dirstructure/var/www/html/admin/2/inc/check_system_update.cfm?ref_type=heads -O /opt/hermes/tmp/check_system_update.cfm
wget -q https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/dirstructure/var/www/html/admin/2/inc/download_system_update.cfm?ref_type=heads -O /opt/hermes/tmp/download_system_update.cfm
wget -q https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/dirstructure/var/www/html/admin/2/inc/verify_system_update.cfm?ref_type=heads -O /opt/hermes/tmp/verify_system_update.cfm
wget -q https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/dirstructure/opt/hermes/scripts/system_update.sh?ref_type=heads -O /opt/hermes/tmp/system_update.sh
wget -q https://gitlab.deeztek.com/dedwards/hermes-seg-18.04/-/raw/master/dirstructure/opt/hermes/scripts/shasum.sh?ref_type=heads -O /opt/hermes/tmp/shasum.sh

CUSTOMTRANSUPDATE1=/opt/hermes/tmp/generate_customtrans.cfm
CUSTOMTRANSUPDATE2=/var/www/html/admin/2/inc/generate_customtrans.cfm
CHECKUPDATE1=/opt/hermes/tmp/check_system_update.cfm
CHECKUPDATE2=/var/www/html/admin/2/inc/check_system_update.cfm
DOWNLOADUPDATE1=/opt/hermes/tmp/download_system_update.cfm
DOWNLOADUPDATE2=/var/www/html/admin/2/inc/download_system_update.cfm
VERIFYUPDATE1=/opt/hermes/tmp/verify_system_update.cfm
VERIFYUPDATE2=/var/www/html/admin/2/inc/verify_system_update.cfm
SYSTEMUPDATE1=/opt/hermes/tmp/system_update.sh
SYSTEMUPDATE2=/opt/hermes/scripts/system_update.sh
SHASUMUPDATE1=/opt/hermes/tmp/shasum.sh
SHASUMUPDATE2=/opt/hermes/scripts/shasum.sh

SYSTEMRESTART="NO"

#Check if $CUSTOMTRANSUPDATE2 exists
if [ ! -f "$CUSTOMTRANSUPDATE2" ]; then
      echo "$CUSTOMTRANSUPDATE2 does not exist, creating..."
      mv $CUSTOMTRANSUPDATE1 $CUSTOMTRANSUPDATE2
      
else

#If $CUSTOMTRANSUPDATE2 exists then check if $CUSTOMTRANSUPDATE1 is different than $CUSTOMTRANSUPDATE2

if cmp --silent -- "$CUSTOMTRANSUPDATE1" "$CUSTOMTRANSUPDATE2"; then

  echo "No update needed for $CUSTOMTRANSUPDATE2..."

  #Cleanup
  rm $CUSTOMTRANSUPDATE1
  
else

  echo "$CUSTOMTRANSUPDATE2 is different, updating..."
  mv $CUSTOMTRANSUPDATE1 $CUSTOMTRANSUPDATE2
 
fi

fi



#Check if $CHECKUPDATE2 exists
if [ ! -f "$CHECKUPDATE2" ]; then
      echo "$CHECKUPDATE2 does not exist, creating..."
      mv $CHECKUPDATE1 $CHECKUPDATE2
      
else

#If $CHECKUPDATE2 exists then check if $CHECKUPDATE1 is different than $CHECKUPDATE2

if cmp --silent -- "$CHECKUPDATE1" "$CHECKUPDATE2"; then

  echo "No update needed for $CHECKUPDATE2..."

  #Cleanup
  rm $CHECKUPDATE1
  

else

  echo "$CHECKUPDATE2 is different, updating..."
  mv $CHECKUPDATE1 $CHECKUPDATE2
 

fi

fi


#Check if $DOWNLOADUPDATE2 exists
if [ ! -f "$DOWNLOADUPDATE2" ]; then
      echo "$DOWNLOADUPDATE2 does not exist, creating..."
      mv $DOWNLOADUPDATE1 $DOWNLOADUPDATE2
      
else

#If $DOWNLOADUPDATE2 exists then check if $DOWNLOADUPDATE1 is different than $DOWNLOADUPDATE2

if cmp --silent -- "$DOWNLOADUPDATE1" "$DOWNLOADUPDATE2"; then

  echo "No update needed for $DOWNLOADUPDATE2..."

  #Cleanup
  rm $DOWNLOADUPDATE1
  

else

  echo "$DOWNLOADUPDATE2 is different, updating..."
  mv $DOWNLOADUPDATE1 $DOWNLOADUPDATE2



fi

fi


#Check if $VERIFYUPDATE2 exists
if [ ! -f "$VERIFYUPDATE2" ]; then
      echo "$VERIFYUPDATE2 does not exist, creating..."
      mv $VERIFYUPDATE1 $VERIFYUPDATE2
      
else

#If $VERIFYUPDATE2 exists then check if $VERIFYUPDATE1 is different than $VERIFYUPDATE2

if cmp --silent -- "$VERIFYUPDATE1" "$VERIFYUPDATE2"; then

  echo "No update needed for $VERIFYUPDATE2..."

  #Cleanup
  rm $VERIFYUPDATE1
  

else

  echo "$VERIFYUPDATE2 is different, updating..."
  mv $VERIFYUPDATE1 $VERIFYUPDATE2
 


fi

fi



#if $SYSTEMUPDATE1 is different than $SYSTEMUPDATE2

if cmp --silent -- "$SYSTEMUPDATE1" "$SYSTEMUPDATE2"; then

  echo "No update needed for $SYSTEMUPDATE2..."

  #Cleanup
  rm $SYSTEMUPDATE1
  SYSTEMRESTART="NO"

else

  echo "$SYSTEMUPDATE2 is different, updating..."
  mv $SYSTEMUPDATE1 $SYSTEMUPDATE2
  chmod +x $SYSTEMUPDATE2
  SYSTEMRESTART="YES"


fi


#Check if $SHASUMUPDATE2 exists
if [ ! -f "$SHASUMUPDATE2" ]; then
      echo "$SHASUMUPDATE2 does not exist, creating..."
      mv $SHASUMUPDATE1 $SHASUMUPDATE2
      
else

#If $SHASUMUPDATE2 exists then check if $SHASUMUPDATE1 is different than $SHASUMUPDATE2

if cmp --silent -- "$SHASUMUPDATE1" "$SHASUMUPDATE2"; then

  echo "No update needed for $SHASUMUPDATE2..."

  #Cleanup
  rm $SHASUMUPDATE1
  

else

  echo "$SHASUMUPDATE2 is different, updating..."
  mv $SHASUMUPDATE1 $SHASUMUPDATE2


fi

fi


if [ "$SYSTEMRESTART" = "YES" ]

then 

echo "Newer /opt/hermes/scripts/system_update.sh found and downloaded. You must restart the update. Exiting..."
exit 0

else

echo "No new /opt/hermes/scripts/system_update.sh found. Proceeding ..."

fi

#Check if Lucee is enabled
STR=`systemctl is-enabled lucee_ctl 2>&1`
SUB='enabled'
if [[ "$STR" == *"$SUB"* ]]; then
  echo "[INFO] Lucee Standalone Found. Restarting Lucee Service..."
  systemctl restart lucee_ctl 2>&1

  ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR Restarting Lucee Service${RESET}"
exit 1
else
echo "${GREEN}[SUCCESS] Restarting Lucee Service${RESET}"
fi

  else
 echo "[INFO] Commandbox Found. Restarting Hermes SEG Service..."
  systemctl restart hermesseg 2>&1

  ERR=$?
if [ $ERR != 0 ]; then
echo "${RED}[ERROR] $ERR Restarting Hermes SEG Service${RESET}"
exit 1
else
echo "${GREEN}[SUCCESS] Restarting Hermes SEG Service${RESET}"
fi

fi



PS3='Would you like to check for DEV Updates? (This should always be NO unless guided by support.): '
options=("NO" "YES")
select opt in "${options[@]}"
do
    case $opt in
        "NO")



          break
            ;;
        "YES")

            break
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done

if [ "$opt" = "YES" ]

then 

echo "[INFO]Checking for DEV Updates"

DEV=1

else

echo "[INFO]Checking for Production Updates"

DEV=2

fi

#ENSURE /OPT/HERMES/UPDATES EXISTS
mkdir -p /opt/hermes/updates

# BAT / CMD goto function
function goto
{
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 |
          grep -v ':$')
    eval "$cmd"
    exit
}


# goto start
start=${1:-"start"}
goto "start"


: start

read -p "Enter MySQL(MariaDB) root user password: "  MYSQL_ROOT_PASSWORD

if [ -z "$MYSQL_ROOT_PASSWORD" ]

then

      echo "${RED}[ERROR]MySQL(MariaDB) root user password cannot be empty ${RESET}"

goto "start"


else

export MYSQL_ROOT_PASSWORD
goto "checkmysql"

fi


: checkmysql

echo "[INFO] Checking MYSQL(MariaDB) root password"

mysql -u root -p$MYSQL_ROOT_PASSWORD -e"quit" >/tmp/checkmysqlpassword.txt 2>&1

CHECKMYSQLPASSWORD=`cat /tmp/checkmysqlpassword.txt`

if [[ $CHECKMYSQLPASSWORD == *"ERROR 1045"* ]]; then

echo "${RED}[ERROR]The MYSQL(MariaDB) root password is incorrect${RESET}"
rm -rf /tmp/checkmysqlpassword.txt
goto "start"

else 

echo "${GREEN}[SUCCESS] Checking MYSQL(MariaDB) root password${RESET}"
rm -rf /tmp/checkmysqlpassword.txt
goto "httpstatus"

fi


: httpstatus

#GET HERMES SYSTOKEN TO BE USED AS THETOKEN
THETOKEN=$(mysql -u root -p$MYSQL_ROOT_PASSWORD hermes -se "select token from api_tokens where system='1' and active='1'")

echo "[INFO] Checking connectivity to Update Services"
#curl -LI http://localhost:8080/admin/2/inc/check_system_updatte.cfm -o /dev/null -s

curl -X "POST" -s "http://127.0.0.1:8888/hermes-api/" -H "accept: */*" -H "X-Original-URL: /admin/2/inc/check_system_update.cfm?dev=$DEV" -H "X-Token: $THETOKEN" > /dev/null

sleep 15

THEHTTPSTATUS=`cat /opt/hermes/updates/check_system_update_http_status.txt`

if [ "$THEHTTPSTATUS" = "200 OK" ]; then
echo "${GREEN}[SUCCESS] Successfully connected to Update Services${RESET}"

goto "checkupdate"

else

echo "${RED}[ERROR]Error $THEHTTPSTATUS while checking connectivity to Update Services${RESET}"
exit 1

fi

: checkupdate

echo "[INFO] Checking for available update"
THEUPDATE=`cat /opt/hermes/updates/check_system_update.txt | cut -d@ -f1`

if [ "$THEUPDATE" = "SUCCESS" ]; then

THEUPDATEBUILD=`cat /opt/hermes/updates/check_system_update.txt | cut -d@ -f2`
THEUPDATEDATE=`cat /opt/hermes/updates/check_system_update.txt | cut -d@ -f3`
THEUPDATEFILE=`cat /opt/hermes/updates/check_system_update.txt | cut -d@ -f4`
THEUPDATERELEASEFILE=`cat /opt/hermes/updates/check_system_update.txt | cut -d@ -f5`

#echo "the update file: $THEUPDATEFILE"

echo "${GREEN}[SUCCESS] Update Build No $THEUPDATEBUILD dated $THEUPDATEDATE was found${RESET}"

PS3='Would you like to download this update? (If you select NO the update process will end): '
options=("YES" "NO")
select opt2 in "${options[@]}"
do
    case $opt2 in
        "YES")

          break
            ;;
        "NO")


            break
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done


if [ "$opt2" = "YES" ]

then

goto "downloadupdate"

else

echo "${RED}Update process has been cancelled${RESET}"

exit 0

fi

elif [ "$THEUPDATE" = "NOUPDATE" ]; then

echo "[INFO] No updates were found. You seem to be on the latest version. Exiting..."
exit 0

elif [ "$THEUPDATE" = "INVALIDREQUEST" ]; then

echo "${RED}There was a problem determining if an update was available. Exiting...${RESET}"
exit 1

fi

: downloadupdate

#GET HERMES SYSTOKEN TO BE USED AS THETOKEN
THETOKEN=$(mysql -u root -p$MYSQL_ROOT_PASSWORD hermes -se "select token from api_tokens where system='1' and active='1'")

echo "[INFO] Attempting to download Update Build No $THEUPDATEBUILD"
#curl -LI http://localhost:8080/admin/2/inc/check_system_updatte.cfm -o /dev/null -s

#DOWNLOAD THE UPDATE FILE
curl -X "POST" -s "http://127.0.0.1:8888/hermes-api/" -H "accept: */*" -H "X-Original-URL: /admin/2/inc/download_system_update.cfm?file=$THEUPDATEFILE" -H "X-Token: $THETOKEN" > /dev/null

sleep 15

THEDOWNLOAD=`cat /opt/hermes/updates/download_system_update_http_status.txt`

if [ "$THEDOWNLOAD" = "SUCCESS" ]; then

echo "${GREEN}[SUCCESS] Update Build No $THEUPDATEBUILD has been downloaded${RESET}"

goto "downloadhash"

else

echo "${RED}[ERROR]There was a problem downloading the update${RESET}"

exit 0

fi

: downloadhash

echo "[INFO] Attempting to download Update Build No $THEUPDATEBUILD Hash"
#DOWNLOAD THE UPDATE HASH FILE
curl -X "POST" -s "http://127.0.0.1:8888/hermes-api/" -H "accept: */*" -H "X-Original-URL: /admin/2/inc/download_system_update.cfm?file=$THEUPDATEFILE.hash" -H "X-Token: $THETOKEN" > /dev/null

sleep 15

THEHASH=`cat /opt/hermes/updates/download_system_update_http_status.txt`

if [ "$THEHASH" = "SUCCESS" ]; then

echo "${GREEN}[SUCCESS] Update Build No $THEUPDATEBUILD Hash has been downloaded${RESET}"

goto "verifyupdate"

else

echo "${RED}[ERROR]There was a problem downloading the update hash file${RESET}"

exit 0

fi


: verifyupdate

echo "[INFO] Attempting to verify $THEUPDATEBUILD Checksum"

#VERIFY UPDATE CHECKSUM
curl -X "POST" -s "http://127.0.0.1:8888/hermes-api/" -H "accept: */*" -H "X-Original-URL: /admin/2/inc/verify_system_update.cfm?file=$THEUPDATEFILE" -H "X-Token: $THETOKEN" > /dev/null

sleep 15

THECHECKSUM=`cat /opt/hermes/updates/verify_system_update.txt`

if [ "$THECHECKSUM" = "SUCCESS" ]; then

echo "${GREEN}[SUCCESS] Update Build No $THEUPDATEBUILD Checksum has been verified${RESET}"

goto "extractupdate"

else

echo "${RED}[ERROR]There was a problem verifying update checksum${RESET}"

exit 0

fi

: extractupdate

echo "[INFO] Attempting to extract $THEUPDATEBUILD Update"

#DELETE ANY REMNANTS OF PREVIOUS UPDATE
rm -rf /opt/hermes/updates/$THEUPDATEBUILD

#CREATE UPDATE DIRECTORY
mkdir -p /opt/hermes/tmp/hermes-$THEUPDATEBUILD

#EXTRACT THE UPDATE
tar -xvzf /opt/hermes/updates/$THEUPDATEFILE -C /opt/hermes/tmp/hermes-$THEUPDATEBUILD > /dev/null

#CHECK IF /OPT/HERMES/UPDATE/$THEUPDATEBUILD/INSTALL.SH FILE EXISTS
if [ ! -f "/opt/hermes/tmp/hermes-$THEUPDATEBUILD/install.sh" ]; then
       echo "${RED}[ERROR]There was a problem extracting update${RESET}"
      exit 1
else

#MAKE INSTALL.SH EXECUTABLE
chmod +x /opt/hermes/tmp/hermes-$THEUPDATEBUILD/install.sh

echo "${GREEN}[SUCCESS] Update Build No $THEUPDATEBUILD has been extracted${RESET}"

goto "installupdate"

fi

: installupdate

echo "=== WARNING ===" | boxes -d stone -p a2v1

echo "This update may introduce breaking changes and additional steps may have to be performed manually after the update installs. Ensure you refer to the Release Notes at the URL below prior to installing the update."

echo ""

echo "${GREEN}https://updates.deeztek.com/releasenotes/hermes-$THEUPDATEBUILD-release.html${RESET}"

echo ""

PS3='Would you like to install this update? By selecting YES, you verify that you have a valid and recent System Backup, you have read the Release Note for this update and agree that this update is provided with absolutely no guarantees or warranties of any kind explicitly or implied. Furthermore, you agree that we are NOT liable for any damage that may occur to your system, service, cat, dog, car, house etc.. Simply stated, you are installing this update at your own risk.'
options=("YES" "NO")
select opt3 in "${options[@]}"
do
    case $opt3 in
        "YES")

          break
            ;;
        "NO")


            break
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done


if [ "$opt3" = "YES" ]

then

echo "[INFO] Attempting to install $THEUPDATEBUILD Update"

/opt/hermes/tmp/hermes-$THEUPDATEBUILD/install.sh


else

echo "${RED}Update process has been cancelled${RESET}"

exit 0

fi



#MAKE UPDATE SCRIPT EXECUTABLE


# === NO LONGER USED BELOW. LEFT AS REFERENCE ===
#: httpstatus

#echo "[INFO] Verifying connectivity to Update Services"
#HTTPSTATUS=`curl -LI https://updates.deeztek.com -o /dev/null -w '%{http_code}\n' -s`

#if [ "$HTTPSTATUS" = "200" ]; then
#echo "${GREEN}[SUCCESS] Successfully connected to Update Services${RESET}"

#goto "getbuild"

#else

#echo "${RED}[ERROR][ERROR] Unable to connect to Update Services. HTTP Code $HTTPSTATUS${RESET}"
#exit 1
#fi

#: getbuild

#echo "[INFO] Getting Hermes SEG Build No"
#GET HERMES BUILD_NO TO BE USED AS BUILD_NO
#BUILD_NO=$(mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD hermes -se "SELECT value from system_settings where parameter='build_no'")

#if [[ -z "$BUILD_NO" ]]; then
#      echo "${RED}[ERROR][ERROR] The Hermes Build Number variable is empty. Exiting...${RESET}"
#      exit 1
#else

#echo "${GREEN}[SUCCESS] Got Hermes SEG Build No: $BUILD_NO${RESET}"

#goto "checkupdate"

#fi

#: checkupdate

#echo "[INFO] Checking for Updates"

#RESPONSECODETXT=`curl -X GET -s https://updates.deeztek.com/download_manual.cfm?dev=2'&'build_no=$BUILD_NO > responsecode.txt`

#RESPONSECODE=`sed 's/^ *//; s/ *$//; /^$/d' responsecode.txt`
#echo "$RESPONSECODE"

# === NO LONGER USED ABOVE. LEFT FOR REFERENCE ===
