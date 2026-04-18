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

# Copy main config
COPY config/unbound.conf /etc/unbound/unbound.conf

# Create conf.d directory for admin-configurable includes
RUN mkdir -p /etc/unbound/conf.d

# Copy modular config files into conf.d (defaults, overridden by volume mount)
COPY config/forward.conf /etc/unbound/conf.d/forward.conf
COPY config/local.conf /etc/unbound/conf.d/local.conf

# Ensure unbound can read root hints and trust anchor
RUN chown -R unbound:unbound /etc/unbound

EXPOSE 53/tcp
EXPOSE 53/udp

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD drill @127.0.0.1 localhost || exit 1

ENTRYPOINT ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
