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
COPY config/ /config/

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
    mkdir -p /etc/default && \
    cp /config/ciphermail/etc/cm-pam-authenticate /etc/default/cm-pam-authenticate && \
    cp /build/smtp_server_config.xml /usr/share/djigzo/conf/james/SAR-INF/smtp_server_config.xml && \
    cp /build/smtp_transport_config.xml /usr/share/djigzo/conf/james/SAR-INF/smtp_transport_config.xml && \
    # Fix permissions on scripts and binaries (dpkg -nosystemd repack may strip execute bit)
    chmod +x /usr/share/djigzo/scripts/*.sh /usr/share/djigzo/wrapper/wrapper-djigzo && \
    # Replay djigzo postinst init that the -nosystemd repack stripped (it replaced
    # the whole postinst with `exit 0`). Without this the backend cannot find the
    # PAM auth script (scripts are registered from scripts.d/ symlinks) and the
    # djigzo user is not allowed to run it as root, so web GUI PAM login fails.
    # configure_scripts: register scripts via scripts.d/ symlinks
    chmod -R 755 /usr/share/djigzo/scripts/* && \
    mkdir -p /usr/share/djigzo/scripts/scripts.d && \
    ( cd /usr/share/djigzo/scripts/scripts.d && \
      ln -fs ../backup.sh && \
      ln -fs ../fetchmail.sh && \
      ln -fs ../pam-authenticate.sh && \
      ln -fs ../postfix-main-config.sh && \
      ln -fs ../postfix-tls.sh && \
      ln -fs ../postfix.sh && \
      ln -fs ../sasl.sh && \
      ln -fs ../ssl.sh && \
      ln -fs ../system.sh ) && \
    # configure_sudoers: allow djigzo user to run scripts as root (needed for PAM)
    visudo -c -f /usr/share/djigzo/conf/system/ciphermail.sudo > /dev/null && \
    cp /usr/share/djigzo/conf/system/ciphermail.sudo /etc/sudoers.d/ciphermail && \
    chown root:root /etc/sudoers.d/ciphermail && \
    chmod 0440 /etc/sudoers.d/ciphermail && \
    visudo -c > /dev/null && \
    # configure_backup: register backup fragments
    chmod -R 755 /usr/share/djigzo/conf/backup.d/ && \
    ( cd /usr/share/djigzo/conf/backup.d && ln -fs ../backup_files ) && \
    chmod 644 /usr/share/djigzo/conf/backup_files && \
    # Cleanup build files and apt cache
    rm -rf /build /config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Entrypoint (starts services directly without systemd)
COPY entrypoints/ciphermail/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
