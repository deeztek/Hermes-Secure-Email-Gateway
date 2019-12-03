/usr/sbin/postconf -e "milter_protocol = 2"
/usr/sbin/postconf -e "milter_default_action = accept"
/usr/sbin/postconf -e "smtpd_milters = inet:127.0.0.1:8891"
/usr/sbin/postconf -e "non_smtpd_milters = inet:127.0.0.1:8891"
