# ==== CLEAR CRONTAB ====
/usr/bin/crontab -r

THE-SCHEDULED-TASKS

# ==== CREATE HERMES CRONTAB SCHEDULED TASKS BELOW ===
/bin/echo "30 0 * * * /usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report_daily.cfm &>/dev/null" >> /var/spool/cron/crontabs/root
/bin/echo "30 1 * * * /usr/bin/curl --silent http://localhost:8888/schedule/message_cleanup.cfm &>/dev/null" >> /var/spool/cron/crontabs/root
/bin/echo "15 */2 * * * /usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report.cfm?frequency=2 &>/dev/null" >> /var/spool/cron/crontabs/root
/bin/echo "15 */4 * * * /usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report.cfm?frequency=4 &>/dev/null" >> /var/spool/cron/crontabs/root
/bin/echo "15 */8 * * * /usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report.cfm?frequency=8 &>/dev/null" >> /var/spool/cron/crontabs/root
# ==== CREATE HERMES CRONTAB SCHEDULED TASKS BELOW ===

