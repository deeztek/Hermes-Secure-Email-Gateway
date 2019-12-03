/bin/umount -f -l /mnt/hermesbackuptest

/bin/mount '//THE-SERVER/THE-SHARE/THE-DIRECTORY' -t cifs -o uid=1000,gid=1000,vers=SAMBAVER,username='THE-USERNAME',domain='THE-DOMAIN',password='THE-PASSWORD' /mnt/hermesbackuptest

/opt/hermes/scripts/test_share.sh
