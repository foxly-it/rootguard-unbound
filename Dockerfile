# =========================================================
# RootGuard Unbound – Enterprise DNS Engine
# ---------------------------------------------------------
# Base: Debian stable-slim
#
# Design Goals:
#  - Use official Debian unbound package
#  - Use Debian-maintained dns-root-data
#  - No unbound-anchor runtime bootstrap
#  - Container-first logging model
#  - Hardened runtime compatible
# =========================================================

FROM debian:stable-slim

# ---------------------------------------------------------
# OCI Metadata
# ---------------------------------------------------------

LABEL org.opencontainers.image.title="rootguard-unbound"
LABEL org.opencontainers.image.description="Unbound DNS Resolver based on official Debian packages"
LABEL org.opencontainers.image.vendor="Rootguard"
LABEL org.opencontainers.image.source="https://github.com/foxly-it/rootguard-unbound"

ENV DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------
# Install Required Packages
# ---------------------------------------------------------
#
# unbound        → DNS resolver engine
# dns-root-data  → Debian-maintained root trust anchor
# dnsutils       → provides dig (useful for debugging)
# ca-certificates → TLS trust store
#
# IMPORTANT:
#  - unbound-anchor is NOT installed
#  - No runtime anchor generation
#  - Debian root.key is used instead
# ---------------------------------------------------------

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unbound \
      dns-root-data \
      dnsutils \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------

COPY unbound.conf /etc/unbound/unbound.conf
COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /entrypoint.sh /usr/local/bin/healthcheck.sh

# ---------------------------------------------------------
# Network
# ---------------------------------------------------------

EXPOSE 5335/tcp 5335/udp

# ---------------------------------------------------------
# Healthcheck
# ---------------------------------------------------------

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

# ---------------------------------------------------------
# Runtime
# ---------------------------------------------------------
#
# PID 1 = entrypoint (root)
# Unbound drops privileges internally via config:
#   username: "unbound"
# ---------------------------------------------------------

ENTRYPOINT ["/entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]