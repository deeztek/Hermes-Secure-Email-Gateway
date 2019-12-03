#!/bin/bash
 
DB_SERVER='localhost'
DB_USER='DATABASE-USER'
DB_PASS='DATABASE-PASSWORD'
DB_NAME='opendmarc'
WORK_DIR='/var/run/opendmarc'
REPORT_EMAIL='REPORTING-EMAIL'
REPORT_ORG='REPORTING-ORGANIZATION'
SMTP_SERVER='127.0.0.1'
SMTP_PORT='25'

 
mv ${WORK_DIR}/opendmarc.dat ${WORK_DIR}/opendmarc_import.dat -f
cat /dev/null > ${WORK_DIR}/opendmarc.dat
 
/usr/sbin/opendmarc-import --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose < ${WORK_DIR}/opendmarc_import.dat
/usr/sbin/opendmarc-reports --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose --interval=86400 --report-email $REPORT_EMAIL --report-org $REPORT_ORG --smtp-server $SMTP_SERVER --smtp-port $SMTP_PORT
/usr/sbin/opendmarc-expire --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose

