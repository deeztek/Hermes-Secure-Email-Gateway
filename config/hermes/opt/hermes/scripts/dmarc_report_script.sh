#!/bin/bash

DB_SERVER='localhost'
DB_USER='DATABASE-USER'
DB_PASS='DATABASE-PASSWORD'
DB_NAME='opendmarc'
WORK_DIR='/etc/opendmarc'
REPORT_EMAIL='REPORTING-EMAIL'
REPORT_ORG='REPORTING-ORGANIZATION'
SMTP_SERVER='hermes_postfix_dkim'
SMTP_PORT='10026'
POSTMASTER='POSTMASTER-EMAIL'

#Set install_log Date/Time Stamp
TIMESTAMP=$(date +%m-%d-%Y-%H%M)
LOG_FILE="/opt/hermes/schedule/dmarc_report_$TIMESTAMP.log"

mv ${WORK_DIR}/opendmarc.dat ${WORK_DIR}/opendmarc_import.dat -f >> "$LOG_FILE" 2>&1

cat /dev/null > ${WORK_DIR}/opendmarc.dat >> "$LOG_FILE" 2>&1

/usr/sbin/opendmarc-import --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose < ${WORK_DIR}/opendmarc_import.dat >> "$LOG_FILE" 2>&1

/usr/sbin/opendmarc-reports --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose --interval=86400 --report-email $REPORT_EMAIL --report-org $REPORT_ORG --smtp-server $SMTP_SERVER --smtp-port $SMTP_PORT >> "$LOG_FILE" 2>&1

/usr/sbin/opendmarc-expire --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose >> "$LOG_FILE" 2>&1

/usr/local/bin/docker exec hermes_dmarc /bin/chown -R opendmarc:opendmarc ${WORK_DIR}/ >> "$LOG_FILE" 2>&1

ERR=$?
if [ $ERR != 0 ]; then
    THEERROR=$(($THEERROR+$ERR))

    /usr/bin/sendemail -f $POSTMASTER -t $POSTMASTER -u "[Hermes SEG] [$REPORT_ORG] DMARC Reports Error" -m "Hermes SEG DMARC Reports for [$REPORT_ORG] did not execute successfully. Error reported was $THEERROR. Error log is attached to this e-mail" -s $SMTP_SERVER:$SMTP_PORT -a "$LOG_FILE"

    /bin/rm -f "$LOG_FILE"
    exit 1
else
    /usr/bin/sendemail -f $POSTMASTER -t $POSTMASTER -u "[Hermes SEG] [$REPORT_ORG] DMARC Reports Success" -m "Hermes SEG DMARC Reports for [$REPORT_ORG] executed successfully. Results log is attached to this e-mail" -s $SMTP_SERVER:$SMTP_PORT -a "$LOG_FILE"
fi

/bin/rm -f "$LOG_FILE"
