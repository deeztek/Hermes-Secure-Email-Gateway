awk -v i=$THEMESSAGE -F: '/Subject:/ { print $2 }' < /i/
