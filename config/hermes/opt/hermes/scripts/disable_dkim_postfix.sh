/usr/sbin/postconf -e "milter_protocol = 2"
/usr/sbin/postconf -e "milter_default_action = accept"
/usr/sbin/postconf -e "smtpd_milters = "
/usr/sbin/postconf -e "non_smtpd_milters = "
