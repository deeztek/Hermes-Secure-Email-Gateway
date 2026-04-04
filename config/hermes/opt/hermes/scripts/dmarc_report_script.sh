#!/bin/bash

DB_SERVER='DATABASE-SERVER'
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
LOG_FILE="/var/log/dmarc_report_$TIMESTAMP.log"

mv ${WORK_DIR}/opendmarc.dat ${WORK_DIR}/opendmarc_import.dat -f >> "$LOG_FILE" 2>&1

cat /dev/null > ${WORK_DIR}/opendmarc.dat >> "$LOG_FILE" 2>&1

/usr/sbin/opendmarc-import --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose < ${WORK_DIR}/opendmarc_import.dat >> "$LOG_FILE" 2>&1

/usr/sbin/opendmarc-reports --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose --interval=86400 --report-email $REPORT_EMAIL --report-org $REPORT_ORG --smtp-server $SMTP_SERVER --smtp-port $SMTP_PORT >> "$LOG_FILE" 2>&1

/usr/sbin/opendmarc-expire --dbhost=${DB_SERVER} --dbuser=${DB_USER} --dbpasswd=${DB_PASS} --dbname=${DB_NAME} --verbose >> "$LOG_FILE" 2>&1

/bin/chown -R opendmarc:opendmarc ${WORK_DIR}/ >> "$LOG_FILE" 2>&1

ERR=$?
if [ $ERR != 0 ]; then
    THEERROR=$(($THEERROR+$ERR))

    # Send error notification via Perl Net::SMTP (sendemail not available in hermes_dmarc container)
    perl -MNet::SMTP -e '
        my $smtp = Net::SMTP->new("'"$SMTP_SERVER"':'"$SMTP_PORT"'", Timeout => 30) or exit 1;
        $smtp->mail("'"$POSTMASTER"'");
        $smtp->to("'"$POSTMASTER"'");
        $smtp->data();
        $smtp->datasend("From: '"$POSTMASTER"'\n");
        $smtp->datasend("To: '"$POSTMASTER"'\n");
        $smtp->datasend("Subject: [Hermes SEG] ['"$REPORT_ORG"'] DMARC Reports Error\n");
        $smtp->datasend("\n");
        $smtp->datasend("Hermes SEG DMARC Reports for ['"$REPORT_ORG"'] did not execute successfully. Error reported was '"$THEERROR"'.\n");
        $smtp->dataend();
        $smtp->quit();
    ' 2>> "$LOG_FILE"

    /bin/rm -f "$LOG_FILE"
    exit 1
else
    # Send success notification via Perl Net::SMTP
    perl -MNet::SMTP -e '
        my $smtp = Net::SMTP->new("'"$SMTP_SERVER"':'"$SMTP_PORT"'", Timeout => 30) or exit 0;
        $smtp->mail("'"$POSTMASTER"'");
        $smtp->to("'"$POSTMASTER"'");
        $smtp->data();
        $smtp->datasend("From: '"$POSTMASTER"'\n");
        $smtp->datasend("To: '"$POSTMASTER"'\n");
        $smtp->datasend("Subject: [Hermes SEG] ['"$REPORT_ORG"'] DMARC Reports Success\n");
        $smtp->datasend("\n");
        $smtp->datasend("Hermes SEG DMARC Reports for ['"$REPORT_ORG"'] executed successfully.\n");
        $smtp->dataend();
        $smtp->quit();
    ' 2>> "$LOG_FILE"
fi

/bin/rm -f "$LOG_FILE"
