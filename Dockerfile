FROM debian:stable-slim

LABEL org.opencontainers.image.title="rootguard-unbound"
LABEL org.opencontainers.image.description="Unbound DNS Resolver based on official Debian packages"
LABEL org.opencontainers.image.vendor="Rootguard"
LABEL org.opencontainers.image.source="https://github.com/foxly-it/rootguard-unbound"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unbound \
      dns-root-data \
      dnsutils \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Create runtime directory
RUN mkdir -p /var/lib/unbound \
 && chown -R unbound:unbound /var/lib/unbound

COPY unbound.conf /etc/unbound/unbound.conf
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/healthcheck.sh

EXPOSE 5335/tcp 5335/udp

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]