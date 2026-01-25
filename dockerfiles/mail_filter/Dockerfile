FROM ubuntu:24.04
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
    pyzor && \
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
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R amavis:amavis /mnt/data/amavis && \
    freshclam

#Copy necessary files

COPY config/etc/fangfrisch/fangfrisch.conf /etc/fangfrisch/fangfrisch.conf
COPY config/usr/local/bin/setup-clamav-sigs /usr/local/bin/setup-clamav-sigs
COPY config/etc/cron.d/fangfrisch /etc/cron.d/fangfrisch
COPY config/etc/amavis/black.lst /etc/amavis/black.lst
COPY config/etc/amavis/white.lst /etc/amavis/white.lst
COPY config/etc/amavis/mynetworks /etc/amavis/mynetworks
COPY config/etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user
COPY config/etc/mailname /etc/mailname
COPY config/etc/cron.d/fangfrisch /etc/cron.d/fangfrisch
COPY config/etc/spamassassin/local.cf /etc/spamassassin/local.cf
COPY config/etc/postfix/relay_domains /etc/postfix/relay_domains

#Entrypoint
COPY entrypoints/mail_filter/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

