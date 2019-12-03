/usr/sbin/service djigzo status | awk -F: '/Active:/ { print $2 }'
