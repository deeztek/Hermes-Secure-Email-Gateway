#!/bin/sh

ACTION=$1
IP=$2
SOURCE=$3
TYPE=AUTOMATIC
#Debug uncomment below only if troubleshooting
#DATE=$(date)
#echo "Action: $ACTION IP: $IP $DATE Type: $TYPE" >> /scripts/test.txt

#GET HERMES MYSQL USERNAME AND PASSWORD
HERMES_USERNAME=`cat /opt/hermes/creds/hermes_username`
HERMES_PASSWORD=`cat /opt/hermes/creds/hermes_password`

#GET HERMES FAIL2BAN TOKEN TO BE USED AS THETOKEN
THETOKEN=$(mysql -h hermes_db_server -u $HERMES_USERNAME -p$HERMES_PASSWORD hermes -se "select token from api_tokens where name='Fail2ban' and ip='172.16.32.102' and system='1' and active='1'")

curl -X "POST" -s "http://host.docker.internal:8888/hermes-api/" -H "accept: */*" -H "X-Original-URL: /admin/2/inc/fail2ban_ban_unban.cfm?action=$ACTION&ip=$IP&type=$TYPE&source=$SOURCE" -H "X-Token: $THETOKEN" #> /dev/null
