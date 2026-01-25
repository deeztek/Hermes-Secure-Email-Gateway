FROM ubuntu:24.04
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 80 443

# Install postfix rsyslog opendkim dumb-init
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y nginx \
    libnginx-mod-http-headers-more-filter \
    rsyslog \
    inetutils-ping \
    dumb-init

#Copy necessary files
#Copy nginx.conf with Hermes SEG Logging config

#Remove nginx default config
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default

#RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

#Entrypoint
COPY entrypoints/nginx/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

