FROM jrei/systemd-ubuntu:24.04
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 2525 8443

#Copy necessary files
COPY downloads/*.deb /
COPY downloads/*.tar.gz /
COPY downloads/tomcat9.service /etc/systemd/system


# Install pre-requisites
RUN apt-get update && \
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
    symlinks && \
    mkdir /opt/tomcat && \
    groupadd tomcat && \
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat && \
    tar xzvf /apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1 && \
    chown -R tomcat:tomcat /opt/tomcat && \
    chmod +x /opt/tomcat/bin/*.sh && \
    chmod -R 755 /opt/tomcat && \
    chown -R tomcat:tomcat /opt/tomcat/logs && \
    cd / && \
    bash -c "/usr/sbin/init" && \
    dpkg -i --ignore-depends=postfix djigzo_*_all.deb ciphermail-core-os-debian_*_all.deb && \
    systemctl enable ciphermail-gateway-backend && \
    dpkg -i --ignore-depends=postfix djigzo-web_*_all.deb && \
    systemctl daemon-reload && \
    systemctl enable tomcat9
    

#Entrypoint
COPY entrypoints/ciphermail/entrypoint.sh /

RUN chmod +x /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["/entrypoint.sh"]

