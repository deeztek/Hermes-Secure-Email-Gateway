FROM ubuntu:24.04
LABEL maintainer="Deeztek <support@deeztek.com>"

ENV DEBIAN_FRONTEND=noninteractive

# Install Dovecot 2.4 from official repo + quota-warning script dependencies.
# tzdata is required so the TZ env var works - without it, glibc has no
# zoneinfo database to look up IANA names like "America/New_York" and
# silently falls back to UTC. --no-install-recommends excludes tzdata by
# default, so we install it explicitly.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        dumb-init \
        tzdata \
    && curl -fsSL https://repo.dovecot.org/DOVECOT-REPO-GPG-2.4 \
        | gpg --dearmor -o /usr/share/keyrings/dovecot-2.4.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/dovecot-2.4.gpg] https://repo.dovecot.org/ce-2.4-latest/ubuntu/noble noble main" \
        > /etc/apt/sources.list.d/dovecot.list \
    && apt-get update && \
    apt-get install -y --no-install-recommends \
        dovecot-core \
        dovecot-imapd \
        dovecot-pop3d \
        dovecot-lmtpd \
        dovecot-submissiond \
        dovecot-managesieved \
        dovecot-sieve \
        dovecot-ldap \
        dovecot-mysql \
        dovecot-lua \
        lua-sql-mysql \
        default-mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Remove default ubuntu user (UID/GID 1000) and create vmail in its place
RUN userdel -r ubuntu 2>/dev/null || true && \
    groupadd -g 1000 vmail && \
    useradd -u 1000 -g 1000 -d /srv/mail -s /sbin/nologin vmail && \
    mkdir -p /srv/mail /logs /scripts /keys && \
    chown -R vmail:vmail /srv/mail /logs

# Copy entrypoint script
COPY entrypoints/dovecot/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 993 995 143 110 24 4190 9587

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]
