#!/bin/bash

echo "Checking if Ciphermail is installed"
STATUS=`systemctl is-enabled ciphermail-gateway-backend.service`


if [ "${STATUS}" = "not-found" ];then
    echo "Ciphermail does not apper to be installed. Proceeding with installation..."

    echo "deb http://archive.ubuntu.com/ubuntu/ jammy universe" | tee /etc/apt/sources.list.d/jammy.list && \
    apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y procps \
    rsyslog \
    rsyslog-mysql \
    wget \
    gpg \
    gzip \
    mawk \
    openjdk-11-jre \
    openjdk-11-jre-headless \
    sudo \
    tar \
    libsasl2-modules \
    symlinks \
    tomcat9 \
    postfix && \    
    dpkg -i /build/djigzo_*_all.deb /build/ciphermail-core-os-debian_*_all.deb && \
    systemctl enable ciphermail-gateway-backend && \
    dpkg -i /build/djigzo-web_*_all.deb && \
    systemctl daemon-reload && \
    chown tomcat:djigzo /usr/share/djigzo-web/ssl/sslCertificate.p12 && \
    mkdir -p /etc/tomcat9/Catalina/localhost/ && \
    cp -b /build/main.cf /etc/postfix/main.cf && \
    cp -b /build/master.cf /etc/postfix/master.cf && \
    #cp -b /usr/share/djigzo/conf/system/postfix/main.deb.cf /etc/postfix/main.cf && \
    #cp -b /usr/share/djigzo/conf/system/postfix/master.deb.cf /etc/postfix/master.cf && \
    touch /etc/postfix/smtp_client_passwd && \
    postmap hash:/etc/postfix/smtp_client_passwd && \
    newaliases && \
    systemctl restart postfix && \
    cp /build/server.xml /etc/tomcat9/ && \
    cp /build/ciphermail.xml /etc/tomcat9/Catalina/localhost/ciphermail.xml && \
    cp /build/web.xml /etc/tomcat9/Catalina/localhost/web.xml && \
    cp /build/wrapper-additional-parameters.conf /usr/share/djigzo/wrapper/wrapper-additional-parameters.conf && \
    cp /build/smtp_server_config.xml /usr/share/djigzo/conf/james/SAR-INF/smtp_server_config.xml && \
    cp /build/smtp_transport_config.xml /usr/share/djigzo/conf/james/SAR-INF/smtp_transport_config.xml && \
    cp /build/tomcat9.service /lib/systemd/system/ && \
    systemctl daemon-reload && \
    systemctl restart rsyslog && \
    systemctl restart ciphermail-gateway-backend && \
    systemctl restart tomcat9 && \
    chmod +x /entrypoint.sh && \
    rm -rf /build

else
    echo "Ciphermail appears to be installed. Nothing to do..."
fi
