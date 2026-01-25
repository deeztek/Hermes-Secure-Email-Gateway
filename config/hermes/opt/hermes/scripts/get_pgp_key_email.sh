/usr/bin/gpg --list-packets /opt/hermes/tmp/THE-FILE | awk -F: '/^:user ID packet:/ { print $3 }' 2>&1
