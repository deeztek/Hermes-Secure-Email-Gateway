FROM ubuntu:24.04
LABEL maintainer="Deeztek <support@deeztek.com>"
EXPOSE 2525 8443

# Copy build files (use -nosystemd.deb variants created by repack-debs-nosystemd.sh)
COPY build/*-nosystemd.deb /build/
COPY build/*.tar.gz /build/
COPY build/main.cf /build/
COPY build/master.cf /build/
COPY build/server.xml /build/
COPY build/ciphermail.xml /build/
COPY build/web.xml /build/
COPY build/wrapper-additional-parameters.conf /build/
COPY build/smtp_server_config.xml /build/
COPY build/smtp_transport_config.xml /build/

# Install pre-requisites and ciphermail packages
RUN echo "deb http://archive.ubuntu.com/ubuntu/ jammy universe" | tee /etc/apt/sources.list.d/jammy.list && \
    apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends procps \
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
    # Install ciphermail packages (using -nosystemd variants with no-op postinst)
    dpkg -i /build/djigzo_*-nosystemd.deb /build/ciphermail-core-os-debian_*-nosystemd.deb && \
    dpkg -i /build/djigzo-web_*-nosystemd.deb && \
    # Configure permissions and files
    chown tomcat:djigzo /usr/share/djigzo-web/ssl/sslCertificate.p12 && \
    mkdir -p /etc/tomcat9/Catalina/localhost/ && \
    cp /build/main.cf /etc/postfix/main.cf && \
    cp /build/master.cf /etc/postfix/master.cf && \
    touch /etc/postfix/smtp_client_passwd && \
    postmap hash:/etc/postfix/smtp_client_passwd && \
    newaliases && \
    cp /build/server.xml /etc/tomcat9/ && \
    cp /build/ciphermail.xml /etc/tomcat9/Catalina/localhost/ciphermail.xml && \
    cp /build/web.xml /etc/tomcat9/Catalina/localhost/web.xml && \
    cp /build/wrapper-additional-parameters.conf /usr/share/djigzo/wrapper/wrapper-additional-parameters.conf && \
    cp /build/smtp_server_config.xml /usr/share/djigzo/conf/james/SAR-INF/smtp_server_config.xml && \
    cp /build/smtp_transport_config.xml /usr/share/djigzo/conf/james/SAR-INF/smtp_transport_config.xml && \
    # Cleanup build files and apt cache
    rm -rf /build && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Entrypoint (starts services directly without systemd)
COPY entrypoints/ciphermail/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
