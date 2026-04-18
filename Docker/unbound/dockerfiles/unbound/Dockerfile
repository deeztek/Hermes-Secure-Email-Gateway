FROM ubuntu:24.04

LABEL maintainer="Deeztek <support@deeztek.com>"
LABEL description="Unbound DNS Resolver for Hermes SEG"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates \
        ldnsutils \
    && rm -rf /var/lib/apt/lists/*

# Ensure unbound can read/write root hints and trust anchor
RUN chown -R unbound:unbound /etc/unbound /usr/share/dns

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD drill @127.0.0.1 localhost || exit 1

ENTRYPOINT ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
