FROM ubuntu:24.04
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 25 587 10026 10027 8891

# Install postfix rsyslog opendkim dumb-init
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y postfix \
    postfix-mysql \
    postfix-ldap \
    postfix-pcre \
    postfix-policyd-spf-python \
    rsyslog \
    rsyslog-mysql \
    opendkim \
    opendkim-tools \
    dumb-init

# Stop storing every mail line twice (#347).
#
# Ubuntu's rsyslog package ships its default rules in
# /etc/rsyslog.d/50-default.conf, not in rsyslog.conf, and two of them both
# match mail:
#
#   *.*;auth,authpriv.none   -/var/log/syslog
#   mail.*                   -/var/log/mail.log
#
# So every Postfix line was written to both files. Measured on a live install:
# syslog 10.4 GB beside a mail.log of 10.4 GB, the same content twice, on the
# Data tier that makes Postfix defer mail when it fills.
#
# Adding mail.none to the catch-all keeps mail.log complete and leaves syslog
# with the non-mail facilities, which is what anyone reading syslog wants from
# it anyway.
#
# Safe specifically for THIS container because its entrypoint runs
# `exec tail -f /var/log/mail.log`, so nothing reads syslog here. The
# mail_filter, openarc, opendmarc and ciphermail images deliberately keep the
# duplicate: their entrypoints tail /var/log/syslog, which is how their output
# reaches `docker logs`, so excluding mail there would blind that.
#
# The ommysql rule that feeds the console Syslog database lives in the mounted
# /etc/rsyslog.d/mysql.conf, selects mail.* separately, and issues no stop, so
# it is unaffected.
RUN sed -i 's#^\*\.\*;auth,authpriv\.none#*.*;auth,authpriv.none,mail.none#' \
        /etc/rsyslog.d/50-default.conf && \
    grep -q 'mail.none' /etc/rsyslog.d/50-default.conf

#Copy necessary files

#COPY config/postfix-dkim/etc/opendkim.conf /etc/
#COPY config/postfix-dkim/etc/rsyslog.d/ /etc/

#Entrypoint
COPY entrypoints/postfix_dkim/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

#CMD ["clamd", "-F"]
#CMD ["amavisd-new", "foreground"]

