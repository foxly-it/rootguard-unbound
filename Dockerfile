############################################################
# RootGuard Unbound
# Debian-based, DNSSEC-validating recursive resolver
# Container-native, no systemd, production-ready
############################################################

# ----------------------------------------------------------
# Base Image
# ----------------------------------------------------------
FROM debian:stable-slim

# ----------------------------------------------------------
# Install required packages
#
# unbound            -> DNS resolver
# unbound-anchor     -> DNSSEC trust anchor bootstrap
# dns-root-data      -> Official root hints from Debian
# ca-certificates    -> TLS trust store
# ----------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        unbound-anchor \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# Create required runtime directories
#
# /etc/unbound        -> configuration
# /var/lib/unbound    -> root.key (DNSSEC trust anchor)
# /run/unbound        -> pid/socket runtime files
# ----------------------------------------------------------
RUN mkdir -p /etc/unbound \
    && mkdir -p /var/lib/unbound \
    && mkdir -p /run/unbound \
    && chown -R unbound:unbound /var/lib/unbound \
    && chown -R unbound:unbound /run/unbound

# ----------------------------------------------------------
# Copy Unbound configuration
# ----------------------------------------------------------
COPY unbound.conf /etc/unbound/unbound.conf

# ----------------------------------------------------------
# Copy entrypoint script (no renaming!)
# ----------------------------------------------------------
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# ----------------------------------------------------------
# Expose internal DNS port
# (Production binding controlled via docker-compose)
# ----------------------------------------------------------
EXPOSE 5335/tcp
EXPOSE 5335/udp

# ----------------------------------------------------------
# Entrypoint + default command
#
# Entrypoint runs initialization
# CMD starts unbound in foreground mode
# ----------------------------------------------------------
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]