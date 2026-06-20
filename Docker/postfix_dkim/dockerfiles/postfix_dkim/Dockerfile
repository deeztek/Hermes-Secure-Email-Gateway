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

#Copy necessary files

#COPY config/postfix-dkim/etc/opendkim.conf /etc/
#COPY config/postfix-dkim/etc/rsyslog.d/ /etc/

#Entrypoint
COPY entrypoints/postfix_dkim/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

#CMD ["clamd", "-F"]
#CMD ["amavisd-new", "foreground"]

