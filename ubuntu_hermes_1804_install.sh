#!/bin/bash

#The script below assumes you have a fully installed and updated Ubuntu 18.04 server and you have created /mnt/data as outlined below. 
#The Configure /mnt/data partition directions below assumes you have a 250GB secondary drive which you will partition, format and mount as /mnt/data. Technically a secondary drive for the /mnt/data directory is not a requirement but it's highly recommended for performance reasons. If you don't wish to use a secondary drive for the /mnt/data directory, simply create a /mnt/data directory in your system and run this script.

#Configure /mnt/data partition
#sudo mkdir -p /mnt/data

#sudo fdisk -l 
#Look for 250 GB drive you created earlier device ID, usually /dev/sdb. Ensure you select correct device ID before running the commands below)

#Create partititon
#sudo fdisk /dev/sdb
#Hit "n" to add new partition
#Hit "p" for primary partition
#Hit "Enter" for partition 1
#Hit "Enter" for default first sector
#Hit "Enter" for default last sector
#Hit "w" to write changes to disk and exit

#Format Partition
#sudo mkfs.ext4 /dev/sdb1

#Mount Partition to /mnt/data
#sudo mount /dev/sdb1 /mnt/data

#Get disk UUID
#ls -l /dev/disk/by-uuid

#Edit /etc/fstab
#sudo vi /etc/fstab

#Add the following in /etc/fstab where DEVICE_ID is the UUID from the command above
#UUID=DEVICE_ID /mnt/data               ext4    errors=remount-ro 0       1

#Verify drive is mounted
#sudo df -h

#Should yield output similar to below:
#Filesystem      Size  Used Avail Use% Mounted on
#udev            1.9G     0  1.9G   0% /dev
#tmpfs           395M  1.1M  394M   1% /run
#/dev/sda2        79G  5.5G   69G   8% /
#tmpfs           2.0G     0  2.0G   0% /dev/shm
#tmpfs           5.0M     0  5.0M   0% /run/lock
#tmpfs           2.0G     0  2.0G   0% /sys/fs/cgroup
#/dev/loop0       87M   87M     0 100% /snap/core/4917
#/dev/loop1       90M   90M     0 100% /snap/core/8039
#tmpfs           395M     0  395M   0% /run/user/1000
#/dev/sdb1       246G   61M  233G   1% /mnt/data

#Reboot and ensure /mnt/data gets mounted automatically

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "This script must be executed as root, Exiting..."
      exit 1
   fi

#Check if /mnt/data exists and if not exit
if [ ! -d "/mnt/data" ]; then
      echo "/mnt/data directory does not exist, Exiting..."
      exit 1
   fi

#Check if /etc/mysql exists and if not exit. This is no longer necessary since the script installs and configures MariaDB on its own
#if [ ! -d "/etc/mysql" ]; then
#      echo "MySQL(MariaDB) does not seem to be installed, Exiting..."
#      exit 1
#   fi

#Set the script path
SCRIPTPATH=$(pwd)

#Set install_log Date/Time Stamp
TIMESTAMP=`date +%m-%d-%Y-%H%M`

#Get System IP to be used for Authelia and Nginx configs
THEIP=`/bin/hostname -I | cut -d' ' -f1 | xargs`

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

#Script Debug Set Variables. Do not enable unless you are troubleshooting
#MYSQL_ROOT_PASSWORD=password
#MYSQL_HERMES_USERNAME=hermes
#MYSQL_HERMES_PASSWORD=password
#MYSQL_SYSLOG_USERNAME=rsyslog
#MYSQL_SYSLOG_PASSWORD=password
#MYSQL_OPENDMARC_USERNAME=opendmarc
#MYSQL_OPENDMARC_PASSWORD=password
#MYSQL_CIPHERMAIL_USERNAME=ciphermail
#MYSQL_CIPHERMAIL_PASSWORD=password
#LUCEE_ADMIN_PASSWORD=password
#MAIL_NAME=smtp.domain.tld


echo "Installing Boxes Prerequisite"
#Install boxes
apt-get install boxes -y

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Installing Boxes Prerequisite ${RESET}"
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Installing Boxes Prerequisite ${RESET}"
fi

PS3='Do you wish to continue the installation of Hermes SEG 18.04 (Selecting NO will stop installation)?: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")

            echo "Starting Hermes SEG 18.04 Installation" | boxes -d stone -p a2v1
            echo "${RED}During installation a $SCRIPTPATH/install_log-$TIMESTAMP.log log file will be created. It's highly recommended that you open a separate shell window and tail that file in order to view progress of the installation and/or any errors that may occur. Additionally, ensure that you note all the usernames and passwords you will be prompted to create${RESET}"

            echo "[`date +%m/%d/%Y-%H:%M`] Starting Hermes SEG 18.04 Installation." >> $SCRIPTPATH/install_log-$TIMESTAMP.log
          break
            ;;
        "No")

            echo "Exiting Hermes SEG 18.04 installation ";
            exit
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done

#Set Default username for MySQL root
MYSQL_ROOT_USERNAME=root

read -p "Enter MySQL(MariaDB) root user password you wish to use (Ensure you do NOT use $ , single or double quote special characters to form your password): "  MYSQL_ROOT_PASSWORD
read -p "Enter MySQL(MariaDB) Hermes SEG user username you wish to use (Example: hermes): "  MYSQL_HERMES_USERNAME
read -p "Enter MySQL(MariaDB) Hermes SEG user password you wish to use (Ensure you do NOT use $ , single or double quote special characters to form your password): "  MYSQL_HERMES_PASSWORD
read -p "Enter MySQL(MariaDB) Syslog username you wish to use (Example: rsyslog): "  MYSQL_SYSLOG_USERNAME
read -p "Enter MySQL(MariaDB) Syslog user password you wish to use (Ensure you do NOT use $ , single or double quote special characters to form your password): "  MYSQL_SYSLOG_PASSWORD
read -p "Enter MySQL(MariaDB) Ciphermail username you wish to use (Example: ciphermail): "  MYSQL_CIPHERMAIL_USERNAME
read -p "Enter MySQL(MariaDB) Ciphermail user password you wish to use (Ensure you do NOT use $ , single or double quote special characters to form your password): "  MYSQL_CIPHERMAIL_PASSWORD
read -p "Enter MySQL(MariaDB) Opendmarc username you wish to use (Example: opendmarc): "  MYSQL_OPENDMARC_USERNAME
read -p "Enter MySQL(MariaDB) Opendmarc user password you wish to use (Ensure you do NOT use $ , single or double quote special characters to form your password): "  MYSQL_OPENDMARC_PASSWORD
read -p "Enter Lucee Server and Web Administrator password you wish to use (Ensure you do NOT use $ , single or double quote special characters to form your password): "  LUCEE_ADMIN_PASSWORD
read -p "Enter System Mailname (Example: smtp.domain.tld): "  MAIL_NAME


echo "[`date +%m/%d/%Y-%H:%M`] Installing MySQL(MariaDB) Server" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install MariaDB
/usr/bin/apt-get install mariadb-server mariadb-client rsync -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Installing MySQL(MariaDB) Server ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing MySQL(MariaDB) database ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring MySQL(MariaDB) Server" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#configure MariaDB
/usr/bin/mysql -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';" \
/usr/bin/mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" \
/usr/bin/mysql -e "DELETE FROM mysql.user WHERE User='';" \
#/usr/bin/mysql -e "DROP DATABASE test;" \
/usr/bin/mysql -e "FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring MySQL(MariaDB) Server ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring MySQL(MariaDB) Server ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi



echo "[`date +%m/%d/%Y-%H:%M`] Stopping MySQL(MariaDB) Server" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Stop MySQL
/bin/systemctl stop mysql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during stopping MySQL(MariaDB) Server ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed stopping MySQL(MariaDB) Server ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Copying MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create /mnt/data/dbase directory, copy /var/lib/mysql/* to it and change owner to mysql
/bin/mkdir -p /mnt/data/dbase && /bin/cp -r /var/lib/mysql/* /mnt/data/dbase && /bin/chown -R mysql:mysql /mnt/data/dbase 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during copying MySQL(MariaDB) data to /mnt/data/dbase directory ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed copying MySQL(MariaDB) data to /mnt/data/dbase directory ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Reconfiguring MySQL(MariaDB) data directory to /mnt/data/dbase" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Make backup of /etc/mysql/mariadb.conf.d/50-server.cnf file and reconfigure datadir to /mnt/data/dbase
/bin/cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.ORIGINAL && /bin/sed -i -e "s|/var/lib/mysql|/mnt/data/dbase|g" "/etc/mysql/mariadb.conf.d/50-server.cnf" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during reconfiguring MySQL(MariaDB) data to /mnt/data/dbase directory ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed reconfiguring MySQL(MariaDB) data to /mnt/data/dbase directory ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring MySQL(MariaDB) mode" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Make backup of /etc/mysql/my.cnf file and configure MySQL mode
/bin/cp /etc/mysql/my.cnf /etc/mysql/my.ORIGINAL && /bin/echo "[mysqld]
sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring MySQL(MariaDB) mode ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring MySQL(MariaDB) mode ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Starting MySQL(MariaDB) Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Start MySQL
/bin/systemctl start mysql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during starting MySQL(MariaDB) database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed starting MySQL(MariaDB) database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started creating Hermes SEG database and assigning user $MYSQL_HERMES_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create hermes database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE hermes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON hermes.* TO '$MYSQL_HERMES_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_HERMES_PASSWORD'; GRANT ALL ON hermes.* TO '$MYSQL_HERMES_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_HERMES_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Hermes SEG database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Hermes SEG database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started creating Syslog database and assigning user $MYSQL_SYSLOG_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Syslog database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE Syslog CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON Syslog.* TO '$MYSQL_SYSLOG_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_SYSLOG_PASSWORD'; GRANT ALL ON Syslog.* TO '$MYSQL_SYSLOG_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_SYSLOG_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Syslog database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Syslog database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started creating Opendmarc database and assigning user $MYSQL_OPENDMARC_USERNAME to it$" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Opendmarc database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE opendmarc CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON opendmarc.* TO '$MYSQL_OPENDMARC_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_OPENDMARC_PASSWORD'; GRANT ALL ON opendmarc.* TO '$MYSQL_OPENDMARC_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_OPENDMARC_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Opendmarc database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Opendmarc database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started creating Ciphermail database and assigning user $MYSQL_CIPHERMAIL_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create ciphermail database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE djigzo CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL ON djigzo.* TO '$MYSQL_CIPHERMAIL_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_CIPHERMAIL_PASSWORD'; GRANT ALL ON djigzo.* TO '$MYSQL_CIPHERMAIL_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_CIPHERMAIL_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Ciphermail database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Ciphermail database creation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started creating Hermes SEG Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create hermes database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="hermes" < $SCRIPTPATH/download/hermes/mysql_schema/hermes.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating Hemes SEG Database Schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating Hermes SEG Database Schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating Opendmarc database schema." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Opendmarc database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="opendmarc" < $SCRIPTPATH/download/hermes/mysql_schema/opendmarc.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating Opendmarc database schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating Opendmarc database schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing OpenJDK 8" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install OpenJDK
/usr/bin/apt-get install openjdk-8-jre openjdk-8-jre-headless -y && apt-get purge openjdk-11* -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during OpenJDK 8 installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing OpenJDK${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] STEP 12 OF 61. Started installing CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Commandbox
#/usr/bin/curl -fsSl https://downloads.ortussolutions.com/debs/gpg | sudo apt-key add - && echo "deb https://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list && /usr/bin/apt-get update && /usr/bin/apt-get install apt-transport-https commandbox -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error STEP 12 OF 61: Error $THEERROR, occurred during install of CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 12 OF 61. Completed install of CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi

#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] STEP 13 OF 61. Started configuring CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Initialize Commandbox
#/usr/local/bin/box exit
#Copy Lucee .jar files to /root/.CommandBox/engine/cfml/cli/lucee-server/bundles and Configure Commandbox
#cp $SCRIPTPATH/download/lucee/* /root/.CommandBox/engine/cfml/cli/lucee-server/bundles && /usr/local/bin/box version 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error STEP 13 OF 61: Error $THEERROR, occurred during configuring of CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 13 OF 61. Completed configuring of CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi


echo "==== WARNING ===="  | boxes -d stone -p a2v1
echo "${RED}During installation of rsyslog-mysql package, you will be prompted to configure database for rsylog-mysql with dbconfig-common. You must answer NO since this script will automatically install and configure the database${RESET}"

PS3='Do you wish to continue the installation of rsyslog-mysql package? (Selecting NO will stop installation)?: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            echo "[`date +%m/%d/%Y-%H:%M`] Starting installation of rsyslog-mysql package" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

            break
            ;;
        "No")

            echo "Exiting Hermes SEG 18.04 installation";
            exit
            ;;

        *) echo "invalid option $REPLY";;
    esac
done

#Install rsyslog-mysql package
/usr/bin/apt-get install rsyslog-mysql -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred installing rsyslog-mysql${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing rsyslog-mysql${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


echo "[`date +%m/%d/%Y-%H:%M`] Started configuring rsyslog-mysql." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Make backup /etc/rsyslog.d/mysql.conf and configure /etc/rsylog.d/mysql.conf
/bin/cp /etc/rsyslog.d/mysql.conf /etc/rsyslog.d/mysql.ORIGINAL &&  /bin/sed -i -e "s|rsyslog|${MYSQL_SYSLOG_USERNAME}|g" /etc/rsyslog.d/mysql.conf && /bin/sed -i -e 's|pwd=""|pwd="MYSQL_SYSLOG_PASSWORD"|g' /etc/rsyslog.d/mysql.conf && /bin/sed -i -e "s|MYSQL_SYSLOG_PASSWORD|${MYSQL_SYSLOG_PASSWORD}|g" /etc/rsyslog.d/mysql.conf 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring rsyslog-mysql${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring configuring rsyslog-mysql${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating rsyslog-mysql database schema." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create rsyslog-mysql database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="Syslog" < $SCRIPTPATH/download/hermes/mysql_schema/Syslog.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating rsyslog-mysql database schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating rsyslog-mysql database schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Restarting rsyslog-mysql." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Restart rsyslog-mysql
/bin/systemctl restart rsyslog 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring rsyslog-mysql${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring configuring rsyslog-mysql${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing dos2unix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install dos2unix
/usr/bin/apt-get install dos2unix -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during dos2unix installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing dos2unix${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG directory structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create /opt/hermes directories, copy files, make scripts executable and ensure scripts are in unix format (probably unnecessary)
/bin/mkdir -p /opt/hermes && \
/bin/cp -r $SCRIPTPATH/dirstructure/opt/hermes/* /opt/hermes && \
/bin/chmod +x /opt/hermes/scripts/* && \
/bin/chmod +x /opt/hermes/templates/*.sh && \
/usr/bin/dos2unix /opt/hermes/scripts/* && \
/usr/bin/dos2unix /opt/hermes/templates/*.sh && \
/bin/mkdir -p /mnt/hermesarchivetest && \
/bin/mkdir -p /mnt/hermesemail_archive && \
/bin/mkdir -p /mnt/archive && \
/bin/mkdir -p /mnt/backups && \
/bin/mkdir -p /mnt/hermesbackups && \
/bin/mkdir -p /mnt/hermesbackuptest && \
/bin/mkdir -p /mnt/hermesrestore && \
/bin/mkdir -p /mnt/hermesrestoretest 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating Hermes SEG directory structure${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating Hermes SEG directory structure${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG Web Directory Structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Hermes SEG Web Directory Structure
/bin/mkdir -p /var/www/html && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/admin/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/main/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/users/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/schedule/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/hermes-api/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/cfc/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/user-auth/ /var/www/html/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating Hermes SEG Web Directory Structure${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Creating Hermes SEG Web Directory Structure${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing cifs-utils, 7zip, sendemail and haveged" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install cifs-tuils, 7zip, sendemail and haveged
/usr/bin/apt-get install cifs-utils p7zip p7zip-rar sendemail haveged -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during cifs-utils, 7zip, sendemail and haveged installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing cifs-utils, 7zip, sendemail and haveged${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing GnuPG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install gnupg
/usr/bin/apt-get install gnupg -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during GnuPG installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing GnuPG${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating GnuPG directory and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#set GnuPG directory permissions
/bin/mkdir -p /opt/hermes/.gnupg && /bin/chmod -R go-rwx /opt/hermes/.gnupg/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Creating GnuPG directory and setting permissions${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Creating GnuPG directory and setting permissions${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing ClamAV" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install ClamAV
/usr/bin/apt-get install clamav clamav-daemon -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during ClamAV installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing ClamAV${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing and Configuring amavisd-new" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install and configure amavisd-new
/bin/echo $MAIL_NAME > /etc/mailname && /bin/hostname $MAIL_NAME && /usr/bin/apt-get install amavisd-new -y && /usr/sbin/adduser clamav amavis 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during amavisd-new installation and configuration${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed amavisd-new installation and configuration${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating amavisd-new directories and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create amavis directories under /mnt/data/ and set permissions
/bin/mkdir -p /mnt/data/amavis && \
/bin/mkdir -p /mnt/data/amavis/bad_header && \
/bin/mkdir -p /mnt/data/amavis/banned && \
/bin/mkdir -p /mnt/data/amavis/clean && \
/bin/mkdir -p /mnt/data/amavis/spam && \
/bin/mkdir -p /mnt/data/amavis/virus && \
/bin/chown -R amavis:amavis /mnt/data/amavis/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating amavisd-new directories and setting permissions${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating amavisd-new directories and setting permissions${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing spamassassin, razor and pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install spamassassin, razor pyzor
/usr/bin/apt-get install spamassassin razor pyzor -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during spamassassin, razor and pyzor installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing spamassassin, razor and pyzor${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Spamassassin" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Spamassassin
/bin/cp /etc/default/spamassassin /etc/default/spamassassin.ORIGINAL && \
/bin/sed -i -e "s|ENABLED=0|ENABLED=1|g" "/etc/default/spamassassin" && \
/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/spamassassin/local.cf /etc/spamassassin/local.cf && \
systemctl restart amavis 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring Spamassassin${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring Spamassassin${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Pyzor
/usr/bin/pyzor ping 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring Pyzor${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring Pyzor${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Razor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Razor
/bin/rm /etc/razor/razor-agent.conf && \
/usr/bin/razor-admin -home=/etc/razor -create && \
/usr/bin/razor-admin -home=/etc/razor -register 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring Razor${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring Razor${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing DCC" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install DCC
cd $SCRIPTPATH/download/dcc/dcc-2.3.167 && \
/bin/chmod +x configure && \
/bin/chmod +x ./autoconf/install-sh && \
./configure --with-uid=amavis && \
make && make install && \
/bin/chown -R amavis:amavis /var/dcc && \
/bin/ln -s /var/dcc/libexec/dccifd /usr/local/bin/dccifd 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing DCC${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing DCC${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring DCC and enabling in SA" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure DCC and enable in SA
/usr/local/bin/cdcc info && \
/bin/cp /etc/spamassassin/v310.pre /etc/spamassassin/v310.ORIGINAL && \
/bin/sed -i -e "s|#loadplugin Mail::SpamAssassin::Plugin::DCC|loadplugin Mail::SpamAssassin::Plugin::DCC|g" "/etc/spamassassin/v310.pre" && \
/usr/bin/spamassassin --lint 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring DCC and enabling in SA${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring DCC and enabling in SA${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


echo "==== WARNING ====" | boxes -d stone -p a2v1
echo "${RED}During installation of Postfix package, you will be prompted to select a mail server configuration. You must answer Internet Site. Additionally you will be asked for the System mail name. Leave the name at default and select Ok to continue ${RESET}"

PS3='Do you wish to continue the installation of Postfix? (Selecting NO will stop installation)?: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            echo "[`date +%m/%d/%Y-%H:%M`] Installing Postfix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
          break
            ;;
        "No")

            echo "${RED}Exiting Hermes SEG 18.04 installation ${RESET}";
            exit
            ;;

        *) echo "${RED}invalid option $REPLY ${RESET}";;
    esac
done

#Install Postfix
/usr/bin/apt-get install postfix postfix-mysql postfix-ldap postfix-pcre -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Installing Postfix${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing Postfix${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing Extractors" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install extractors
/usr/bin/apt-get install arj bzip2 cabextract cpio file gzip lhasa nomarch pax rar unrar unzip zip -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during extractors installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing extractors${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi



echo "[`date +%m/%d/%Y-%H:%M`] Configuring ClamAV Whitelist" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure ClamAV WhiteList
/bin/systemctl stop clamav-daemon && \
/bin/cp -r $SCRIPTPATH/download/clamav/local.ign2 /var/lib/clamav && \
/bin/cp -r $SCRIPTPATH/download/clamav/local.ign2.HERMES /var/lib/clamav && \
/bin/chown clamav:clamav /var/lib/clamav/local.ign2 && \
/bin/systemctl start clamav-daemon 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during ClamAV Whitelist${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed ClamAV Whitelist${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Removing any existing clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Remove any existing clamav-unofficial-sigs
/usr/bin/apt-get purge -y clamav-unofficial-sigs 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during removing any existing clamav-unofficial-sigs${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed removing any existing clamav-unofficial-sigs${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing and configuring extremeshok clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install and configure extremeshok clamav-unofficial-sigs
/bin/mkdir -p /usr/local/sbin/ && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/clamav-unofficial-sigs.sh -O /usr/local/sbin/clamav-unofficial-sigs.sh && \
/bin/mkdir -p /etc/clamav-unofficial-sigs/ && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/config/master.conf -O /etc/clamav-unofficial-sigs/master.conf && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/config/user.conf -O /etc/clamav-unofficial-sigs/user.conf && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/config/os/os.ubuntu.conf -O /etc/clamav-unofficial-sigs/os.conf && \
/bin/chmod +x /usr/local/sbin/clamav-unofficial-sigs.sh && \
/usr/local/sbin/clamav-unofficial-sigs.sh --install-logrotate && \
/usr/local/sbin/clamav-unofficial-sigs.sh --install-man && \
/usr/local/sbin/clamav-unofficial-sigs.sh --install-cron && \
/usr/local/sbin/clamav-unofficial-sigs.sh --force 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during extremeshok clamav-unofficial-sigs installation and configuration${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed extremeshok clamav-unofficial-sigs installation and configuration${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Copying Postfix and amavisd-new configuration files" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Copy Postfix and amavisd-new configuration files
/bin/cp -r $SCRIPTPATH/download/postfix/* /etc/postfix && \
/bin/cp -r $SCRIPTPATH/download/amavis/* /etc/amavis 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during copying Postfix and amavisd-new configuration files${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed copying Postfix and amavisd-new configuration files${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing SPF" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install SPF
/usr/bin/apt-get install postfix-policyd-spf-python -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during SPF installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing SPF${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install DKIM
/usr/bin/apt-get install opendkim opendkim-tools -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during DKIM installation${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing DKIM${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure DKIM
/usr/sbin/usermod -a -G opendkim postfix && \
/bin/cp /etc/opendkim.conf /etc/opendkim.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/opendkim/opendkim.conf /etc/opendkim.conf && \
/bin/systemctl restart opendkim 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during DKIM configuration${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring DKIM${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#CREATE SSL-CERT-SNAKEOIL SYMLINKS
echo "[`date +%m/%d/%Y-%H:%M`] Creating Self Signed Certificate and Key Symlinks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem /opt/hermes/ssl/ssl-cert-snakeoil_hermes.pem && /bin/ln -s /etc/ssl/private/ssl-cert-snakeoil.key /opt/hermes/ssl/ssl-cert-snakeoil_hermes.key 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Creating Self Signed Certificate and Key Symlinks${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Creating Self Signed Certificate and Key Symlinks${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#INSTALL NGINX
echo "[`date +%m/%d/%Y-%H:%M`] Installing Nginx" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/apt-get install nginx -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Installing Nginx${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Installing Nginx${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#CONFIGURE NGINX
echo "[`date +%m/%d/%Y-%H:%M`] Configuring Nginx" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/cp $SCRIPTPATH/download/etc/nginx/snippets/authelia.conf /etc/nginx/snippets/ && \
/bin/cp $SCRIPTPATH/download/etc/nginx/snippets/auth.conf /etc/nginx/snippets/ && \
/bin/sed -i -e "s|hermes_console_host|$THEIP|g" "/etc/nginx/snippets/auth.conf" && \
/bin/cp $SCRIPTPATH/download/etc/nginx/sites-available/hermes.conf /etc/nginx/sites-available/ && \
/bin/cp $SCRIPTPATH/download/etc/nginx/sites-available/hermes-ssl.conf /etc/nginx/sites-available/ && \
/bin/ln -s /etc/nginx/sites-available/hermes.conf /etc/nginx/sites-enabled/hermes.conf && \
/bin/ln -s /etc/nginx/sites-available/hermes-ssl.conf /etc/nginx/sites-enabled/hermes-ssl.conf && \
/bin/rm /etc/nginx/sites-available/default && \
/bin/rm /etc/nginx/sites-enabled/default 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] $ERR occurred while Configuring Nginx${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Configuring Nginx${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Install Certbot
echo "[`date +%m/%d/%Y-%H:%M`] Installing Certbot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/apt-get remove certbot -y && \
/usr/bin/snap install --classic certbot && \
/bin/ln -s /snap/bin/certbot /usr/bin/certbot && \
/usr/bin/certbot --version 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Installing Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Installing Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Configure Certbot
echo "[`date +%m/%d/%Y-%H:%M`] Configuring Certbot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/mkdir -p /etc/letsencrypt && \
/bin/cp $SCRIPTPATH/download/etc/letsencrypt/cli.ini /etc/letsencrypt/cli.ini 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] $ERR occurred while Configuring Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Configuring Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Create .well-known directory
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Creating .well-known directory for Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/mkdir -p /var/www/html/.well-known 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Creating .well-known directory for Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Creating .well-known directory for Certbot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Set Ciphermail download variables
CIPHERMAIL_DOWNLOAD_ADDRESS=https://www.deeztek.com/downloads/ciphermail
CIPHERMAIL_BACKEND=djigzo_4.6.2-0_all.deb
CIPHERMAIL_WEB=djigzo-web_4.6.2-0_all.deb

echo "[`date +%m/%d/%Y-%H:%M`] Started Downloading Ciphermail Back-End from $CIPHERMAIL_DOWNLOAD_ADDRESS" >> $SCRIPTPATH/install_log-$TIMESTAMP.log


#Download Ciphermail Back-End
/usr/bin/wget -O $SCRIPTPATH/$CIPHERMAIL_BACKEND --no-check-certificate $CIPHERMAIL_DOWNLOAD_ADDRESS/$CIPHERMAIL_BACKEND 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during dowload of Ciphermail Back-End${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed download of Ciphermail Back-End${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started Downloading Ciphermail Web GUI from $CIPHERMAIL_DOWNLOAD_ADDRESS" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Download Ciphermail Web GUI
/usr/bin/wget -O $SCRIPTPATH/$CIPHERMAIL_WEB --no-check-certificate $CIPHERMAIL_DOWNLOAD_ADDRESS/$CIPHERMAIL_WEB 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during dowload of Ciphermail Web GUI${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed download of Ciphermail Web GUI${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing Ciphermail Prerequisites" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Ciphermail prerequisites
/usr/bin/apt-get install ant ant-optional libsasl2-modules symlinks -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing Ciphermail prerequisites${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing Ciphermail prerequisites${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing Ciphermail Back-end" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Ciphermail back-end
/usr/bin/dpkg -i $SCRIPTPATH/$CIPHERMAIL_BACKEND && /bin/systemctl restart djigzo 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing Ciphermail back-end${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing Ciphermail back-end${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing Ciphermail Web-GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Ciphermail Web-GUI
/usr/bin/dpkg -i $SCRIPTPATH/$CIPHERMAIL_WEB 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing Ciphermail Web-GUI${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing Ciphermail Web-GUI${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing Apache Tomcat" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Tomcat
/usr/bin/apt-get install tomcat8 -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing Apache Tomcat${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing Apache Tomcat${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Apache Tomcat for ciphermail
/bin/cp /etc/default/tomcat8 /etc/default/tomcat8.ORIGINAL && \
/bin/echo "JAVA_OPTS=\"\$JAVA_OPTS -Ddjigzo-web.home=/usr/share/djigzo-web -Ddjigzo.home=/usr/share/djigzo\"" | sudo tee -a /etc/default/tomcat8 && \
/bin/echo "JAVA_OPTS=\"\$JAVA_OPTS -Djava.awt.headless=true -Xmx256M\"" | sudo tee -a /etc/default/tomcat8 && \
/bin/echo "<Context docBase=\"/usr/share/djigzo-web/djigzo.war\" />" | sudo tee /etc/tomcat8/Catalina/localhost/ciphermail.xml && \
/bin/echo "<Context docBase=\"/usr/share/djigzo-web/djigzo-portal.war\" />" | sudo tee /etc/tomcat8/Catalina/localhost/web.xml && \
/bin/cp /etc/tomcat8/server.xml /etc/tomcat8/server.ORIGINAL && \
/bin/cp /usr/share/djigzo-web/conf/tomcat/server.xml /etc/tomcat8/ && \
/bin/sed -i 's/unpackWARs="false"/unpackWARs="true"/' /etc/tomcat8/server.xml && \
/bin/chown tomcat8:djigzo /usr/share/djigzo-web/ssl/sslCertificate.p12 && \
/bin/systemctl restart tomcat8 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring Apache Tomcat for Ciphermail${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring Apache Tomcat for Ciphermail${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring MySQL(MariaDB) for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure MariaDB for Ciphermail
/bin/cp $SCRIPTPATH/download/ciphermail/ciphermail.cnf /etc/mysql/conf.d/ciphermail.cnf && \
/bin/systemctl restart mysql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring MySQL(MariaDB) for Ciphermail${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring MySQL(MariaDB) for Ciphermail${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Started creating Ciphermail Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Ciphermail database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="djigzo" < /usr/share/djigzo/conf/database/sql/djigzo.mysql.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating Ciphermail Database Schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating Ciphermail Database Schema${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Add Ciphermail Hermes SEG MySQL Customizations" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Add Ciphermail Hermes SEG MySQL Customizations
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="djigzo" < $SCRIPTPATH/download/ciphermail/ciphermail_hermes.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Adding Ciphermail Hermes SEG MySQL Customizations${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Adding Ciphermail Hermes SEG MySQL Customizations${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Ciphermail for MySQL(MariaDB)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Ciphermail for MySQL
/bin/echo "-Dciphermail.hibernate.database.type=mysql" | sudo tee -a /usr/share/djigzo/wrapper/wrapper-additional-parameters.conf && \
/bin/cp $SCRIPTPATH/dirstructure/opt/hermes/conf_files/hibernate.mysql.connection.HERMES /usr/share/djigzo/conf/database/hibernate.mysql.connection.xml && \
/bin/sed -i -e "s|DJIGZO-USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" && \
/bin/sed -i -e "s|DJIGZO-PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" && \
/bin/systemctl restart djigzo && /bin/systemctl restart tomcat8 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during configuring Ciphermail for MySQL(MariaDB)${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating Ciphermail for MySQL(MariaDB)${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#echo "[`date +%m/%d/%Y-%H:%M`] Started Downloading Lucee from https://cdn.lucee.org/" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Download Lucee
#/usr/bin/wget -O $SCRIPTPATH/lucee-5.2.9.031-pl0-linux-x64-installer.run --no-check-certificate https://cdn.lucee.org/lucee-5.2.9.031-pl0-linux-x64-installer.run 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during dowload of Lucee${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
#else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed download of Lucee${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi


#echo "[`date +%m/%d/%Y-%H:%M`] Installing Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Lucee
#/bin/sed -i -e "s|LUCEE-PASSWORD|$LUCEE_ADMIN_PASSWORD|g" "$SCRIPTPATH/download/lucee_install/lucee_install_options.txt" && \
#/bin/chmod +x $SCRIPTPATH/lucee-5.2.9.031-pl0-linux-x64-installer.run && \
#$SCRIPTPATH/lucee-5.2.9.031-pl0-linux-x64-installer.run --mode unattended --optionfile $SCRIPTPATH/download/lucee_install/lucee_install_options.txt && \
#/bin/sleep 30 && \
#Copy server.xml to Configure Hermes Web Root
#/bin/cp $SCRIPTPATH/download/lucee_install/server.xml /opt/lucee/tomcat/conf/server.xml 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing Lucee${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
3else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing Lucee${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi

#echo "[`date +%m/%d/%Y-%H:%M`] Restarting Lucee and Waiting 30 Seconds before proceeding" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#Restart Lucee to create context
#/bin/systemctl restart lucee_ctl && \
#/bin/sleep 30

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Restarting Lucee and Waiting 30 Seconds before proceeding${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
#else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Restarting Lucee and Waiting 30 Seconds before proceeding${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi


echo "[`date +%m/%d/%Y-%H:%M`] Installing CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Commandbox
/usr/bin/curl -fsSl https://downloads.ortussolutions.com/debs/gpg | sudo apt-key add - && echo "deb https://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list && /usr/bin/apt update && /usr/bin/apt install apt-transport-https commandbox -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Installing CommandBox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Instaling Commandbox${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Commandbox Server Parameters" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Commandbox
/bin/cp $SCRIPTPATH/download/commandbox/server.json /var/www/html/server.json 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Configuring CommandBox Server Parameters${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Configuring Commandbox Parameters${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


echo "[`date +%m/%d/%Y-%H:%M`] Configuring and Starting Hermes SEG Service" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Hermes SEG Service
/bin/cp $SCRIPTPATH/download/commandbox/hermesseg.service /etc/systemd/system/hermesseg.service && \
/bin/systemctl enable --now hermesseg.service && \
/bin/systemctl restart hermesseg.service 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Configuring and Starting Hermes SEG Service${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Configuring and Starting Hermes SEG Service${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#echo "[`date +%m/%d/%Y-%H:%M`] Copying Hermes SEG POP4 extension" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Copy Hermes SEG POP4 extension
#/bin/cp -r $SCRIPTPATH/dirstructure/opt/lucee/tomcat/webapps/ROOT/WEB-INF/lucee/components/hermes /opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-web/components 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during copying Hermes SEG POP4 extension${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
#else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed copying Hermes SEG POP4 extension${RESET}" >> $SCRIPTPATH/#install_log-$TIMESTAMP.log
#fi


echo "[`date +%m/%d/%Y-%H:%M`] Configuring Lucee Server and Web Administrator Password" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Lucee Server and Web Administrator Password
/bin/cp $SCRIPTPATH/download/commandbox/password.txt /opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-server/context/password.txt  && \
/bin/sed -i -e "s|LUCEE-PASSWORD|$LUCEE_ADMIN_PASSWORD|g" "/opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-server/context/password.txt" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, Configuring Lucee Server and Web Administrator Password${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Configuring Lucee Server and Web Administrator Password${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi



#echo "[`date +%m/%d/%Y-%H:%M`] Creating Lucee Mappings, Configuring Error Templates" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#create Lucee mappings and restart Lucee
#/bin/cp /opt/lucee/tomcat/lucee-server/context/lucee-server.xml /opt/lucee/tomcat/lucee-server/context/lucee-server.bak && \
#/bin/sed -i 's|<mapping archive="{lucee-config}/context/lucee-admin.lar" inspect-template="once" physical="{lucee-config}/context/admin" primary="physical" readonly="true" toplevel="true" virtual="/lucee/admin"/><mapping archive="{lucee-config}/context/lucee-doc.lar" inspect-template="once" primary="archive" readonly="true" toplevel="true" virtual="/lucee/doc"/><mapping inspect-template="once" physical="/var/www/html/schedule" primary="physical" readonly="false" toplevel="true" virtual="/schedule"/><mapping inspect-template="once" physical="/var/www/html/admin" primary="physical" readonly="false" toplevel="true" virtual="/admin"/><mapping inspect-template="once" physical="/var/www/html/users" primary="physical" readonly="false" toplevel="true" virtual="/users"/><mapping inspect-template="once" physical="/var/www/html/main" primary="physical" readonly="false" toplevel="true" virtual="/main"/>|&<mapping inspect-template="once" physical="/var/www/html/hermes-api" primary="physical" readonly="false" toplevel="true" virtual="/hermes-api"/><mapping inspect-template="once" physical="/var/www/html/user-auth" primary="physical" readonly="false" toplevel="true" virtual="/user-auth"/>|' /opt/lucee/tomcat/lucee-server/context/lucee-server.xml && \
#/bin/cp /var/www/html/WEB-INF/lucee/context/templates/error/error.cfm /var/www/html/WEB-INF/lucee/context/templates/error/error.HERMES && \
#/bin/cp /var/www/html/WEB-INF/lucee/context/templates/error/error-public.cfm /var/www/html/WEB-INF/lucee/context/templates/error/error-public.HERMES && \
#/bin/cp /var/www/html/WEB-INF/lucee/context/templates/error/error-public.HERMES /var/www/html/WEB-INF/lucee/context/templates/error/error.cfm && \
#/bin/systemctl restart lucee_ctl 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Creating Lucee Mappings, Configuring Error Templates and Restarting Lucee${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
3else
#echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Creating Lucee Mappings, Configuring Error Templates and Restarting Lucee${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Hermes SEG Application Datasources" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Hermes SEG Application Datasources
/bin/sed -i -e "s|HERMES_DATASOURCE_USERNAME|$MYSQL_HERMES_USERNAME|g" "/var/www/html/admin/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/admin/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/var/www/html/admin/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/var/www/html/admin/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_USERNAME|$MYSQL_SYSLOG_USERNAME|g" "/var/www/html/admin/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_PASSWORD|$MYSQL_SYSLOG_PASSWORD|g" "/var/www/html/admin/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_USERNAME|$MYSQL_HERMES_USERNAME|g" "/var/www/html/users/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/users/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/var/www/html/users/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/var/www/html/users/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_USERNAME|$MYSQL_SYSLOG_USERNAME|g" "/var/www/html/users/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_PASSWORD|$MYSQL_SYSLOG_PASSWORD|g" "/var/www/html/users/Application.cfc" \
/bin/sed -i -e "s|HERMES_DATASOURCE_USERNAME|$MYSQL_HERMES_USERNAME|g" "/var/www/html/schedule/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/schedule/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/var/www/html/schedule/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/var/www/html/schedule/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_USERNAME|$MYSQL_SYSLOG_USERNAME|g" "/var/www/html/schedule/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_PASSWORD|$MYSQL_SYSLOG_PASSWORD|g" "/var/www/html/schedule/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_USERNAME|$MYSQL_HERMES_USERNAME|g" "/var/www/html/main/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/main/Application.cfc" 
/bin/sed -i -e "s|HERMES_DATASOURCE_USERNAME|$MYSQL_HERMES_USERNAME|g" "/var/www/html/hermes-api/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/hermes-api/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/var/www/html/hermes-api/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/var/www/html/hermes-api/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_USERNAME|$MYSQL_SYSLOG_USERNAME|g" "/var/www/html/hermes-api/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_PASSWORD|$MYSQL_SYSLOG_PASSWORD|g" "/var/www/html/hermes-api/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_USERNAME|$MYSQL_HERMES_USERNAME|g" "/var/www/html/user-auth/Application.cfc" && \
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/user-auth/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/var/www/html/user-auth/Application.cfc" && \
/bin/sed -i -e "s|CIPHERMAIL_DATASOURCE_PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/var/www/html/user-auth/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_USERNAME|$MYSQL_SYSLOG_USERNAME|g" "/var/www/html/user-auth/Application.cfc" && \
/bin/sed -i -e "s|SYSLOG_DATASOURCE_PASSWORD|$MYSQL_SYSLOG_PASSWORD|g" "/var/www/html/user-auth/Application.cfc" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Configuring Hermes SEG Application Datasources${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Configuring Hermes SEG Application Datasources${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Installing and configuring Lynx browser" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install and configure Lynx browser
/usr/bin/apt-get install lynx -y && \
/bin/cp /etc/lynx/lynx.cfg /etc/lynx/lynx.ORIGINAL && \
/bin/sed -i -e "s|#FORCE_SSL_PROMPT:PROMPT|FORCE_SSL_PROMPT:YES|g" "/etc/lynx/lynx.cfg" && \
/bin/sed -i -e "s|ACCEPT_ALL_COOKIES:FALSE|ACCEPT_ALL_COOKIES:TRUE|g" "/etc/lynx/lynx.cfg" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during installing and configuring Lynx Browser${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed installing and configuring Lynx Browser${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG Scheduled Tasks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

# === CREATE SCHEDULED TASKS USING /ETC/CRON.D/ ====
/bin/cp $SCRIPTPATH/download/etc/cron.d/* /etc/cron.d/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log 

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during creating Hermes SEG Scheduled Tasks${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed creating Hermes SEG Scheduled Tasks${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#CREATE JWTSECRET RANDOM STRING
echo "[`date +%m/%d/%Y-%H:%M`] Creating JWT Secret Random String" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
JWTSECRET=`/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-20} | head -n 1` 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Creating JWT Secret Random String${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Creating JWT Secret Random String${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#UPDATE JWTSECRET IN DATABASE
echo "[`date +%m/%d/%Y-%H:%M`] Updating JWT Secret Random String in Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update parameters2 set value2 = '$JWTSECRET' where parameter = 'jwt_secret' and module='authelia'" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Updating JWT Secret Random String in Database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Updating JWT Secret Random String in Database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#CREATE SESSIONSECRET RANDOM STRING
echo "[`date +%m/%d/%Y-%H:%M`] Creating Session Secret Random String" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
SESSIONSECRET=`/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-20} | head -n 1` 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Creating Session Secret Random String${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Creating Session Secret Random String${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#UPDATE SESSION SECRET IN DATABASE
echo "[`date +%m/%d/%Y-%H:%M`] Updating Session Secret Random String in Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update parameters2 set value2 = '$SESSIONSECRET' where parameter = 'session.secret' and module='authelia'" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Updating Session Secret Random String in Database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Updating Session Secret Random String in Database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


#CREATE API KEY RANDOM STRING
echo "[`date +%m/%d/%Y-%H:%M`] Creating API Key Random String" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
APIKEY=`/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1` 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Creating API Key Random String${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Creating API Key Random String${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#UPDATE API KEY IN DATABASE
echo "[`date +%m/%d/%Y-%H:%M`] Updating API Key Random String in Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update api_tokens set token = '$APIKEY' where ip = '127.0.0.1' and system='1'" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Updating API Key Random String in Database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Updating API Key Random String in Database${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#INSTALL AUTHELIA
echo "[`date +%m/%d/%Y-%H:%M`] Installing Authelia" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/wget https://github.com/authelia/authelia/releases/download/v4.32.2/authelia_v4.32.2_amd64.deb  && \
/usr/bin/dpkg -i authelia_v4.32.2_amd64.deb 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Installing Authelia${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Installing Authelia${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Configure Authelia
echo "[`date +%m/%d/%Y-%H:%M`] Configuring Authelia" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/cp $SCRIPTPATH/download/etc/authelia/configuration.yml /etc/authelia/ && \
/bin/sed -i -e "s|hermes_jwt_secret|$JWTSECRET|g" "/etc/authelia/configuration.yml" && \
/bin/sed -i -e "s|hermes_session_secret|$SESSIONSECRET|g" "/etc/authelia/configuration.yml" && \
/bin/sed -i -e "s|hermes_access_control_domain|$THEIP|g" "/etc/authelia/configuration.yml" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Configuring Authelia${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Configuring Authelia ${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Configure Authelia Users
echo "[`date +%m/%d/%Y-%H:%M`] Configuring Authelia Users" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/cp $SCRIPTPATH/download/etc/authelia/users_database.yml /etc/authelia/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Configuring Authelia Users${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Configuring Authelia Users${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Configure Authelia Logrotate
echo "[`date +%m/%d/%Y-%H:%M`] Configuring Authelia Logrotate" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/cp $SCRIPTPATH/download/etc/logrotate.d/authelia /etc/logrotate.d/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Configuring Authelia Logrotate${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Configuring Authelia Logrotate${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#Enable Authelia Service
echo "[`date +%m/%d/%Y-%H:%M`] Enabling Authelia Service" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/bin/systemctl enable --now authelia 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Enabling Authelia Service${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Enabling Authelia Service${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#INSTALL REDIS
echo "[`date +%m/%d/%Y-%H:%M`] Installing Redis" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/bin/apt-get install redis-server -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred while Installing Redis${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Installing Redis${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


#CONFIGURE AND ENABLE FIREWALL
echo "[`date +%m/%d/%Y-%H:%M`] Configuring and Enabling Uncomplicated Firewall (UFW)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
/usr/sbin/ufw default deny incoming && \
/usr/sbin/ufw default allow outgoing && \
/usr/sbin/ufw allow 22/tcp && \
/usr/sbin/ufw allow 25/tcp && \
/usr/sbin/ufw allow 80/tcp && \
/usr/sbin/ufw allow 443/tcp && \
/usr/sbin/ufw allow 3306/tcp && \
/usr/sbin/ufw --force enable 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR occurred Configuring and Enabling Uncomplicated Firewall (UFW)${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Success Configuring and Enabling Uncomplicated Firewall (UFW)${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


echo "==== WARNING ====" | boxes -d stone -p a2v1
echo "${RED}During installation of Opendmarc, you will be prompted to configure database for Opendmarc with dbconfig-common. You must answer NO since this script has already configured the database"
echo "Additionally, as part of the Opendmarc installation, during libc6 configuration, you MAY be prompted to restart services during package upgrades without asking. You may answer YES to that prompt${RESET}"


PS3='Do you wish to continue the installation of Opendmarc? Selecting NO will stop installation): '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            echo "[`date +%m/%d/%Y-%H:%M`] Installing Opendmarc. Please note, errors will be generated during installation and configuration of Opendmarc. This is expected behavior with Ubuntu 18.04 and Opendmarc SHOULD work normally after reboot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

          break
            ;;
        "No")

            echo "Exiting Hermes SEG 18.04 installation";
            exit
            ;;

        *) echo "invalid option $REPLY";;
    esac
done

#Install Opendmarc 1.3.2-7 from focal main
/bin/cp /etc/apt/sources.list /etc/apt/sources.list.ORIGINAL && \
/bin/echo "deb http://mirrors.kernel.org/ubuntu focal main universe" | sudo tee -a /etc/apt/sources.list && \
/usr/bin/apt-get update && \
/usr/bin/apt-get install opendmarc -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred Installing Opendmarc. Please note, this is expected behavior with Ubuntu 18.04 and Opendmarc SHOULD work normally after reboot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#Do not exit on Opendmarc error since it's expected and SHOULD work after reboot
#exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed Installing Opendmarc${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


echo "[`date +%m/%d/%Y-%H:%M`] Configuring Opendmarc. Please note, an error will be generated during configuration of Opendmarc. This is expected behavior with Ubuntu 18.04 and Opendmarc SHOULD work normally after reboot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

/bin/cp /etc/apt/sources.list.ORIGINAL /etc/apt/sources.list && \
/usr/bin/apt-get update && \
/bin/cp /etc/opendmarc.conf /etc/opendmarc.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/opendmarc/opendmarc.conf /etc/opendmarc.conf && \
/bin/systemctl restart opendmarc 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during Opendmarc configuration. Please note, this is expected behavior with Ubuntu 18.04 and Opendmarc SHOULD work normally after reboot${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#Do not exit on Opendmarc error since it's expected and SHOULD work after reboot
#exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed configuring Opendmarc${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] Ensuring Hermes SEG permissions are set correctly" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Ensure permissions are set correctly
/bin/chown amavis:amavis /etc/postfix/relay_domains && \
/bin/chown -R amavis:amavis /mnt/data/amavis && \
/bin/chown -R amavis:amavis /opt/hermes/sa-bayes && \
/bin/chmod -R go-rwx /opt/hermes/.gnupg/ && \
/bin/chmod +x /opt/hermes/scripts/* && \
/bin/chmod +x /opt/hermes/templates/*.sh && \
/usr/bin/dos2unix /opt/hermes/scripts/* && \
/usr/bin/dos2unix /opt/hermes/templates/*.sh && \
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/ && \
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/keys/ && \
/bin/chown -R opendkim:opendkim /var/run/opendkim/ && \
/bin/chown -R opendmarc:opendmarc /var/run/opendmarc/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}[`date +%m/%d/%Y-%H:%M`] Error $THEERROR, occurred during ensuring Hermes SEG permissions are set correctly${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "${GREEN}[`date +%m/%d/%Y-%H:%M`] Completed ensuring Hermes SEG permissions are set correctly${RESET}" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


echo "[`date +%m/%d/%Y-%H:%M`] ==== FINISHED INSTALLATION ==== Ensure no errors were logged during installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

echo "FINISHED INSTALLATION. PLEASE REBOOT YOUR MACHINE!!" | boxes -d stone -p a2v1

echo "Take a look at the $SCRIPTPATH/install_log-$TIMESTAMP.log file for any errors"

echo "Using a browser, navigate to the following address https://SERVER_IP/admin/ where SERVER_IP is the ip address of your server and ensure you are able to login to the Hermes SEG Administration Console using 'admin' as the username and 'ChangeMe2!' as the default password"

echo "Ensure you take a look at the Hermes SEG Getting Started Guide located at https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/getting-started/" 









