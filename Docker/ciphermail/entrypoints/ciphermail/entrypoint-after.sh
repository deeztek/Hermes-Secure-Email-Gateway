#!/bin/bash

#Restart all services in the background
setsid systemctl restart rsyslog && systemctl restart ciphermail-gateway-backend && systemctl restart tomcat9 && systemctl restart postfix

#Run systemd
exec /sbin/init
