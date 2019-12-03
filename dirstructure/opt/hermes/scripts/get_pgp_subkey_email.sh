/usr/bin/gpg --with-fingerprint --with-colons /opt/hermes/tmp/THE-FILE | awk -F: '/^sec:/ { print $10 }' 2>&1
