/bin/umount -f -l /mnt/hermesemail_archive
#/sbin/mount.cifs //THE-SERVER/THE-SHARE/THE-DIRECTORY /mnt/hermesbackuptest -o username=THE-DOMAIN/THE-USERNAME,password=THE-PASSWORD

/bin/mount '//THE-SERVER/THE-SHARE/THE-DIRECTORY' -t cifs -o uid=1000,gid=1000,vers=SAMBAVER,username='THE-USERNAME',domain='THE-DOMAIN',password='THE-PASSWORD' /mnt/hermesemail_archive

/opt/hermes/scripts/test_share_archive_remount.sh
