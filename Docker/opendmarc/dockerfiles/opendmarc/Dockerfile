FROM ubuntu:24.04
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 54321

# Install postfix rsyslog opendkim dumb-init
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y opendmarc \
    rsyslog \
    rsyslog-mysql \
    dumb-init
    

#Copy necessary files

COPY config/opendmarc/etc/opendmarc/opendmarc.conf /etc/opendmarc/
COPY config/opendmarc/etc/opendmarc/whitelist.domains /etc/opendmarc/
COPY config/opendmarc/etc/rsyslog.d/mysql.conf /etc/rsyslog.d/mysql.conf

#Entrypoint
COPY entrypoints/opendmarc/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

#CMD ["clamd", "-F"]
#CMD ["amavisd-new", "foreground"]

