# =============================================================================
# Hermes SEG OpenARC container - RFC 8617 Authenticated Received Chain.
#
# Built from upstream source on ubuntu:24.04 because Ubuntu dropped the
# `openarc` package starting with 24.04 noble (last available in 23.10
# mantic). Building from source keeps this container on the same base as
# every other Hermes service and pins the exact version we ship.
#
# Source: github.com/flowerysong/OpenARC (Paul Arthur's maintained fork).
#
# Why this fork rather than trusteddomainproject/OpenARC: the canonical
# trusteddomainproject repo has been frozen at "Beta3" since Sept 2019;
# the flowerysong fork cuts real v1.x stable releases on a regular cadence
# (latest v1.3.0, Oct 2024), incorporates M365 compatibility fixes, ships
# an `openarc-keygen` utility (we no longer need opendkim-tools), and
# implements RFC 8617's `oldest-pass` chain validation. Same single-domain
# (per-installation) architecture as upstream Beta3 -- which matches the
# industry pattern of one ARC signing identity per gateway (Gmail signs
# as d=google.com, M365 as d=outlook.com, Fastmail as d=fastmail.com,
# Hermes as d=<gateway hostname>).
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: builder
# -----------------------------------------------------------------------------
FROM ubuntu:24.04 AS builder

ARG OPENARC_VERSION=1.3.0

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        build-essential \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libmilter-dev \
        libssl-dev \
        libbsd-dev \
        libidn2-dev \
        libjansson-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
# Use the maintainer-published release tarball (NOT GitHub's auto-generated
# /archive/refs/tags/v*.tar.gz). The release tarball ships a pre-generated
# `configure` script and extracts to a lowercase `openarc-<version>` dir
# (GitHub's auto-tarball would extract to `OpenARC-<version>`).
#
# `make install DESTDIR=/staging` puts everything `make install` would normally
# write directly to / under /staging instead. The runtime stage then COPYs
# /staging/ to /, capturing the daemon binary, libraries, Python helpers
# (openarc-keygen and friends), manpages, etc., regardless of which subdir
# the maintainer chose (/usr/sbin vs /usr/bin vs /usr/libexec, etc.).
RUN wget -q "https://github.com/flowerysong/OpenARC/releases/download/v${OPENARC_VERSION}/openarc-${OPENARC_VERSION}.tar.gz" -O openarc.tar.gz && \
    tar xzf openarc.tar.gz && \
    cd "openarc-${OPENARC_VERSION}" && \
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --sbindir=/usr/sbin && \
    make && \
    make install DESTDIR=/staging

# -----------------------------------------------------------------------------
# Stage 2: runtime
# -----------------------------------------------------------------------------
FROM ubuntu:24.04
MAINTAINER Deeztek <support@hermesseg.io>
EXPOSE 8893

# Runtime deps (shared libs OpenARC links against + ops glue):
#   libmilter1.0.1        -- Sendmail milter library
#   libssl3               -- OpenSSL/crypto
#   libbsd0               -- BSD string/util functions
#   libidn2-0             -- internationalized domain names (added by flowerysong fork)
#   libjansson4           -- JSON output (added by flowerysong fork)
#   python3               -- flowerysong rewrote openarc-keygen (and friends)
#                            in Python; Ubuntu 24.04's default 3.12 satisfies
#                            the >=3.8 floor
#   python3-cryptography  -- RSA key generation used by openarc-keygen
#   rsyslog               -- log routing
#   dumb-init             -- PID 1
#
# Note: opendkim-tools is NOT installed here. flowerysong's openarc-keygen
# replaces opendkim-genkey, so we can drop that cross-tool dependency.
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        libmilter1.0.1 \
        libssl3 \
        libbsd0 \
        libidn2-0 \
        libjansson4 \
        python3 \
        python3-cryptography \
        rsyslog \
        dumb-init \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Dedicated system user (no shell, no home dir) matching the Debian-packaged
# convention so /opt/hermes/arc/keys/*.arc.private can be chowned correctly.
RUN groupadd -r openarc && \
    useradd -r -g openarc -d /var/lib/openarc -s /usr/sbin/nologin openarc

# Pull in everything `make install` produced. The builder stage runs
# `make install DESTDIR=/staging` so /staging mirrors what would otherwise
# land directly under /. Copying /staging/ to / captures the daemon binary,
# libopenarc.so* family, openarc-keygen (whether maintainer put it in
# /usr/sbin or /usr/bin), manpages, and any other helpers shipped by the
# release tarball.
COPY --from=builder /staging/ /

# Refresh the dynamic linker cache so `ld.so` resolves libopenarc.so.0.
RUN ldconfig

# Pre-create runtime dirs (entrypoint chowns them at startup as belt-and-
# suspenders against host-bind-mount permissions surprises).
RUN mkdir -p /var/run/openarc /etc/openarc /opt/hermes/arc/keys && \
    chown -R openarc:openarc /var/run/openarc /etc/openarc /opt/hermes/arc

# NOTE: openarc.conf, TrustedHosts, and rsyslog.d/openarc.conf are NOT baked
# into the image. Runtime config lives at the host's config/openarc/... tree
# and is volume-mounted by docker-compose (matching the project convention
# that anything the Web GUI may regenerate must not be baked in).

COPY entrypoints/openarc/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]
