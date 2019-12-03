/usr/bin/gpg  --home /opt/hermes/.gnupg/ --with-fingerprint --with-colons /opt/hermes/tmp/THE-FILE | awk -F: '/^ssb:/ { print $5 }' 2>&1
