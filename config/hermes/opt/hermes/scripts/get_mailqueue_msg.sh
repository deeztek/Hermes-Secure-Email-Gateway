/usr/local/bin/docker exec hermes_postfix_dkim /usr/sbin/postcat -qh MESSAGE-ID | awk -F: '/THE-FIELD: / { print $2 }'  2>&1
