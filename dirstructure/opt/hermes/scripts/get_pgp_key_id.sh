/usr/bin/gpg --with-fingerprint --with-colons /opt/hermes/tmp/THE-FILE | awk -F: '/^pub:/ { print $5 }' 2>&1
