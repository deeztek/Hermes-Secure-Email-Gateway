FROM ubuntu:24.04
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 10021 10030

# Install amavis, clamav, spamassassin
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y arj \
    rsyslog \
    rsyslog-mysql \
    bzip2 \
    cabextract \
    cpio \
    file \
    gzip \
    lhasa \
    nomarch \
    pax \
    rar \
    unrar \
    unzip \
    zip \
    dumb-init \
    cron \
    fangfrisch \
    git \
    software-properties-common \ 
    wget \
    make \
    net-tools \
    apt-utils \
    amavisd-new \
    libdbi-perl \
    libdbd-mysql-perl \ 
    clamav \
    clamav-daemon \
    spamassassin \
    razor \
    pyzor \
    altermime && \
    adduser clamav amavis && \
    mkdir -p /mnt/data/amavis && \
    wget https://www.dcc-servers.net/dcc/source/dcc.tar.Z -P /tmp && \
    tar -xvzf /tmp/dcc.tar.Z -C /tmp/ --strip-components=1 && \
    chmod +x /tmp/configure && \
    chmod +x /tmp/autoconf/install-sh && \
    cd /tmp && \
    ./configure --with-uid=amavis && \
    make && \
    make install && \
    chown -R amavis:amavis /var/dcc && \
    ln -s /var/dcc/libexec/dccifd /usr/local/bin/dccifd && \
    cd / && \
    rm -rf /tmp/* && \
    cdcc info && \
    cp /etc/spamassassin/v310.pre /etc/spamassassin/v310.ORIGINAL && \
    sed -i -e "s|#loadplugin Mail::SpamAssassin::Plugin::DCC|loadplugin Mail::SpamAssassin::Plugin::DCC|g" "/etc/spamassassin/v310.pre" && \
    spamassassin --lint && \
    mkdir -m 0770 -p /var/lib/fangfrisch && \
    mkdir -m 0770 -p /var/lib/fangfrisch/signatures && \
    mkdir -p /etc/fangfrisch && \
    mkdir -p /var/run/clamav && \
    chown -R clamav:clamav /var/run/clamav && \
    mkdir -p /etc/postfix && \
    mkdir -p /var/lib/amavis && \
    chown -R amavis:amavis /var/lib/amavis && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R amavis:amavis /mnt/data/amavis && \
    freshclam

#Copy necessary files

COPY config/etc/fangfrisch/fangfrisch.conf /etc/fangfrisch/fangfrisch.conf
COPY config/usr/local/bin/setup-clamav-sigs /usr/local/bin/setup-clamav-sigs
# Fangfrisch cron.d removed - now managed via Ofelia scheduled job

#Entrypoint
COPY entrypoints/mail_filter/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

#CMD ["clamd", "-F"]
#CMD ["amavisd-new", "foreground"]

