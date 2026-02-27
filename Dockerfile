############################################################
# RootGuard Unbound
# Debian 13 compliant recursive resolver
############################################################

FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create writable directory for trust anchor
RUN mkdir -p /var/lib/unbound \
    && mkdir -p /run/unbound \
    && chown -R unbound:unbound /var/lib/unbound \
    && chown -R unbound:unbound /run/unbound

COPY unbound.conf /etc/unbound/unbound.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 5335/tcp
EXPOSE 5335/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]