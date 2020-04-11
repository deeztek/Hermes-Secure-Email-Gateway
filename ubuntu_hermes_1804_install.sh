#!/bin/bash

#The script below assumes you have a fully installed and updated Ubuntu 18.04 server and you have created /mnt/data as outlined below. 
#The Configure /mnt/data partition directions below assumes you have a 250GB secondary drive which you will partition, format and mount as /mnt/data. Technically a secondary drive for the /mnt/data directory is not a requirement but it's highly recommended for performance reasons. If you don't wish to use a secondary drive for the /mnt/data directory, simply create a /mnt/data directory in your system and run this script.

#Configure /mnt/data partition
#sudo mkdir /mnt/data

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

#Install boxes
apt install boxes -y

#GET INPUTS
echo "Hermes SEG 18.04 Installation" | boxes -d stone -p a2v1
echo "During installation a $SCRIPTPATH/install_log-$TIMESTAMP.log log file will be created. It's highly recommended that you open a separate shell window and tail that file in order to view progress of the installation and/or any errors that may occur. Additionally, ensure that you note all the usernames and passwords you will be prompted to create"

while true; do
    read -p "Do you wish to continue the installation of Hermes SEG 18.04? (Enter y or Y. Warning!! Entering n or N will exit this script and the installation will stop!)" yn
    case $yn in
        [Yy]* ) echo "[`date +%m/%d/%Y-%H:%M`] Starting Hermes SEG 18.04 Installation. View progress at $SCRIPTPATH/install_log-$TIMESTAMP.log" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
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



#START CONFIGURATION

echo "Starting Installation... View progress of installation and/or any errors in $SCRIPTPATH/install_log-$TIMESTAMP.log file located in the path you started this script"
echo "==== STARTING INSTALLATION ====" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

echo "[`date +%m/%d/%Y-%H:%M`] PRELIMINARY STEP 1 OF 2: Installing MySQL(MariaDB) Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install MariaDB
/usr/bin/apt install mariadb-server mariadb-client rsync -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR PRELIMINARY STEP 1 OF 2: $ERR, occurred during installing MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS PRELIMINARY STEP 1 OF 2. Completed installing MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] PRELIMINARY STEP 2 OF 2: Configuring MySQL(MariaDB)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#configure MariaDB
/usr/bin/mysql -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';" \
/usr/bin/mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" \
/usr/bin/mysql -e "DELETE FROM mysql.user WHERE User='';" \
#/usr/bin/mysql -e "DROP DATABASE test;" \
/usr/bin/mysql -e "FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR PRELIMINARY STEP 2 OF 2: $ERR, occurred during configuring MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS PRELIMINARY STEP 2 OF 2. Completed configuring MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi



echo "[`date +%m/%d/%Y-%H:%M`] STEP 1 OF 61. Stopping MySQL(MariaDB) Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Stop MySQL
/bin/systemctl stop mysql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 1 OF 61: $ERR, occurred during stopping MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 1 OF 61. Completed stopping MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 2 OF 61. Copying MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create /mnt/data/dbase directory, copy /var/lib/mysql/* to it and change owner to mysql
/bin/mkdir /mnt/data/dbase && /bin/cp -r /var/lib/mysql/* /mnt/data/dbase && /bin/chown -R mysql:mysql /mnt/data/dbase 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 2 OF 61: $ERR, occurred during copying MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 2 OF 61. Completed copying MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 3 OF 61. Reconfiguring MySQL(MariaDB) data directory to /mnt/data/dbase" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Make backup of /etc/mysql/mariadb.conf.d/50-server.cnf file and reconfigure datadir to /mnt/data/dbase
/bin/cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.ORIGINAL && /bin/sed -i -e "s|/var/lib/mysql|/mnt/data/dbase|g" "/etc/mysql/mariadb.conf.d/50-server.cnf" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 3 OF 61: $ERR, occurred during reconfiguring MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 3 OF 61. Completed reconfiguring MySQL(MariaDB) data to /mnt/data/dbase directory" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 4 OF 61. Configuring MySQL(MariaDB) mode" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Make backup of /etc/mysql/my.cnf file and configure MySQL mode
/bin/cp /etc/mysql/my.cnf /etc/mysql/my.ORIGINAL && /bin/echo "[mysqld]
sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 4 OF 61: $ERR, occurred during configuring MySQL(MariaDB) mode" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 4 OF 61. Completed configuring MySQL(MariaDB) mode" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 5 OF 61. Starting MySQL(MariaDB) Database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Start MySQL
/bin/systemctl start mysql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 5 OF 61: $ERR, occurred during starting MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 5 OF 61. Completed starting MySQL(MariaDB) database" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 6 OF 61. Started creating Hermes SEG database and assigning user $MYSQL_HERMES_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create hermes database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE hermes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON hermes.* TO '$MYSQL_HERMES_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_HERMES_PASSWORD'; GRANT ALL ON hermes.* TO '$MYSQL_HERMES_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_HERMES_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 6 OF 61: $ERR, occurred during Hermes SEG database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 6 OF 61. Completed Hermes SEG database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 7 OF 61. Started creating Syslog database and assigning user $MYSQL_SYSLOG_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Syslog database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE Syslog CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON Syslog.* TO '$MYSQL_SYSLOG_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_SYSLOG_PASSWORD'; GRANT ALL ON Syslog.* TO '$MYSQL_SYSLOG_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_SYSLOG_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 7 OF 61: $ERR, occurred during Syslog database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 7 OF 61. Completed Syslog database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 8 OF 61. Started creating Opendmarc database and assigning user $MYSQL_OPENDMARC_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Opendmarc database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE opendmarc CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; GRANT ALL ON opendmarc.* TO '$MYSQL_OPENDMARC_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_OPENDMARC_PASSWORD'; GRANT ALL ON opendmarc.* TO '$MYSQL_OPENDMARC_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_OPENDMARC_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 8 OF 61: $ERR, occurred during Opendmarc database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 8 OF 61. Completed Opendmarc database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 9 OF 61. Started creating Ciphermail database and assigning user $MYSQL_CIPHERMAIL_USERNAME to it" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create ciphermail database
/usr/bin/mysql -u $MYSQL_ROOT_USERNAME  -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE djigzo CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL ON djigzo.* TO '$MYSQL_CIPHERMAIL_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_CIPHERMAIL_PASSWORD'; GRANT ALL ON djigzo.* TO '$MYSQL_CIPHERMAIL_USERNAME'@'127.0.0.1' IDENTIFIED BY '$MYSQL_CIPHERMAIL_PASSWORD'; FLUSH PRIVILEGES;" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 9 OF 61: $ERR, occurred during Ciphermail database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 9 OF 61. Completed Ciphermail database creation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 61. Started creating Hermes SEG Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create hermes database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="hermes" < $SCRIPTPATH/download/hermes/mysql_schema/hermes.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 10 OF 61: $ERR, occurred during creating Hemes SEG Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 10 OF 61. Completed creating Hermes SEG Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 11 OF 61. Creating Opendmarc database schema." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Opendmarc database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="opendmarc" < $SCRIPTPATH/download/hermes/mysql_schema/opendmarc.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 11 OF 61: $ERR, occurred during creating Opendmarc database schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 11 OF 61. Completed creating Opendmarc database schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 12 OF 61. Installing OpenJDK 8" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install OpenJDK
/usr/bin/apt install openjdk-8-jre openjdk-8-jre-headless -y && apt purge openjdk-11* -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 12 OF 61: $ERR, occurred during OpenJDK 8 installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 12 OF 61. Completed installing OpenJDK" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi


#echo "[`date +%m/%d/%Y-%H:%M`] STEP 12 OF 61. Started installing CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Commandbox
#/usr/bin/curl -fsSl https://downloads.ortussolutions.com/debs/gpg | sudo apt-key add - && echo "deb https://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list && /usr/bin/apt update && /usr/bin/apt install apt-transport-https commandbox -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 12 OF 61: $ERR, occurred during install of CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#else
#echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 12 OF 61. Completed install of CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi

#echo "[`date +%m/%d/%Y-%H:%M`] STEP 13 OF 61. Started configuring CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Copy Lucee .jar files to /root/.CommandBox/engine/cfml/cli/lucee-server/bundles and Configure Commandbox
#cp $SCRIPTPATH/download/lucee/* /root/.CommandBox/engine/cfml/cli/lucee-server/bundles && /usr/local/bin/box version 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 13 OF 61: $ERR, occurred during configuring of CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#else
#echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 13 OF 61. Completed configuring of CommandBox" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi

echo "Starting installation of rsyslog-mysql package"

echo "==== WARNING ===="  | boxes -d stone -p a2v1
echo "During installation of rsyslog-mysql package, you will be prompted to configure database for rsylog-mysql with dbconfig-common. You must answer NO since this script will automatically install and configure the database"

while true; do
    read -p "Do you wish to continue the installation of rsyslog-mysql package? (Enter y or Y. Warning!! Entering n or N will exit this script and the installation will fail!)" yn
    case $yn in
        [Yy]* ) echo "[`date +%m/%d/%Y-%H:%M`] STEP 13 OF 61: Installing rsyslog-mysql" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; /usr/bin/apt install rsyslog-mysql -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log; echo "[`date +%m/%d/%Y-%H:%M`] SUCESS STEP 13 OF 61: Completed Installing rsyslog-mysql" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "[`date +%m/%d/%Y-%H:%M`] STEP 14 OF 61. Started configuring rsyslog-mysql." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Make backup /etc/rsyslog.d/mysql.conf and configure /etc/rsylog.d/mysql.conf
/bin/cp /etc/rsyslog.d/mysql.conf /etc/rsyslog.d/mysql.ORIGINAL &&  /bin/sed -i -e "s|rsyslog|${MYSQL_SYSLOG_USERNAME}|g" /etc/rsyslog.d/mysql.conf && /bin/sed -i -e 's|pwd=""|pwd="MYSQL_SYSLOG_PASSWORD"|g' /etc/rsyslog.d/mysql.conf && /bin/sed -i -e "s|MYSQL_SYSLOG_PASSWORD|${MYSQL_SYSLOG_PASSWORD}|g" /etc/rsyslog.d/mysql.conf 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 14 OF 61: $ERR, occurred during configuring rsyslog-mysql" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 14 OF 61. Completed configuring configuring rsyslog-mysql" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 15 OF 61. Creating rsyslog-mysql database schema." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create rsyslog-mysql database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="Syslog" < $SCRIPTPATH/download/hermes/mysql_schema/Syslog.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 15 OF 61: $ERR, occurred during creating rsyslog-mysql database schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 15 OF 61. Completed creating rsyslog-mysql database schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 16 OF 61. Restarting rsyslog-mysql." >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Restart rsyslog-mysql
/bin/systemctl restart rsyslog 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 16 OF 61: $ERR, occurred during configuring rsyslog-mysql" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 16 OF 61. Completed configuring configuring rsyslog-mysql" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 17 OF 61. Installing dos2unix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install dos2unix
/usr/bin/apt install dos2unix -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 17 OF 61: $ERR, occurred during dos2unix installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 17 OF 61. Completed installing dos2unix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 18 OF 61. Creating Hermes SEG directory structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#mkdir /opt/hermes directory, copy files, make scripts executable and ensure scripts are in unix format (probably unnecessary)
/bin/mkdir /opt/hermes && \
/bin/cp -r $SCRIPTPATH/dirstructure/opt/hermes/* /opt/hermes && \
/bin/chmod +x /opt/hermes/scripts/* && \
/bin/chmod +x /opt/hermes/templates/*.sh && \
/usr/bin/dos2unix /opt/hermes/scripts/* && \
/usr/bin/dos2unix /opt/hermes/templates/*.sh && \
/bin/mkdir /mnt/hermesarchivetest && \
/bin/mkdir /mnt/hermesemail_archive && \
/bin/mkdir /mnt/archive && \
/bin/mkdir /mnt/backups && \
/bin/mkdir /mnt/hermesbackups && \
/bin/mkdir /mnt/hermesbackuptest && \
/bin/mkdir /mnt/hermesrestore && \
/bin/mkdir /mnt/hermesrestoretest 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log


ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 18 OF 61: $ERR, occurred during creating Hermes SEG directory structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 18 OF 61. Completed creating Hermes SEG directory structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 10 OF 61. Installing cifs-utils, 7zip, sendemail and haveged" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install cifs-tuils, 7zip, sendemail and haveged
/usr/bin/apt install cifs-utils p7zip p7zip-rar sendemail haveged -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 19 OF 61: $ERR, occurred during cifs-utils, 7zip, sendemail and haveged installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 19 OF 61. Completed installing cifs-utils, 7zip, sendemail and haveged" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 20 OF 61. Installing GnuPG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install gnupg
/usr/bin/apt install gnupg -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 20 OF 61: $ERR, occurred during GnuPG installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 20 OF 61. Completed installing GnuPG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 21 OF 61. Creating GnuPG directory and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#set GnuPG directory permissions
/bin/mkdir /opt/hermes/.gnupg && /bin/chmod -R go-rwx /opt/hermes/.gnupg/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 21 OF 61: $ERR, occurred during Creating GnuPG directory and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 21 OF 61. Completed Creating GnuPG directory and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 22 OF 61. Installing ClamAV" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install ClamAV
/usr/bin/apt install clamav clamav-daemon -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 22 OF 61: $ERR, occurred during ClamAV installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 22 OF 61. Completed installing ClamAV" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 23 OF 61. Installing and Configuring amavisd-new" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install and configure amavisd-new
/bin/echo $MAIL_NAME > /etc/mailname && /bin/hostname $MAIL_NAME && /usr/bin/apt install amavisd-new -y && /usr/sbin/adduser clamav amavis 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 23 OF 61: $ERR, occurred during amavisd-new installation and configuration" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 23 OF 61. Completed amavisd-new installation and configuration" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 24 OF 61. Creating amavisd-new directories and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create amavis directories under /mnt/data/ and set permissions
/bin/mkdir /mnt/data/amavis && \
/bin/mkdir /mnt/data/amavis/bad_header && \
/bin/mkdir /mnt/data/amavis/banned && \
/bin/mkdir /mnt/data/amavis/clean && \
/bin/mkdir /mnt/data/amavis/spam && \
/bin/mkdir /mnt/data/amavis/virus && \
/bin/chown -R amavis:amavis /mnt/data/amavis/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 24 OF 61: $ERR, occurred during creating amavisd-new directories and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 24 OF 61. Completed creating amavisd-new directories and setting permissions" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 25 OF 61. Installing spamassassin, razor and pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install spamassassin, razor pyzor
/usr/bin/apt install spamassassin razor pyzor -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 25 OF 61: $ERR, occurred during spamassassin, razor and pyzor installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 25 OF 61. Completed installing spamassassin, razor and pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 26 OF 61. Configuring Spamassassin" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Spamassassin
/bin/cp /etc/default/spamassassin /etc/default/spamassassin.ORIGINAL && \
/bin/sed -i -e "s|ENABLED=0|ENABLED=1|g" "/etc/default/spamassassin" && \
/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/spamassassin/local.cf /etc/spamassassin/local.cf && \
systemctl restart amavis 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 26 OF 61: $ERR, occurred during configuring Spamassassin" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 26 OF 61. Completed configuring Spamassassin" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 27 OF 61. Configuring Pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Pyzor
/usr/bin/pyzor ping 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 27 OF 61: $ERR, occurred during configuring Pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 27 OF 61. Completed configuring Pyzor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 26 OF 61. Configuring Razor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Razor
/bin/rm /etc/razor/razor-agent.conf && \
/usr/bin/razor-admin -home=/etc/razor -create && \
/usr/bin/razor-admin -home=/etc/razor -register 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 26 OF 61: $ERR, occurred during configuring Razor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 26 OF 61. Completed configuring Razor" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 27 OF 61. Installing DCC" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install DCC
cd $SCRIPTPATH/download/dcc/dcc-2.3.167 && \
/bin/chmod +x configure && \
/bin/chmod +x ./autoconf/install-sh && \
./configure --with-uid=amavis && \
make && make install && \
/bin/chown -R amavis:amavis /var/dcc && \
ln -s /var/dcc/libexec/dccifd /usr/local/bin/dccifd 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 27 OF 61: $ERR, occurred during installing DCC" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 27 OF 61. Completed installing DCC" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 28 OF 61. Configuring DCC and enabling in SA" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure DCC and enable in SA
/usr/local/bin/cdcc info && \
/bin/cp /etc/spamassassin/v310.pre /etc/spamassassin/v310.ORIGINAL && \
/bin/sed -i -e "s|#loadplugin Mail::SpamAssassin::Plugin::DCC|loadplugin Mail::SpamAssassin::Plugin::DCC|g" "/etc/spamassassin/v310.pre" && \
/usr/bin/spamassassin --lint 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 28 OF 61: $ERR, occurred during configuring DCC and enabling in SA" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 28 OF 61. Completed configuring DCC and enabling in SA" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "==== WARNING ====" | boxes -d stone -p a2v1
echo "During installation of Postfix package, you will be prompted to select a mail server configuration. You must answer Internet Site. Additionally you will be asked for the System mail name. Leave the name at default and select Ok to continue"

while true; do
    read -p "Do you wish to continue the installation of Postfix package? (Enter y or Y. Warning!! Entering n or N will exit this script and the installation will fail!)" yn
    case $yn in
        [Yy]* ) echo "[`date +%m/%d/%Y-%H:%M`] STEP 29 OF 61: Installing Postfix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; /usr/bin/apt install postfix postfix-mysql postfix-ldap postfix-pcre -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log; echo "[`date +%m/%d/%Y-%H:%M`] SUCESS STEP 29 OF 61: Completed Installing Postfix" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "[`date +%m/%d/%Y-%H:%M`] STEP 30 OF 61. Installing Extractors" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#install extractors
/usr/bin/apt install arj bzip2 cabextract cpio file gzip lhasa nomarch pax rar unrar unzip zip -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 30 OF 61: $ERR, occurred during extractors installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 30 OF 61. Completed installing extractors" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi



echo "[`date +%m/%d/%Y-%H:%M`] STEP 31 OF 61. Configuring ClamAV Whitelist" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure ClamAV WhiteList
/bin/systemctl stop clamav-daemon && \
/bin/cp -r $SCRIPTPATH/download/clamav/local.ign2 /var/lib/clamav && \
/bin/cp -r $SCRIPTPATH/download/clamav/local.ign2.HERMES /var/lib/clamav && \
/bin/chown clamav:clamav /var/lib/clamav/local.ign2 && \
/bin/systemctl start clamav-daemon 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 31 OF 61: $ERR, occurred during ClamAV Whitelist" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 31 OF 61. Completed ClamAV Whitelist" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 32 OF 61. Removing any existing clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Remove any existing clamav-unofficial-sigs
/usr/bin/apt purge -y clamav-unofficial-sigs 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 32 OF 61: $ERR, occurred during removing any existing clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 32 OF 61. Completed removing any existing clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 33 OF 61. Installing and configuring extremeshok clamav-unofficial-sigs" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

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
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 33 OF 61: $ERR, occurred during extremeshok clamav-unofficial-sigs installation and configuration" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 33 OF 61. Completed extremeshok clamav-unofficial-sigs installation and configuration" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 34 OF 61. Copying Postfix and amavisd-new configuration files" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Copy Postfix and amavisd-new configuration files
/bin/cp -r $SCRIPTPATH/download/postfix/* /etc/postfix && \
/bin/cp -r $SCRIPTPATH/download/amavis/* /etc/amavis 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 34 OF 61: $ERR, occurred during copying Postfix and amavisd-new configuration files" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 34 OF 61. Completed copying Postfix and amavisd-new configuration files" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 35 OF 61. Installing SPF" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install SPF
/usr/bin/apt install postfix-policyd-spf-python -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 35 OF 61: $ERR, occurred during SPF installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 35 OF 61. Completed installing SPF" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 36 OF 61. Installing DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install DKIM
/usr/bin/apt install opendkim opendkim-tools -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 36 OF 61: $ERR, occurred during DKIM installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 36 OF 61. Completed installing DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 37 OF 61. Configuring DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure DKIM
/usr/sbin/usermod -a -G opendkim postfix && \
/bin/cp /etc/opendkim.conf /etc/opendkim.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/opendkim/opendkim.conf /etc/opendkim.conf && \
/bin/systemctl restart opendkim 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 37 OF 61: $ERR, occurred during DKIM configuration" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 37 OF 61. Completed configuring DKIM" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 38 OF 61. Installing Apache and enabling SSL and proxy_ajp modules" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Apache
/usr/bin/apt install apache2 -y && \
/usr/sbin/a2enmod ssl && \
/usr/sbin/a2enmod proxy_ajp && \
/bin/systemctl restart apache2 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 38 OF 61: $ERR, occurred during installing Apache and enabling SSL and proxy_ajp modules" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 38 OF 61. Completed installing Apache and enabling SSL and proxy_ajp modules" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 39 OF 61. Started Downloading Ciphermail Back-End from https://www.ciphermail.com/downloads/" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Download Ciphermail Back-End
/usr/bin/wget -O $SCRIPTPATH/djigzo_4.5.0-0_all.deb --no-check-certificate https://www.deeztek.com/downloads/ciphermail/djigzo_4.6.2-0_all.deb 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 39 OF 61: $ERR, occurred during dowload of Ciphermail Back-End" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 39 OF 61. Completed download of Ciphermail Back-End" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 40 OF 61. Started Downloading Ciphermail Web GUI from https://www.ciphermail.com/downloads/" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Download Ciphermail Web GUI
/usr/bin/wget -O $SCRIPTPATH/djigzo-web_4.5.0-0_all.deb --no-check-certificate https://www.deeztek.com/downloads/ciphermail/djigzo-web_4.6.2-0_all.deb 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 40 OF 61: $ERR, occurred during dowload of Ciphermail Web GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 40 OF 61. Completed download of Ciphermail Web GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 41 OF 61. Installing Ciphermail Prerequisites" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Ciphermail prerequisites
/usr/bin/apt install ant ant-optional libsasl2-modules symlinks -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 41 OF 61: $ERR, occurred during installing Ciphermail prerequisites" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 41 OF 61. Completed installing Ciphermail prerequisites" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 42 OF 61. Installing Ciphermail Back-end" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Ciphermail back-end
/usr/bin/dpkg -i $SCRIPTPATH/djigzo_4.6.2-0_all.deb && /bin/systemctl restart djigzo 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 42 OF 61: $ERR, occurred during installing Ciphermail back-end" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 42 OF 61. Completed installing Ciphermail back-end" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 43 OF 61. Installing Ciphermail Web-GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Ciphermail Web-GUI
/usr/bin/dpkg -i $SCRIPTPATH/djigzo-web_4.6.2-0_all.deb 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 43 OF 61: $ERR, occurred during installing Ciphermail Web-GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 43 OF 61. Completed installing Ciphermail Web-GUI" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 44 OF 61. Installing Apache Tomcat" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Tomcat
/usr/bin/apt install tomcat8 -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 44 OF 61: $ERR, occurred during installing Apache Tomcat" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 44 OF 61. Completed installing Apache Tomcat" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 45 OF 61. Configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

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
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 45 OF 61: $ERR, occurred during configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 45 OF 61. Completed configuring Apache Tomcat for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 46 OF 61. Configuring MySQL(MariaDB) for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure MariaDB for Ciphermail
/bin/cp $SCRIPTPATH/download/ciphermail/ciphermail.cnf /etc/mysql/conf.d/ciphermail.cnf && \
/bin/systemctl restart mysql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 46 OF 61: $ERR, occurred during configuring MySQL(MariaDB) for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 46 OF 61. Completed configuring MySQL(MariaDB) for Ciphermail" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 47 OF 61. Started creating Ciphermail Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Ciphermail database schema
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="djigzo" < /usr/share/djigzo/conf/database/sql/djigzo.mysql.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 47 OF 61: $ERR, occurred during creating Ciphermail Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 47 OF 61. Completed creating Ciphermail Database Schema" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 48 OF 61. Add Ciphermail Hermes SEG MySQL Customizations" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Add Ciphermail Hermes SEG MySQL Customizations
/usr/bin/mysql --user="$MYSQL_ROOT_USERNAME" --password="$MYSQL_ROOT_PASSWORD" --database="djigzo" < $SCRIPTPATH/download/ciphermail/ciphermail_hermes.sql 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 48 OF 61: $ERR, occurred during Adding Ciphermail Hermes SEG MySQL Customizations" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 48 OF 61. Completed Adding Ciphermail Hermes SEG MySQL Customizations" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 49 OF 61. Configuring Ciphermail for MySQL(MariaDB)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Ciphermail for MySQL
/bin/echo "-Dciphermail.hibernate.database.type=mysql" | sudo tee -a /usr/share/djigzo/wrapper/wrapper-additional-parameters.conf && \
/bin/cp $SCRIPTPATH/dirstructure/opt/hermes/conf_files/hibernate.mysql.connection.HERMES /usr/share/djigzo/conf/database/hibernate.mysql.connection.xml && \
/bin/sed -i -e "s|DJIGZO-USERNAME|$MYSQL_CIPHERMAIL_USERNAME|g" "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" && \
/bin/sed -i -e "s|DJIGZO-PASSWORD|$MYSQL_CIPHERMAIL_PASSWORD|g" "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" && \
/bin/systemctl restart djigzo && /bin/systemctl restart tomcat8 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 49 OF 61: $ERR, occurred during configuring Ciphermail for MySQL(MariaDB)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 49 OF 61. Completed creating Ciphermail for MySQL(MariaDB)" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 50 OF 61. Started Downloading Lucee from https://cdn.lucee.org/" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Download Lucee
/usr/bin/wget -O $SCRIPTPATH/lucee-5.2.9.031-pl0-linux-x64-installer.run --no-check-certificate https://cdn.lucee.org/lucee-5.2.9.031-pl0-linux-x64-installer.run 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 50 OF 61: $ERR, occurred during dowload of Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 50 OF 61. Completed download of Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 51 OF 61. Installing Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install Lucee
/bin/sed -i -e "s|LUCEE-PASSWORD|$LUCEE_ADMIN_PASSWORD|g" "$SCRIPTPATH/download/lucee_install/lucee_install_options.txt" && \
/bin/chmod +x $SCRIPTPATH/lucee-5.2.9.031-pl0-linux-x64-installer.run && \
$SCRIPTPATH/lucee-5.2.9.031-pl0-linux-x64-installer.run --mode unattended --optionfile $SCRIPTPATH/download/lucee_install/lucee_install_options.txt 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 51 OF 61: $ERR, occurred during installing Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 51 OF 61. Completed installing Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 52 OF 61. Creating Hermes SEG Web Directory Structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Hermes SEG Web Directory Structure
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/admin/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/main/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/users/ /var/www/html/ && \
/bin/cp -r $SCRIPTPATH/dirstructure/var/www/html/schedule/ /var/www/html/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 52 OF 61: $ERR, occurred during creating Hermes SEG Web Directory Structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 52 OF 61. Completed Creating Hermes SEG Web Directory Structure" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 53 OF 61. Copying Hermes SEG POP4 extension" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Copy Hermes SEG POP4 extension
/bin/cp -r $SCRIPTPATH/dirstructure/opt/lucee/tomcat/webapps/ROOT/WEB-INF/lucee/components/hermes /opt/lucee/tomcat/webapps/ROOT/WEB-INF/lucee/components 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 53 OF 61: $ERR, occurred during copying Hermes SEG POP4 extension" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 53 OF 61. Completed copying Hermes SEG POP4 extension" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 54 OF 61. Creating Lucee Mappings and Restarting Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#create Lucee mappings and restart Lucee
/bin/cp /opt/lucee/tomcat/lucee-server/context/lucee-server.xml /opt/lucee/tomcat/lucee-server/context/lucee-server.bak && \
/bin/sed -i 's|<mapping archive="{lucee-config}/context/lucee-doc.lar" inspect-template="once" primary="archive" readonly="true" toplevel="true" virtual="/lucee/doc"/>|&<mapping inspect-template="once" physical="/var/www/html/schedule" primary="physical" readonly="false" toplevel="true" virtual="/schedule"/><mapping inspect-template="once" physical="/var/www/html/admin" primary="physical" readonly="false" toplevel="true" virtual="/admin"/><mapping inspect-template="once" physical="/var/www/html/users" primary="physical" readonly="false" toplevel="true" virtual="/users"/><mapping inspect-template="once" physical="/var/www/html/main" primary="physical" readonly="false" toplevel="true" virtual="/main"/>|' /opt/lucee/tomcat/lucee-server/context/lucee-server.xml && \
/etc/init.d/lucee_ctl restart 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 54 OF 61: $ERR, occurred during creating Lucee Mappings and restarting Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 54 OF 61. Completed creating Lucee Mappings and restarting Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 55 OF 61. Configuring Apache for Hermes SEG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Configure Apache for Hermes SEG
/usr/sbin/a2dissite 000-default.conf && \
/bin/cp $SCRIPTPATH/download/apache2/hermes-ssl.* /etc/apache2/sites-available/ && \
/bin/cp /etc/apache2/ports.conf /etc/apache2/ports.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/apache2/ports.conf /etc/apache2/ports.conf && \
/usr/sbin/a2ensite hermes-ssl.conf && \
/bin/systemctl reload apache2 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 55 OF 61: $ERR, occurred during configuring Apache for Hermes SEG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 55 OF 61. Completed configuring Apache for Hermes SEG" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 56 OF 61. Configuring Hermes SEG Application Datasources" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

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
/bin/sed -i -e "s|HERMES_DATASOURCE_PASSWORD|$MYSQL_HERMES_PASSWORD|g" "/var/www/html/main/Application.cfc" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 56 OF 61: $ERR, occurred during Configuring Hermes SEG Application Datasources" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 56 OF 61. Completed Configuring Hermes SEG Application Datasources" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 57 OF 61. Installing and configuring Lynx browser" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Install and configure Lynx browser
/usr/bin/apt install lynx -y && \
/bin/cp /etc/lynx/lynx.cfg /etc/lynx/lynx.ORIGINAL && \
/bin/sed -i -e "s|#FORCE_SSL_PROMPT:PROMPT|FORCE_SSL_PROMPT:YES|g" "/etc/lynx/lynx.cfg" && \
/bin/sed -i -e "s|ACCEPT_ALL_COOKIES:FALSE|ACCEPT_ALL_COOKIES:TRUE|g" "/etc/lynx/lynx.cfg" 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 57 OF 61: $ERR, occurred during installing and configuring Lynx Browser" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS 57 OF 61. Completed installing and configuring Lynx Browser" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 58 OF 61. Creating Hermes SEG Scheduled Tasks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Create Hermes SEG Scheduled Tasks
# === LUCEE SCHEDULED TASKS BELOW ARE DEPRECATED DUE TO ISSUES WITH LUCEE RUNNING DUPLICATE TASKS AS OF LUCEE 5.3.3.62 ====
#/bin/cp $SCRIPTPATH/download/hermes/create_scheduled_tasks.cfm /var/www/html/schedule/ && \
#/usr/bin/curl -source https://localhost:9080/schedule/create_scheduled_tasks.cfm && \
#/bin/rm /var/www/html/schedule/create_scheduled_tasks.cfm 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log
# === LUCEE SCHEDULED TASKS ABOVE ARE DEPRECATED DUE TO ISSUES WITH LUCEE RUNNING DUPLICATE TASKS AS OF LUCEE 5.3.3.62 ====

# === CREATE SCHEDULED TASKS USING /ETC/CRON.D/ ====
/bin/cp $SCRIPTPATH/download/etc/cron.d/* /etc/cron.d/ 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log 

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 58 OF 61: $ERR, occurred during creating Hermes SEG Scheduled Tasks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 58 OF 61. Completed creating Hermes SEG Scheduled Tasks" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "==== WARNING ====" | boxes -d stone -p a2v1
echo "During installation of Opendmarc, you will be prompted to configure database for Opendmarc with dbconfig-common. You must answer NO since this script has already configured the database"
echo "Additionally, as part of the Opendmarc installation, during libc6 configuration, you MAY be prompted to restart services during package upgrades without asking. You may answer YES to that prompt"

#Install Opendmarc 1.3.2-6 from eoan main
while true; do
    read -p "Do you wish to continue the installation of Opendmarc? (Enter y or Y. Warning!! Entering n or N will exit this script and the installation will fail!)" yn
    case $yn in
        [Yy]* ) echo "[`date +%m/%d/%Y-%H:%M`] STEP 59 OF 61: Installing Opendmarc" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; /bin/cp /etc/apt/sources.list /etc/apt/sources.list.ORIGINAL && /bin/echo "deb http://cz.archive.ubuntu.com/ubuntu eoan main universe" | sudo tee -a /etc/apt/sources.list && /usr/bin/apt update && /usr/bin/apt install opendmarc -y 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log; echo "[`date +%m/%d/%Y-%H:%M`] SUCESS STEP 59 OF 61: Completed Installing Opendmarc" >> $SCRIPTPATH/install_log-$TIMESTAMP.log; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "[`date +%m/%d/%Y-%H:%M`] STEP 60 OF 61. Configuring Opendmarc. Please note, an error will be generated during configuration of Opendmarc. This is expected behavior with Ubuntu 18.04 and Opendmarc will work normally after reboot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log


/bin/cp /etc/apt/sources.list.ORIGINAL /etc/apt/sources.list && \
/usr/bin/apt update && \
/bin/cp /etc/opendmarc.conf /etc/opendmarc.ORIGINAL && \
/bin/cp $SCRIPTPATH/download/opendmarc/opendmarc.conf /etc/opendmarc.conf && \
/bin/systemctl restart opendmarc 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

ERR=$?
if [ $ERR != 0 ]; then
THEERROR=$(($THEERROR+$ERR))
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 60 OF 61: $ERR, occurred during Opendmarc configuration. Please note, This is expected behavior with Ubuntu 18.04 and Opendmarc should work normally after a reboot" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#Do not exit on Opendmarc error since it's expected and SHOULD work after reboot
#exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 60 OF 61. Completed configuring Opendmarc" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

echo "[`date +%m/%d/%Y-%H:%M`] STEP 61 OF 61. Ensuring Hermes SEG permissions are set correctly" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

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
echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 61 OF 61: $ERR, occurred during ensuring Hermes SEG permissions are set correctly" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
exit 1
else
echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 61 OF 61. Completed ensuring Hermes SEG permissions are set correctly" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
fi

#echo "[`date +%m/%d/%Y-%H:%M`] STEP 62 OF 62. Resetting Hermes SEG cfclasses and restarting Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

#Reset Hermes SEG cfclasses and restart Lucee
#/bin/rm -rf /var/www/html/WEB-INF/lucee/cfclasses/ && \
#/etc/init.d/lucee_ctl restart 2>> $SCRIPTPATH/install_log-$TIMESTAMP.log

#ERR=$?
#if [ $ERR != 0 ]; then
#THEERROR=$(($THEERROR+$ERR))
#echo "[`date +%m/%d/%Y-%H:%M`] ERROR STEP 61 OF 62: $ERR, occurred during resetting Hermes SEG cfclasses and restarting Lucee " >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#exit 1
#else
#echo "[`date +%m/%d/%Y-%H:%M`] SUCCESS STEP 61 OF 62. Completed resetting Hemres SEG cfclasses and restarting Lucee" >> $SCRIPTPATH/install_log-$TIMESTAMP.log
#fi


echo "[`date +%m/%d/%Y-%H:%M`] ==== FINISHED INSTALLATION ==== Ensure no errors were logged during installation" >> $SCRIPTPATH/install_log-$TIMESTAMP.log

echo "FINISHED INSTALLATION. PLEASE REBOOT YOUR MACHINE!!" | boxes -d stone -p a2v1

echo "Take a look at the $SCRIPTPATH/install_log-$TIMESTAMP.log file for any errors"

echo "Using a browser, navigate to the following address https://SERVER_IP:9080/admin/logon.cfm where SERVER_IP is the ip address of your server and ensure you are able to login to the Hermes SEG Administration Console using 'admin' as the username and 'ChangeMe2!' as the default password"

echo "Ensure you take a look at the Hermes SEG Getting Started Guide located at https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/getting-started/" 









