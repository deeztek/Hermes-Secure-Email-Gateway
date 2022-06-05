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
apt-get install boxes -y > /dev/null 2>&1

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "${RED}Error $THEERROR, occurred Installing Boxes Prerequisite ${RESET}"
exit 1
else
echo "${GREEN}Completed Installing Boxes Prerequisite ${RESET}"
fi

echo "Installing Spinner Prerequisite"
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

PS3='Parts of this program are covered by the Hermes Secure Email Gateway Pro EULA which can be found at https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula. You must agree to the terms set forth by the EULA before continuing. Do you agree to the terms set forth by the EULA? (Selecting NO will stop the installation): '
options=("Yes - I Agree" "No - I do not agree")
select opt in "${options[@]}"
do
    case $opt in
        "Yes - I Agree")

            echo "${GREEN}Starting Hermes SEG Installation${RESET}" | boxes -d stone -p a2v1
            echo "During installation a ${RED}$SCRIPTPATH/install_log-$TIMESTAMP.log${RESET} log file will be created. It's highly recommended that you open a separate shell window and tail that file in order to view progress of the installation and/or any errors that may occur. Additionally, ensure that you note all the usernames and passwords you will be prompted to create"

            echo "[`date +%m/%d/%Y-%H:%M`] Starting Hermes SEG 18.04 Installation." >> $SCRIPTPATH/install_log-$TIMESTAMP.log
          break
            ;;
        "No - I do not agree")

            echo "Exiting Hermes SEG installation ";
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

source "$(pwd)/spinner.sh"

# test success
start_spinner 'sleeping for 2 secs...'
sleep 2
stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Installing MySQL(MariaDB) Server" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing MySQL(MariaDB) Server...'
sleep 1

#Install MariaDB
/usr/bin/apt-get install mariadb-server mariadb-client rsync -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring MySQL(MariaDB) Server" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring MySQL(MariaDB) Server...'
sleep 1

#configure MariaDB
/usr/bin/mysql -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/mysql -e "DELETE FROM mysql.user WHERE User='';" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/mysql -e "FLUSH PRIVILEGES;"  >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Stopping MySQL(MariaDB) Server" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Stopping MySQL(MariaDB) Server...'
sleep 1

#Stop MySQL
/bin/systemctl stop mysql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Copying MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Copying MySQL(MariaDB) data to /mnt/data/dbase directory...'
sleep 1

#Create /mnt/data/dbase directory, copy /var/lib/mysql/* to it and change owner to mysql
/bin/mkdir -p /mnt/data/dbase >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r /var/lib/mysql/* /mnt/data/dbase >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R mysql:mysql /mnt/data/dbase >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Reconfiguring MySQL(MariaDB) data directory to /mnt/data/dbase" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Reconfiguring MySQL(MariaDB) data directory to /mnt/data/dbase...'
sleep 1

#Make backup of /etc/mysql/mariadb.conf.d/50-server.cnf file and reconfigure datadir to /mnt/data/dbase
/bin/cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|/var/lib/mysql|/mnt/data/dbase|g" "/etc/mysql/mariadb.conf.d/50-server.cnf" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring MySQL(MariaDB) mode" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring MySQL(MariaDB) mode...'
sleep 1

#Make backup of /etc/mysql/my.cnf file and configure MySQL mode
/bin/cp /etc/mysql/my.cnf /etc/mysql/my.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/echo "[mysqld]
sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Starting MySQL(MariaDB) Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Starting MySQL(MariaDB) Database...'
sleep 1

#Start MySQL
/bin/systemctl start mysql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG database and assigning user $MYSQL_HERMES_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Hermes SEG database and assigning user...'
sleep 1

#Create hermes database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE hermes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON hermes.* TO '$MYSQL_HERMES_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_HERMES_PASSWORD'; GRANT ALL ON hermes.* TO '$MYSQL_HERMES_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_HERMES_PASSWORD'; FLUSH PRIVILEGES;" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Syslog database and assigning user $MYSQL_SYSLOG_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Syslog database...'
sleep 1

#Create Syslog database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE Syslog CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON Syslog.* TO '$MYSQL_SYSLOG_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_SYSLOG_PASSWORD'; GRANT ALL ON Syslog.* TO '$MYSQL_SYSLOG_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_SYSLOG_PASSWORD'; FLUSH PRIVILEGES;" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Opendmarc database and assigning user $MYSQL_OPENDMARC_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Opendmarc database...'
sleep 1

#Create Opendmarc database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE opendmarc CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON opendmarc.* TO '$MYSQL_OPENDMARC_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_OPENDMARC_PASSWORD'; GRANT ALL ON opendmarc.* TO '$MYSQL_OPENDMARC_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_OPENDMARC_PASSWORD'; FLUSH PRIVILEGES;" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Ciphermail database and assigning user $MYSQL_CIPHERMAIL_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Ciphermail database...'
sleep 1

#Create ciphermail database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE djigzo CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL ON djigzo.* TO '$MYSQL_CIPHERMAIL_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_CIPHERMAIL_PASSWORD'; GRANT ALL ON djigzo.* TO '$MYSQL_CIPHERMAIL_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_CIPHERMAIL_PASSWORD'; FLUSH PRIVILEGES;" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Hermes SEG Database Schema...'
sleep 1

#Create hermes database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="hermes" < $SCRIPTPATH/download/hermes/mysql_schema/hermes.sql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Opendmarc database schema." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Opendmarc database schema...'
sleep 1

#Create Opendmarc database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="opendmarc" < $SCRIPTPATH/download/hermes/mysql_schema/opendmarc.sql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing OpenJDK 8" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing OpenJDK 8...'
sleep 1

#install OpenJDK
/usr/bin/apt-get install openjdk-8-jre openjdk-8-jre-headless -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
apt-get purge openjdk-11* -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


start_spinner 'Installing rsyslog-mysql package...'
sleep 1

#Install rsyslog-mysql package
#export DEBIAN_FRONTEND=noninteractive >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
#Skip dbconfig-install
#debconf-get-selections | grep rsyslog-mysql
cat << EOF | sudo debconf-set-selections
rsyslog-mysql   rsyslog-mysql/dbconfig-install  boolean false
EOF
/usr/bin/apt-get install rsyslog-mysql -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1


stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring rsyslog-mysql." >> $SCRIPTPATH/install_log-$TIMESTAMP.log


start_spinner 'Configuring rsyslog-mysql...'
sleep 1

#Make backup /etc/rsyslog.d/mysql.conf and configure /etc/rsylog.d/mysql.conf
/bin/cp /etc/rsyslog.d/mysql.conf /etc/rsyslog.d/mysql.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|rsyslog|${MYSQL_SYSLOG_USERNAME}|g" /etc/rsyslog.d/mysql.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e 's|pwd=""|pwd="MYSQL_SYSLOG_PASSWORD"|g' /etc/rsyslog.d/mysql.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|MYSQL_SYSLOG_PASSWORD|${MYSQL_SYSLOG_PASSWORD}|g" /etc/rsyslog.d/mysql.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating rsyslog-mysql database schema." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating rsyslog-mysql database schema...'
sleep 1

#Create rsyslog-mysql database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="Syslog" < $SCRIPTPATH/download/hermes/mysql_schema/Syslog.sql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Restarting rsyslog-mysql." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Restarting rsyslog-mysql...'
sleep 1

#Restart rsyslog-mysql
/bin/systemctl restart rsyslog >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing dos2unix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing dos2unix...'
sleep 1

#install dos2unix
/usr/bin/apt-get install dos2unix -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG directory structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Hermes SEG directory structure...'
sleep 1

#Create /opt/hermes directories, copy files, make scripts executable and ensure scripts are in unix format (probably unnecessary)
/bin/mkdir -p /opt/hermes >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/opt/hermes/* /opt/hermes >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x /opt/hermes/scripts/* >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x /opt/hermes/templates/*.sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/dos2unix /opt/hermes/scripts/* >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/dos2unix /opt/hermes/templates/*.sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/hermesarchivetest >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/hermesemail_archive >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/archive >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/backups >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/hermesbackups >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/hermesbackuptest >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/hermesrestore >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/hermesrestoretest >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1


stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG Web Directory Structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Hermes SEG Web Directory Structure...'
sleep 1

#Create Hermes SEG Web Directory Structure
/bin/mkdir -p /var/www/html >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/admin/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/main/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/users/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/schedule/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/hermes-api/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/cfc/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/plugins/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/dist/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/user-auth/ /var/www/html/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing cifs-utils, 7zip, sendemail and haveged" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing cifs-utils, 7zip, sendemail and haveged...'
sleep 1

#install cifs-tuils, 7zip, sendemail and haveged
/usr/bin/apt-get install cifs-utils p7zip p7zip-rar sendemail haveged -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing GnuPG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing GnuPG...'
sleep 1

#install gnupg
/usr/bin/apt-get install gnupg -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating GnuPG directory and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating GnuPG directory and setting permissions...'
sleep 1

#set GnuPG directory permissions
/bin/mkdir -p /opt/hermes/.gnupg >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod -R go-rwx /opt/hermes/.gnupg/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing ClamAV" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing ClamAV...'
sleep 1

#install ClamAV
/usr/bin/apt-get install clamav clamav-daemon -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing and Configuring amavisd-new" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing and Configuring amavisd-new...'
sleep 1

#Install and configure amavisd-new
/bin/echo $MAIL_NAME > /etc/mailname >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/hostname $MAIL_NAME >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/apt-get install amavisd-new -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/adduser clamav amavis >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating amavisd-new directories and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating amavisd-new directories and setting permissions...'
sleep 1

#Create amavis directories under /mnt/data/ and set permissions
/bin/mkdir -p /mnt/data/amavis >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/data/amavis/bad_header >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/data/amavis/banned >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/data/amavis/clean >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/data/amavis/spam >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /mnt/data/amavis/virus >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R amavis:amavis /mnt/data/amavis/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing spamassassin, razor and pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing spamassassin, razor and pyzor...'
sleep 1

#install spamassassin, razor pyzor
/usr/bin/apt-get install spamassassin razor pyzor -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Spamassassin" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Spamassassin...'
sleep 1

#Configure Spamassassin
/bin/cp /etc/default/spamassassin /etc/default/spamassassin.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|ENABLED=0|ENABLED=1|g" "/etc/default/spamassassin" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/download/spamassassin/local.cf /etc/spamassassin/local.cf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
systemctl restart amavis >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Pyzor...'
sleep 1

#Configure Pyzor
/usr/bin/pyzor ping >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Razor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Razor...'
sleep 1

#Configure Razor
/bin/rm /etc/razor/razor-agent.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/razor-admin -home=/etc/razor -create >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/razor-admin -home=/etc/razor -register >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing DCC" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing DCC...'
sleep 1

#Install DCC
cd $SCRIPTPATH/download/dcc/dcc-2.3.167 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x configure >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x ./autoconf/install-sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
./configure --with-uid=amavis >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
make >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
make install >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R amavis:amavis /var/dcc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/ln -s /var/dcc/libexec/dccifd /usr/local/bin/dccifd >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring DCC and enabling in SA" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring DCC and enabling in SA...'
sleep 1

#Configure DCC and enable in SA
/usr/local/bin/cdcc info >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp /etc/spamassassin/v310.pre /etc/spamassassin/v310.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|#loadplugin Mail::SpamAssassin::Plugin::DCC|loadplugin Mail::SpamAssassin::Plugin::DCC|g" "/etc/spamassassin/v310.pre" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/spamassassin --lint >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Postfix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Postfix...'
sleep 1

#Install Postfix
#export DEBIAN_FRONTEND=noninteractive >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
#Skip main_mailer_type and mailname prompts
#debconf-get-selections | grep postfix
cat << EOF | sudo debconf-set-selections
postfix postfix/main_mailer_type        select  Internet Site
postfix postfix/mailname        string  $MAIL_NAME
EOF
/usr/bin/apt-get install postfix postfix-mysql postfix-ldap postfix-pcre -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Extractors" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Extractors...'
sleep 1

#install extractors
/usr/bin/apt-get install arj bzip2 cabextract cpio file gzip lhasa nomarch pax rar unrar unzip zip -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring ClamAV Whitelist" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring ClamAV Whitelist...'
sleep 1

#Configure ClamAV WhiteList
/bin/systemctl stop clamav-daemon >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/download/clamav/local.ign2 /var/lib/clamav >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/download/clamav/local.ign2.HERMES /var/lib/clamav >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown clamav:clamav /var/lib/clamav/local.ign2 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl start clamav-daemon >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Removing any existing clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Removing any existing clamav-unofficial-sigs...'
sleep 1

#Remove any existing clamav-unofficial-sigs
/usr/bin/apt-get purge -y clamav-unofficial-sigs >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing and configuring extremeshok clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing and configuring extremeshok clamav-unofficial-sigs...'
sleep 1

#Install and configure extremeshok clamav-unofficial-sigs
/bin/mkdir -p /usr/local/sbin/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/clamav-unofficial-sigs.sh -O /usr/local/sbin/clamav-unofficial-sigs.sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/mkdir -p /etc/clamav-unofficial-sigs/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/config/master.conf -O /etc/clamav-unofficial-sigs/master.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/config/user.conf -O /etc/clamav-unofficial-sigs/user.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/wget https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/master/config/os/os.ubuntu.conf -O /etc/clamav-unofficial-sigs/os.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x /usr/local/sbin/clamav-unofficial-sigs.sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/local/sbin/clamav-unofficial-sigs.sh --install-logrotate >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/local/sbin/clamav-unofficial-sigs.sh --install-man >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/local/sbin/clamav-unofficial-sigs.sh --install-cron >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/local/sbin/clamav-unofficial-sigs.sh --force >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Copying Postfix and amavisd-new configuration files" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Copying Postfix and amavisd-new configuration files...'
sleep 1

#Copy Postfix and amavisd-new configuration files
/bin/cp -r $SCRIPTPATH/download/postfix/* /etc/postfix >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp -r $SCRIPTPATH/download/amavis/* /etc/amavis >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing SPF" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing SPF...'
sleep 1

#Install SPF
/usr/bin/apt-get install postfix-policyd-spf-python -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing DKIM...'
sleep 1

#Install DKIM
/usr/bin/apt-get install opendkim opendkim-tools -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring DKIM...'
sleep 1

#Configure DKIM
/usr/sbin/usermod -a -G opendkim postfix >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp /etc/opendkim.conf /etc/opendkim.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/download/opendkim/opendkim.conf /etc/opendkim.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl restart opendkim >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing DMARC" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing DMARC...'
sleep 1


#Install Opendmarc 1.4.2 from source

apt-get install -y autoconf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
apt-get install libtool -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
apt-get install libmilter-dev -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
apt-get install -y libspf2-dev >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
apt-get install -y libswitch-perl >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
apt-get install -y libjson-perl >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
addgroup opendmarc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
adduser --system --disabled-password --shell /sbin/nologin --no-create-home --home /var/run/opendmarc --group opendmarc --gecos opendmarc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
cd $SCRIPTPATH/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
git clone https://github.com/trusteddomainproject/OpenDMARC.git >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
cd $SCRIPTPATH/OpenDMARC >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
autoreconf -v -i >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
./configure --with-spf --with-spf2-include=/usr/include/spf2 --with-spf2-lib=/usr/lib/ --with-sql-backend --sysconfdir=/etc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
make install >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
install -d -o opendmarc -g opendmarc /etc/opendmarc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
make >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc /usr/sbin/opendmarc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc-import /usr/sbin/opendmarc-import >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc-reports /usr/sbin/opendmarc-reports >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc-expire /usr/sbin/opendmarc-expire >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc-check /usr/sbin/opendmarc-check >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc-importstats /usr/sbin/opendmarc-importstats >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/sbin/opendmarc-params /usr/sbin/opendmarc-params >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
ln -s /usr/local/lib/libopendmarc.so.2.0.3 /usr/lib/libopendmarc.so.2 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
cp $SCRIPTPATH/download/etc/opendmarc/opendmarc.conf /etc/opendmarc/opendmarc.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
dos2unix /etc/opendmarc/opendmarc.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
touch /etc/opendmarc/whitelist.domains >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
chown -R opendmarc:opendmarc /etc/opendmarc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
cp $SCRIPTPATH/download/lib/systemd/system/opendmarc.service /lib/systemd/system/opendmarc.service >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
systemctl unmask opendmarc >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl enable --now opendmarc.service >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Self Signed Certificate and Key Symlinks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Self Signed Certificate and Key Symlinks...'
sleep 1

#CREATE SSL-CERT-SNAKEOIL SYMLINKS
/bin/ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem /opt/hermes/ssl/ssl-cert-snakeoil_hermes.pem >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/ln -s /etc/ssl/private/ssl-cert-snakeoil.key /opt/hermes/ssl/ssl-cert-snakeoil_hermes.key >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

#INSTALL NGINX
echo "[`date +%m/%d/%Y-%H:%M`] Installing Nginx" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Nginx...'
sleep 1

/usr/bin/apt-get install nginx -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1


stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Nginx" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Nginx...'
sleep 1

#CONFIGURE NGINX
/bin/cp $SCRIPTPATH/download/etc/nginx/snippets/authelia.conf /etc/nginx/snippets/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/download/etc/nginx/snippets/auth.conf /etc/nginx/snippets/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|hermes_console_host|$THEIP|g" "/etc/nginx/snippets/auth.conf" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/download/etc/nginx/sites-available/hermes.conf /etc/nginx/sites-available/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/download/etc/nginx/sites-available/hermes-ssl.conf /etc/nginx/sites-available/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/ln -s /etc/nginx/sites-available/hermes.conf /etc/nginx/sites-enabled/hermes.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/ln -s /etc/nginx/sites-available/hermes-ssl.conf /etc/nginx/sites-enabled/hermes-ssl.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/rm /etc/nginx/sites-available/default >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/rm /etc/nginx/sites-enabled/default >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Installing Certbot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Certbot...'
sleep 1

#Install Certbot
/usr/bin/apt-get remove certbot -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/snap install --classic certbot >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/ln -s /snap/bin/certbot /usr/bin/certbot >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/certbot --version >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Certbot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Certbot...'
sleep 1

#Configure Certbot
/bin/mkdir -p /etc/letsencrypt >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/download/etc/letsencrypt/cli.ini /etc/letsencrypt/cli.ini >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Creating .well-known directory for Certbot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating .well-known directory for Certbot..'
sleep 1

#Create .well-known directory
/bin/mkdir -p /var/www/html/.well-known >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

#Set Ciphermail download variables
CIPHERMAIL_DOWNLOAD_ADDRESS=https://www.deeztek.com/downloads/ciphermail
CIPHERMAIL_BACKEND=djigzo_4.6.2-0_all.deb
CIPHERMAIL_WEB=djigzo-web_4.6.2-0_all.deb

echo "[`date +%m/%d/%Y-%H:%M`] Started Downloading Ciphermail Back-End from $CIPHERMAIL_DOWNLOAD_ADDRESS" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Started Downloading Ciphermail Back-End...'
sleep 1

#Download Ciphermail Back-End
/usr/bin/wget -O $SCRIPTPATH/$CIPHERMAIL_BACKEND --no-check-certificate $CIPHERMAIL_DOWNLOAD_ADDRESS/$CIPHERMAIL_BACKEND >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Started Downloading Ciphermail Web GUI from $CIPHERMAIL_DOWNLOAD_ADDRESS" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Started Downloading Ciphermail Web GUI...'
sleep 1

#Download Ciphermail Web GUI
/usr/bin/wget -O $SCRIPTPATH/$CIPHERMAIL_WEB --no-check-certificate $CIPHERMAIL_DOWNLOAD_ADDRESS/$CIPHERMAIL_WEB >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Ciphermail Prerequisites" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Ciphermail Prerequisites...'
sleep 1

#Install Ciphermail prerequisites
/usr/bin/apt-get install ant ant-optional libsasl2-modules symlinks -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Ciphermail Back-end" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Ciphermail Back-end...'
sleep 1

#Install Ciphermail back-end
/usr/bin/dpkg -i $SCRIPTPATH/$CIPHERMAIL_BACKEND >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl restart djigzo >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Ciphermail Web-GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Ciphermail Web-GUI...'
sleep 1

#Install Ciphermail Web-GUI
/usr/bin/dpkg -i $SCRIPTPATH/$CIPHERMAIL_WEB >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing Apache Tomcat" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Apache Tomcat...'
sleep 1

#Install Tomcat
/usr/bin/apt-get install tomcat8 -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Apache Tomcat for Ciphermail...'
sleep 1

#Configure Apache Tomcat for ciphermail
/bin/cp /etc/default/tomcat8 /etc/default/tomcat8.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/echo "JAVA_OPTS=\"\$JAVA_OPTS -Ddjigzo-web.home=/usr/share/djigzo-web -Ddjigzo.home=/usr/share/djigzo\"" | sudo tee -a /etc/default/tomcat8 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/echo "JAVA_OPTS=\"\$JAVA_OPTS -Djava.awt.headless=true -Xmx256M\"" | sudo tee -a /etc/default/tomcat8 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/echo "<Context docBase=\"/usr/share/djigzo-web/djigzo.war\" />" | sudo tee /etc/tomcat8/Catalina/localhost/ciphermail.xml >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/echo "<Context docBase=\"/usr/share/djigzo-web/djigzo-portal.war\" />" | sudo tee /etc/tomcat8/Catalina/localhost/web.xml >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp /etc/tomcat8/server.xml /etc/tomcat8/server.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp /usr/share/djigzo-web/conf/tomcat/server.xml /etc/tomcat8/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i 's/unpackWARs="false"/unpackWARs="true"/' /etc/tomcat8/server.xml >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown tomcat8:djigzo /usr/share/djigzo-web/ssl/sslCertificate.p12 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl restart tomcat8 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring MySQL(MariaDB) for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring MySQL(MariaDB) for Ciphermail...'
sleep 1

#Configure MariaDB for Ciphermail
/bin/cp $SCRIPTPATH/download/ciphermail/ciphermail.cnf /etc/mysql/conf.d/ciphermail.cnf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl restart mysql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Ciphermail Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Ciphermail Database Schema...'
sleep 1

#Create Ciphermail database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="djigzo" < /usr/share/djigzo/conf/database/sql/djigzo.mysql.sql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Adding Ciphermail Hermes SEG MySQL Customizations" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Adding Ciphermail Hermes SEG MySQL Customizations...'
sleep 1

#Adding Ciphermail Hermes SEG MySQL Customizations
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="djigzo" < $SCRIPTPATH/download/ciphermail/ciphermail_hermes.sql >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Ciphermail for MySQL(MariaDB)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Ciphermail for MySQL(MariaDB)...'
sleep 1

#Configure Ciphermail for MySQL
/bin/echo "-Dciphermail.hibernate.database.type=mysql" | sudo tee -a /usr/share/djigzo/wrapper/wrapper-additional-parameters.conf >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp $SCRIPTPATH/dirstructure/opt/hermes/conf_files/hibernate.mysql.connection.HERMES /usr/share/djigzo/conf/database/hibernate.mysql.connection.xml >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|DJIGZO-USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|DJIGZO-PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl restart djigzo && /bin/systemctl restart tomcat8 >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Installing CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing CommandBox...'
sleep 1

#Install Commandbox
/usr/bin/curl -fsSl https://downloads.ortussolutions.com/debs/gpg | sudo apt-key add - >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
echo "deb https://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/apt-get update >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/apt-get install apt-transport-https commandbox -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Commandbox Server Parameters" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Commandbox Server Parameters...'
sleep 1

#Configure Commandbox
/bin/cp $SCRIPTPATH/download/commandbox/server.json /var/www/html/server.json >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring and Starting Hermes SEG Service" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring and Starting Hermes SEG Service...'
sleep 1

#Configure Hermes SEG Service
/bin/cp $SCRIPTPATH/download/commandbox/hermesseg.service /etc/systemd/system/hermesseg.service >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl enable --now hermesseg.service >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/systemctl restart hermesseg.service >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Commandbox Lucee Server and Web Administrator Password" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Commandbox Lucee Server and Web Administrator Password...'
sleep 1

#Configure Lucee Server and Web Administrator Password
/bin/cp $SCRIPTPATH/download/commandbox/password.txt /opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-server/context/password.txt  >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|LUCEE-PASSWORD|$LUCEE_ADMIN_PASSWORD|g" "/opt/CommandBox/web-contexts/wwwroot-hermesseg/WEB-INF/lucee-server/context/password.txt" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring Hermes SEG Application Datasource Credentials" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Hermes SEG Application Datasource Credentials...'
sleep 1

/usr/bin/touch /opt/hermes/creds/hermes_username >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/hermes_password >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/syslog_username >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/syslog_password >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/ciphermail_username >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/ciphermail_password >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/opendmarc_username >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/touch /opt/hermes/creds/opendmarc_password >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
echo "$MYSQL_HERMES_USERNAME" > /opt/hermes/creds/hermes_username && \
echo "$MYSQL_HERMES_PASSWORD" > /opt/hermes/creds/hermes_password && \
echo "$MYSQL_SYSLOG_USERNAME" > /opt/hermes/creds/syslog_username && \
echo "$MYSQL_SYSLOG_PASSWORD" > /opt/hermes/creds/syslog_password && \
echo "$MYSQL_CIPHERMAIL_USERNAME" > /opt/hermes/creds/ciphermail_username && \
echo "$MYSQL_CIPHERMAIL_PASSWORD" > /opt/hermes/creds/ciphermail_password && \
echo "$MYSQL_OPENDMARC_USERNAME" > /opt/hermes/creds/opendmarc_username && \
echo "$MYSQL_OPENDMARC_PASSWORD" > /opt/hermes/creds/opendmarc_password

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Installing and configuring Lynx browser" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing and configuring Lynx browser...'
sleep 1

#Install and configure Lynx browser
/usr/bin/apt-get install lynx -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/cp /etc/lynx/lynx.cfg /etc/lynx/lynx.ORIGINAL >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|#FORCE_SSL_PROMPT:PROMPT|FORCE_SSL_PROMPT:YES|g" "/etc/lynx/lynx.cfg" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|ACCEPT_ALL_COOKIES:FALSE|ACCEPT_ALL_COOKIES:TRUE|g" "/etc/lynx/lynx.cfg" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Creating Hermes SEG Scheduled Tasks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Hermes SEG Scheduled Tasks...'
sleep 1

# === CREATE SCHEDULED TASKS USING /ETC/CRON.D/ ====
/bin/cp $SCRIPTPATH/download/etc/cron.d/* /etc/cron.d/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 

stop_spinner $?

#CREATE JWTSECRET RANDOM STRING
echo "[`date +%m/%d/%Y-%H:%M`] Creating JWT Secret Random String" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating JWT Secret Random String...'
sleep 1

JWTSECRET=`/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-20} | head -n 1` >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Updating JWT Secret Random String in Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Updating JWT Secret Random String in Database...'
sleep 1

#UPDATE JWTSECRET IN DATABASE
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update parameters2 set value2 = '$JWTSECRET' where parameter = 'jwt_secret' and module='authelia'" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Creating Session Secret Random String" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating Session Secret Random String...'
sleep 1

#CREATE SESSIONSECRET RANDOM STRING
SESSIONSECRET=`/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-20} | head -n 1` >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Updating Session Secret Random String in Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Updating Session Secret Random String in Database...'
sleep 1

#UPDATE SESSION SECRET IN DATABASE
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update parameters2 set value2 = '$SESSIONSECRET' where parameter = 'session.secret' and module='authelia'" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Creating API Key Random String" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Creating API Key Random String...'
sleep 1

#CREATE API KEY RANDOM STRING
APIKEY=`/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1` >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Updating API Key Random String in Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Updating API Key Random String in Database...'
sleep 1

#UPDATE API KEY IN DATABASE
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update api_tokens set token = '$APIKEY' where ip = '127.0.0.1' and system='1'" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Entering Current System IP Address in Console" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Entering Current System IP Address in Console...'
sleep 1

#UPDATE IP ADDRESS IN CONSOLE
/usr/bin/mysql -h localhost -u $MYSQL_HERMES_USERNAME -p$MYSQL_HERMES_PASSWORD -e "use hermes; update parameters2 set value2 = '$THEIP', active='1', applied='2' where parameter = 'console.host' and module='console'" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Updating Ciphermail Web Portal Address" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Updating Ciphermail Web Portal Address...'
sleep 1

#UPDATE CIPHERMAIL WEB PORTAL ADDRESS
cd /usr/share/djigzo >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.portal.baseURL --value https://$THEIP/web/portal --global >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Installing Authelia" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Authelia...'
sleep 1

#INSTALL AUTHELIA
/usr/bin/wget https://github.com/authelia/authelia/releases/download/v4.32.2/authelia_v4.32.2_amd64.deb  >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/dpkg -i authelia_v4.32.2_amd64.deb >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Configuring Authelia" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Authelia...'
sleep 1

#Configure Authelia
/bin/cp $SCRIPTPATH/download/etc/authelia/configuration.yml /etc/authelia/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|hermes_jwt_secret|$JWTSECRET|g" "/etc/authelia/configuration.yml" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|hermes_session_secret|$SESSIONSECRET|g" "/etc/authelia/configuration.yml" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/sed -i -e "s|hermes_access_control_domain|$THEIP|g" "/etc/authelia/configuration.yml" >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1


stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Configuring Authelia Users" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Authelia Users...'
sleep 1

#Configure Authelia Users
/bin/cp $SCRIPTPATH/download/etc/authelia/users_database.yml /etc/authelia/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Configuring Authelia Logrotate" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring Authelia Logrotate...'
sleep 1

#Configure Authelia Logrotate
/bin/cp $SCRIPTPATH/download/etc/logrotate.d/authelia /etc/logrotate.d/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod 0644 /etc/logrotate.d/authelia >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Enabling Authelia Service" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Enabling Authelia Service...'
sleep 1

#Enable Authelia Service
/bin/systemctl enable --now authelia >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Installing Redis" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Installing Redis...'
sleep 1

#INSTALL REDIS
/usr/bin/apt-get install redis-server -y >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?

echo "[`date +%m/%d/%Y-%H:%M`] Configuring and Enabling Uncomplicated Firewall (UFW)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Configuring and Enabling Uncomplicated Firewall (UFW)...'
sleep 1

#CONFIGURE AND ENABLE FIREWALL
/usr/sbin/ufw default deny incoming >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw default allow outgoing >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw allow 22/tcp >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw allow 25/tcp >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw allow 80/tcp >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw allow 443/tcp >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw allow 3306/tcp >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/sbin/ufw --force enable >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] Ensuring Hermes SEG permissions are set correctly" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

start_spinner 'Ensuring Hermes SEG permissions are set correctly...'
sleep 1

#Ensure permissions are set correctly
/bin/chown amavis:amavis /etc/postfix/relay_domains >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R amavis:amavis /mnt/data/amavis >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R amavis:amavis /opt/hermes/sa-bayes >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod -R go-rwx /opt/hermes/.gnupg/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x /opt/hermes/scripts/* >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chmod +x /opt/hermes/templates/*.sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/dos2unix /opt/hermes/scripts/* >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/usr/bin/dos2unix /opt/hermes/templates/*.sh >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R opendkim:opendkim /opt/hermes/dkim/keys/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1 && \
/bin/chown -R opendkim:opendkim /var/run/opendkim/ >> $SCRIPTPATH/install_log-$TIMESTAMP.log 2>&1

stop_spinner $?


echo "[`date +%m/%d/%Y-%H:%M`] ==== FINISHED INSTALLATION ==== Ensure no errors were logged during installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

echo "${GREEN}FINISHED INSTALLATION. PLEASE REBOOT YOUR MACHINE!!${RESET}" | boxes -d stone -p a2v1


echo "Take a look at the ${GREEN}$SCRIPTPATH/install_log-$TIMESTAMP.log${RESET} file for any errors"

echo "Using a browser, navigate to the following address ${GREEN}https://SERVER_IP/admin/${RESET} where SERVER_IP is the ip address of your server and ensure you are able to login to the Hermes SEG Administration Console using 'admin' as the username and 'ChangeMe2!' as the default password"

echo "Ensure you take a look at the Hermes SEG Getting Started Guide located at ${GREEN}https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/getting-started/${RESET}" 









