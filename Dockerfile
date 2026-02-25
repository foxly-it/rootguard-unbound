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

# Create system user (no fixed UID)
RUN groupadd --system unbound \
 && useradd --system --gid unbound --no-create-home \
    --shell /usr/sbin/nologin unbound

COPY unbound.conf /etc/unbound/unbound.conf
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/healthcheck.sh \
 && chown -R unbound:unbound /etc/unbound /usr/local/bin/healthcheck.sh

USER unbound

EXPOSE 5335/tcp 5335/udp

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]