#!/bin/bash

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`


#== IMPORT/DELETE RECIPIENTS INTO HERMES VIA INLINE .CSV FILE ==
#
#CSV File must contain the recipients to be imported/deleted using the format below:
#
# recipient
# someone@domain.tld
# someoneelse@domain.tld
#
#=== IMPORTANT ===
#You must have the domain for each recipient to be imported/deleted already configured in System --> Relay Domains before attempting to run this script

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "${RED}This script must be executed as root, Exiting... ${RESET}"
      exit 1
   fi

#Install boxes
apt install boxes -y

echo "Hermes SEG Bulk Recipient Import/Delete" | boxes -d stone -p a2v1

echo "${RED}You must have the domain for each recipient to be imported/deleted already configured under 'Gateway --> Relay Domains' before attempting to run this script. If you don't, select 'No' below to cancel running this script${RESET}"

PS3='Do you wish to continue running this script?: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            echo "Starting Hermes SEG Bulk Recipient Import/Delete." >> $SCRIPTPATH/install_log-$TIMESTAMP.log  | boxes -d stone -p a2v1


          break
            ;;
        "No")

            echo "Cancelling Hermes SEG Bulk Recipient Import/Delete";
            exit
            ;;

        *) echo "invalid option $REPLY";;
    esac
done



#Get Inputs
MYSQL_ROOT_USERNAME=root

read -p "Enter MySQL(MariaDB) root user password:"  MYSQL_ROOT_PASSWORD

if [ -z "$MYSQL_ROOT_PASSWORD" ]
then
      echo "${RED}MySQL(MariaDB) root user password cannot be empty ${RESET}"
      exit
fi

read -p "Enter directory path and filename that contains the recipients .csv you wish to import/delete (Example: /tmp/recipients.csv): "  CSVPATH

if [ -z "$CSVPATH" ]
then

      echo "${RED}recipients .csv directory path and filename cannot be empty ${RESET}"
      exit
fi

PS3='Are you performing a bulk import or delete: '
options=("Import" "Delete")
select opt in "${options[@]}"
do
    case $opt in
        "Import")
            THEACTION=insert


          break
            ;;
        "Delete")

            THEACTION=delete


          break
            ;;

        *) echo "invalid option $REPLY";;
    esac
done

echo "Performing bulk $THEACTION"

#Check if .csv file exists and if not exit
if [ ! -f "$CSVPATH" ]; then
      echo "${RED} $CSVPATH does not exist, Exiting... ${RESET}"
      exit 1
   fi

if [ $THEACTION = "insert" ]; then
# === IMPORT SMTP Addresses ===
/usr/bin/mysql --local-infile=1 -u${MYSQL_ROOT_USERNAME}  -p${MYSQL_ROOT_PASSWORD} -e "use hermes; LOAD DATA LOCAL INFILE '"$CSVPATH"' INTO TABLE recipients_temp FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 lines (recipient);"

# === Run Cleanup and Update SQL ===
/usr/bin/mysql -u${MYSQL_ROOT_USERNAME}  -p${MYSQL_ROOT_PASSWORD} hermes < insert.sql

elif [ $THEACTION = "delete" ]; then

# === IMPORT SMTP Addresses ===
/usr/bin/mysql --local-infile=1 -u${MYSQL_ROOT_USERNAME}  -p${MYSQL_ROOT_PASSWORD} -e "use hermes; LOAD DATA LOCAL INFILE '"$CSVPATH"' INTO TABLE recipients_temp FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 lines (recipient);"

# === Run Cleanup and Update SQL ===
/usr/bin/mysql -u${MYSQL_ROOT_USERNAME}  -p${MYSQL_ROOT_PASSWORD} hermes < delete.sql

else

echo "${RED} $THEACTION does not  match, Exiting... ${RESET}"
exit 1

fi


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "$ERR Error occurred"
exit 1
else
echo "${GREEN}Hermes SEG Recipient Bulk ${THEACTION} completed succesfully. Please navigate to 'Gateway --> Internal Recipients' to 'Apply Settings' and complete the recipient ${THEACTION} into your system.${RESET}"
fi

