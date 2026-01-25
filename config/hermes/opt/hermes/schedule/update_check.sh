#!/bin/bash

HERMESUSERNAME=$(</opt/hermes/creds/hermes_username)
HERMESPASSWORD=$(</opt/hermes/creds/hermes_password)
THETOKEN=$(mysql -h localhost -u $HERMESUSERNAME -p$HERMESPASSWORD -se "use hermes; select token from api_tokens where system='1' and active='1'")

echo "/usr/bin/curl -X 'POST' -k 'http://127.0.0.1:8888/hermes-api/' -H 'accept: */*' -H 'X-Original-URL: /admin/2/inc/check_system_update.cfm?sendemail=1&dev=2' -H 'X-Token: $THETOKEN'" > /opt/hermes/tmp/run.sh
bash /opt/hermes/tmp/run.sh
rm -rf /opt/hermes/tmp/run.sh
