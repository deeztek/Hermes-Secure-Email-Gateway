/usr/bin/rsync -r -v --progress root@192.168.10.250:/mnt/mailstore/vmail1/getwithme.com/tina/Maildir/.SPAM/* /opt/hermes/sa-learn/SPAM/

/usr/bin/rsync -r -v --progress root@192.168.10.250:/mnt/mailstore/vmail1/getwithme.com/tina/Maildir/.HAM/* /opt/hermes/sa-learn/HAM/

/usr/bin/sa-learn --no-sync --spam /opt/hermes/sa-learn/SPAM/{cur,new}

/usr/bin/sa-learn --no-sync --ham /opt/hermes/sa-learn/HAM/{cur,new}
