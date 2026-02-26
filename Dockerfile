FROM debian:stable-slim

LABEL org.opencontainers.image.title="rootguard-unbound"
LABEL org.opencontainers.image.description="Unbound DNS Resolver based on official Debian packages"
LABEL org.opencontainers.image.vendor="Rootguard"
LABEL org.opencontainers.image.source="https://github.com/foxly-it/rootguard-unbound"

ENV DEBIAN_FRONTEND=noninteractive

# Install Unbound and required packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unbound \
      unbound-anchor \
      dnsutils \
      ca-certificates \
      dns-root-data \
 && rm -rf /var/lib/apt/lists/*

# Copy configuration
COPY unbound.conf /etc/unbound/unbound.conf
COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /entrypoint.sh /usr/local/bin/healthcheck.sh

EXPOSE 5335/tcp 5335/udp

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]