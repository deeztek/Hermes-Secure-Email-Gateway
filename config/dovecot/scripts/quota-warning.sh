#!/bin/sh
PERCENT=$1
USERNAME=$2

#PERCENT=95
#USERNAME=someone@domain.tld

#GET HERMES MYSQL USERNAME AND PASSWORD
HERMES_USERNAME=`cat /opt/hermes/creds/hermes_username`
HERMES_PASSWORD=`cat /opt/hermes/creds/hermes_password`

#GET HERMES DOVECOT TOKEN TO BE USED AS THETOKEN
# Use container name for Docker internal networking
THETOKEN=$(mysql -h hermes_db_server -u $HERMES_USERNAME -p$HERMES_PASSWORD hermes -se "select token from api_tokens where name='Dovecot' and ip='172.16.32.100' and system='1' and active='1'")

# Call Hermes API using container name
curl -X "POST" -s "http://hermes_commandbox:8888/hermes-api/" -H "accept: */*" -H "X-Original-URL: /admin/2/inc/dovecot_overquota_notification.cfm?percent=$PERCENT&user=$USERNAME" -H "X-Token: $THETOKEN" #> /dev/null

