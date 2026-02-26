FROM debian:stable-slim

LABEL org.opencontainers.image.title="rootguard-unbound"
LABEL org.opencontainers.image.description="Unbound DNS Resolver based on official Debian packages"
LABEL org.opencontainers.image.vendor="Rootguard"
LABEL org.opencontainers.image.source="https://github.com/foxly-it/rootguard-unbound"

ENV DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------------------------
# Install Unbound and required runtime components
# --------------------------------------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unbound \
      dns-root-data \
      dnsutils \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------
# Prepare runtime directory (will be replaced by volume if mounted)
# --------------------------------------------------------------------
RUN mkdir -p /var/lib/unbound

# --------------------------------------------------------------------
# Copy configuration and runtime helpers
# --------------------------------------------------------------------
COPY unbound.conf /etc/unbound/unbound.conf
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/healthcheck.sh /entrypoint.sh

# --------------------------------------------------------------------
# Network exposure (internal engine port)
# --------------------------------------------------------------------
EXPOSE 5335/tcp 5335/udp

# --------------------------------------------------------------------
# Healthcheck
# --------------------------------------------------------------------
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

# --------------------------------------------------------------------
# Runtime bootstrap + unbound foreground execution
# --------------------------------------------------------------------
ENTRYPOINT ["/entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]