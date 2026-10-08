#!/bin/sh
# Dovecot quota warning: asks Hermes to email the user.
# Usage: quota-warning.sh <percent> <user>
PERCENT=$1
USERNAME=$2

curl -s -G "http://hermes_commandbox:8888/schedule/dovecot_overquota_notification.cfm" \
    --data-urlencode "percent=$PERCENT" \
    --data-urlencode "user=$USERNAME" > /dev/null
