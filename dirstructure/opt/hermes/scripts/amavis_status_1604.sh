/usr/sbin/service amavis status | awk -F: '/Active:/ { print $2 }'
