/usr/bin/mailq | awk '/^[A-Z0-9]/ {print $1}' | sed -e 's/\*//' >> /opt/hermes/tmp/THE-TRANSACTION_mailqueue_list
