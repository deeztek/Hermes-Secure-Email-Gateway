/usr/sbin/service postfix status | awk -F: '/Active:/ { print $2 }'
