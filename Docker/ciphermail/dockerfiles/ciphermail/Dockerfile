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
#
# tzdata is REQUIRED and easy to lose: ubuntu:24.04 does not ship it and
# --no-install-recommends will not pull it in. Without /usr/share/zoneinfo,
# glibc cannot resolve TZ=America/New_York as a zone path, so it falls back to
# parsing it as a POSIX TZ string, takes "America" as the abbreviation, fails
# on "/New_York" as an offset and defaults to zero. The container then runs on
# UTC while every other Hermes container runs local time, and stamps
# "+0000 (America)" into the Received: header of every message it touches
# (#305).
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
    tzdata \
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
    # Fix permissions on scripts and binaries (dpkg -nosystemd repack may strip execute bit)
    chmod +x /usr/share/djigzo/scripts/*.sh /usr/share/djigzo/wrapper/wrapper-djigzo && \
    # Cleanup build files and apt cache
    rm -rf /build && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Entrypoint (starts services directly without systemd)
COPY entrypoints/ciphermail/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
