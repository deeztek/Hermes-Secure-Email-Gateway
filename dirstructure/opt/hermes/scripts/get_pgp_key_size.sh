/usr/bin/gpg  --home /opt/hermes/.gnupg/ --list-keys --with-colons THE_KEY | awk -F: '/^pub:/ { print $3 }' 2>&1
