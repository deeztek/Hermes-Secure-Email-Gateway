The script below assumes you have a fully installed and updated Ubuntu 18.04 server and you have a /mnt/data directory for database and email archive storage. 

**Required Information**

The script will prompt you for the following information before it starts installation. Ensure you have that information available before you begin:

* MySQL(MariaDB) root user password you wish to use
* MySQL(MariaDB) username you wish to use with the hermes database (Example: hermes)
* MySQL(MariaDB) password you wish to use with the hermes database user
* MySQL(MariaDB) username you wish to use with the Syslog database (Example: rsyslog)
* MySQL(MariaDB) password you wish to use with the Syslog database user
* MySQL(MariaDB) username you wish to use with the cipermail database (Example: ciphermail)
* MySQL(MariaDB) password you wish to use with the ciphermail database user
* MySQL(MariaDB) username you wish to use with the opendmarc database (Example: opendmarc)
* MySQL(MariaDB) password you wish to use with the opendmarc database user
* Lucee Server and Web Administrator password you wish to use
* System Mailname (Example: smtp.domain.tld)


The **Configure /mnt/data partition** directions below assume you have a 250GB secondary drive which you will partition, format and mount as /mnt/data. 

Technically a secondary drive for the /mnt/data directory is not a requirement but it's highly recommended for performance reasons. If you don't wish to use a secondary drive for the /mnt/data directory, simply create a /mnt/data directory in your system and skip to the **Quick script install and run instructions** section. 

**Configure /mnt/data partition**

`sudo mkdir /mnt/data`

`sudo fdisk -l `

Look for 250 GB drive you created earlier device ID, usually /dev/sdb. Ensure you select correct device ID before running the commands below)

**Create partititon**

`sudo fdisk /dev/sdb`

* Hit "n" to add new partition
* Hit "p" for primary partition
* Hit "Enter" for partition 1
* Hit "Enter" for default first sector
* Hit "Enter" for default last sector
* Hit "w" to write changes to disk and exit


**Format Partition**

`sudo mkfs.ext4 /dev/sdb1`

**Mount Partition to /mnt/data**

`sudo mount /dev/sdb1 /mnt/data`

**Get disk UUID**

`ls -l /dev/disk/by-uuid`

**Edit /etc/fstab**

`sudo vi /etc/fstab`

**Add the following in /etc/fstab where DEVICE_ID is the UUID from the command above**

`UUID=DEVICE_ID /mnt/data               ext4    errors=remount-ro 0       1`

**Verify drive is mounted**

`sudo df -h`

**Should yield output similar to below:**

```
Filesystem      Size  Used Avail Use% Mounted on
udev            1.9G     0  1.9G   0% /dev
tmpfs           395M  1.1M  394M   1% /run
/dev/sda2        79G  5.5G   69G   8% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/loop0       87M   87M     0 100% /snap/core/4917
/dev/loop1       90M   90M     0 100% /snap/core/8039
tmpfs           395M     0  395M   0% /run/user/1000
/dev/sdb1       246G   61M  233G   1% /mnt/data
```

Reboot and ensure /mnt/data gets mounted automatically

**Quick script install and run instructions**

Git clone the Hermes SEG repository:

`sudo git clone https://gitlab.deeztek.com/dedwards/hermes-seg-18.04.git`

This will clone the repository and create a hermes-seg-18.04 directory in the directory you ran the git clone command from.

Change to the hermes-seg-18.04 directory:

`cd hermes-seg-18.04/`

Run the script as root:

`bash ubuntu_hermes_1804_install.sh`

**Support**

Support can be obtained by visiting our Hermes SEG Support forums at:

[https://forums.deeztek.com/viewforum.php?f=22](https://forums.deeztek.com/viewforum.php?f=22)

