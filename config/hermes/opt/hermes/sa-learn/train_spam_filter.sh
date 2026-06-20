/usr/bin/rsync -r -v --progress root@mailstore.example.com:/mnt/mailstore/vmail1/example.com/user/Maildir/.SPAM/* /opt/hermes/sa-learn/SPAM/

/usr/bin/rsync -r -v --progress root@mailstore.example.com:/mnt/mailstore/vmail1/example.com/user/Maildir/.HAM/* /opt/hermes/sa-learn/HAM/

/usr/bin/sa-learn --no-sync --spam /opt/hermes/sa-learn/SPAM/{cur,new}

/usr/bin/sa-learn --no-sync --ham /opt/hermes/sa-learn/HAM/{cur,new}
