FROM ubuntu:24.04
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 8891

# Install opendkim rsyslog dumb-init
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y opendkim \
    opendkim-tools \
    rsyslog \
    rsyslog-mysql \
    dumb-init

#Copy necessary files

COPY config/opendkim/etc/opendkim.conf /etc/
COPY config/opendkim/etc/rsyslog.d/mysql.conf /etc/rsyslog.d/

#Entrypoint
COPY entrypoints/opendkim/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

#CMD ["clamd", "-F"]
#CMD ["amavisd-new", "foreground"]

