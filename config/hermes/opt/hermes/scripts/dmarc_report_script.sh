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

# Guard: skip SMTP notification if POSTMASTER is not a valid email address.
# Prevents queue pollution with undeliverable bare-local-part addresses.
case "$POSTMASTER" in
    *@*.*) POSTMASTER_VALID=1 ;;
    *)     POSTMASTER_VALID=0 ;;
esac

if [ $ERR != 0 ]; then
    THEERROR=$(($THEERROR+$ERR))

    if [ "$POSTMASTER_VALID" = "1" ]; then
        # Pass values via environment to avoid Perl's @array interpolation on
        # email addresses (e.g. postmaster@deeztek.net would lose @deeztek).
        POSTMASTER_ARG="$POSTMASTER" \
        REPORT_ORG_ARG="$REPORT_ORG" \
        SMTP_SERVER_ARG="$SMTP_SERVER" \
        SMTP_PORT_ARG="$SMTP_PORT" \
        THEERROR_ARG="$THEERROR" \
        perl -MNet::SMTP -e '
            my $pm   = $ENV{POSTMASTER_ARG};
            my $org  = $ENV{REPORT_ORG_ARG};
            my $host = $ENV{SMTP_SERVER_ARG};
            my $port = $ENV{SMTP_PORT_ARG};
            my $err  = $ENV{THEERROR_ARG};
            my $smtp = Net::SMTP->new("$host:$port", Timeout => 30) or exit 1;
            $smtp->mail($pm);
            $smtp->to($pm);
            $smtp->data();
            $smtp->datasend("From: $pm\n");
            $smtp->datasend("To: $pm\n");
            $smtp->datasend("Subject: [Hermes SEG] [$org] DMARC Reports Error\n");
            $smtp->datasend("\n");
            $smtp->datasend("Hermes SEG DMARC Reports for [$org] did not execute successfully. Error reported was $err.\n");
            $smtp->dataend();
            $smtp->quit();
        ' 2>> "$LOG_FILE"
    else
        echo "WARNING: POSTMASTER ($POSTMASTER) is not a valid email address; skipping error notification." >> "$LOG_FILE"
    fi

    /bin/rm -f "$LOG_FILE"
    exit 1
else
    if [ "$POSTMASTER_VALID" = "1" ]; then
        POSTMASTER_ARG="$POSTMASTER" \
        REPORT_ORG_ARG="$REPORT_ORG" \
        SMTP_SERVER_ARG="$SMTP_SERVER" \
        SMTP_PORT_ARG="$SMTP_PORT" \
        perl -MNet::SMTP -e '
            my $pm   = $ENV{POSTMASTER_ARG};
            my $org  = $ENV{REPORT_ORG_ARG};
            my $host = $ENV{SMTP_SERVER_ARG};
            my $port = $ENV{SMTP_PORT_ARG};
            my $smtp = Net::SMTP->new("$host:$port", Timeout => 30) or exit 0;
            $smtp->mail($pm);
            $smtp->to($pm);
            $smtp->data();
            $smtp->datasend("From: $pm\n");
            $smtp->datasend("To: $pm\n");
            $smtp->datasend("Subject: [Hermes SEG] [$org] DMARC Reports Success\n");
            $smtp->datasend("\n");
            $smtp->datasend("Hermes SEG DMARC Reports for [$org] executed successfully.\n");
            $smtp->dataend();
            $smtp->quit();
        ' 2>> "$LOG_FILE"
    else
        echo "WARNING: POSTMASTER ($POSTMASTER) is not a valid email address; skipping success notification." >> "$LOG_FILE"
    fi
fi

/bin/rm -f "$LOG_FILE"
