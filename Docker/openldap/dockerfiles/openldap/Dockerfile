FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ARG OPENLDAP_VER=2.6.7

###############################################################################
# Install build dependencies and runtime tooling (groff-base, rsyslog-mysql)
#
# tzdata is REQUIRED and easy to lose: ubuntu:24.04 does not ship it and
# --no-install-recommends will not pull it in. Without /usr/share/zoneinfo,
# glibc cannot resolve TZ=America/New_York as a zone path, falls back to
# parsing it as a POSIX TZ string, and lands on UTC labelled "America".
# slapd logs reach the Syslog database through rsyslog, so a container on the
# wrong clock misaligns authentication events against mail events (#305).
###############################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libtool \
        automake \
        autoconf \
        libssl-dev \
        libevent-dev \
        libsasl2-dev \
        libargon2-dev \
        libltdl-dev \
        pkg-config \
        ca-certificates \
        wget \
        rsyslog \
        rsyslog-mysql \
        groff-base \
        tzdata \
        && rm -rf /var/lib/apt/lists/*

###############################################################################
# Build OpenLDAP from source (Argon2 + RemoteAuth + MDB backend + SASL)
###############################################################################
WORKDIR /src
RUN wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VER}.tgz && \
    tar xzf openldap-${OPENLDAP_VER}.tgz && cd openldap-${OPENLDAP_VER} && \
    ./configure \
    --enable-dynamic \
    --enable-modules \
    --enable-syslog \
    --enable-overlays=mod \
    --enable-argon2=yes \
    --enable-remoteauth=mod \
    --with-tls \
    --with-cyrus-sasl \
    --enable-mdb=mod && \
    make depend && make -j$(nproc) && make install && \
    ldconfig

###############################################################################
# Copy remoteauth.schema from the source tree to the expected schema location
###############################################################################
COPY build/remoteauth.schema /usr/local/etc/openldap/schema/remoteauth.schema


WORKDIR /
RUN rm -rf /src/*

###############################################################################
# Ensure necessary directories exist
###############################################################################
RUN mkdir -p /etc/ldap/slapd.d /var/lib/ldap /var/run/slapd

###############################################################################
# Copy only the slapd.conf template (do NOT generate /etc/ldap/slapd.d)
###############################################################################
COPY build/template-slapd.conf /template-slapd.conf

###############################################################################
# Copy entrypoint
###############################################################################
COPY entrypoints/openldap/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

###############################################################################
# Set environment/path defaults
###############################################################################
ENV LDAP_DOMAIN="ldap.local" \
    LDAP_ADMIN_USERNAME="admin" \
    LDAP_USER_USERNAME="user" \
    LDAP_ENABLE_ARGON2="true" \
    LDAP_URI="ldap://localhost" \
    LD_LIBRARY_PATH="/usr/local/lib:/usr/local/libexec/openldap"

###############################################################################
# Volumes and ports
###############################################################################
VOLUME ["/var/lib/ldap", "/var/log"]
EXPOSE 389 636

###############################################################################
# Entrypoint
###############################################################################
ENTRYPOINT ["/entrypoint.sh"]

