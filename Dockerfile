FROM debian:stable-slim

LABEL org.opencontainers.image.title="rootguard-unbound"
LABEL org.opencontainers.image.description="RootGuard DNS Engine (Unbound based on Debian packages)"
LABEL org.opencontainers.image.vendor="Foxly RootGuard"
LABEL org.opencontainers.image.source="https://github.com/foxly-it/rootguard-unbound"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unbound \
      dnsutils \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Non-root runtime user
RUN groupadd -g 1000 unbound \
 && useradd -u 1000 -g unbound -s /usr/sbin/nologin -m unbound

# Default fallback config (nur wenn keine Volume config existiert)
COPY default.conf /etc/unbound/unbound.conf
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/healthcheck.sh /entrypoint.sh \
 && chown -R unbound:unbound /etc/unbound

USER unbound

EXPOSE 5335/tcp 5335/udp

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]