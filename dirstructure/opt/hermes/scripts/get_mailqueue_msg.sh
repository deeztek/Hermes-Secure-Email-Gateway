/usr/sbin/postcat THE-OPTION MESSAGE-ID | awk -F: '/THE-FIELD:/ { print $2 }'  2>&1
