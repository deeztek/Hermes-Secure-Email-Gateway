FROM ubuntu:24.04
LABEL maintainer="Deeztek <support@deeztek.com>"

# Hermes SEG Body Milter (#214 Disclaimers, future #226 Signatures,
# #228 External Banner, Link Guard).
#
# Single-purpose container running a Python milter that postfix
# connects to via TCP at hermes_body_milter:8893. See
# Docker/body_milter/config/usr/local/bin/hermes-body-milter for the
# implementation and architecture notes.

EXPOSE 8893

RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-milter \
        python3-bs4 \
        python3-lxml \
        dumb-init \
        ca-certificates \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# Milter entrypoint
COPY config/usr/local/bin/hermes-body-milter /usr/local/bin/hermes-body-milter
RUN chmod +x /usr/local/bin/hermes-body-milter

# Container entrypoint
COPY entrypoints/body_milter/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]
