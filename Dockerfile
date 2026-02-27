############################################################
# RootGuard Unbound
# Debian-based recursive DNS resolver with DNSSEC
############################################################

FROM debian:stable-slim

############################################################
# Install required packages
#
# - unbound            -> DNS resolver
# - dns-root-data      -> official root hints
# - ca-certificates    -> TLS trust store
############################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

############################################################
# Create required directories
#
# /etc/unbound        -> configuration
# /var/lib/unbound    -> DNSSEC trust anchor
# /run/unbound        -> runtime (pid/socket)
############################################################
RUN mkdir -p /etc/unbound \
    && mkdir -p /var/lib/unbound \
    && mkdir -p /run/unbound \
    && chown -R unbound:unbound /var/lib/unbound \
    && chown -R unbound:unbound /run/unbound

############################################################
# Copy configuration
############################################################
COPY unbound.conf /etc/unbound/unbound.conf

############################################################
# Copy entrypoint (no renaming!)
############################################################
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

############################################################
# Expose DNS port
############################################################
EXPOSE 5335/tcp
EXPOSE 5335/udp

############################################################
# Entrypoint + default command
############################################################
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]