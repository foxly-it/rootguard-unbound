FROM debian:stable-slim

LABEL org.opencontainers.image.title="rootguard-unbound"
LABEL org.opencontainers.image.description="RootGuard DNS Engine (Unbound based on Debian packages)"
LABEL org.opencontainers.image.vendor="Foxly RootGuard"
LABEL org.opencontainers.image.source="https://github.com/foxly-it/rootguard-unbound"

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal required packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unbound \
      dnsutils \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Create non-root runtime user
RUN groupadd -g 1000 unbound \
 && useradd -u 1000 -g unbound -s /usr/sbin/nologin -m unbound

# Copy default engine configuration
COPY unbound.conf /etc/unbound/unbound.conf
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/healthcheck.sh \
 && chown -R unbound:unbound /etc/unbound /usr/local/bin/healthcheck.sh

USER unbound

EXPOSE 5335/tcp 5335/udp

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]