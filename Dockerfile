############################################################
# RootGuard Unbound
# Debian 13 (Trixie) based recursive DNS resolver
# DNSSEC validating, container-native
############################################################

# ----------------------------------------------------------
# Base image
# ----------------------------------------------------------
FROM debian:stable-slim

# ----------------------------------------------------------
# Install required packages
#
# unbound        -> DNS resolver
# dns-root-data  -> provides root.hints and root.key
# ca-certificates -> TLS trust store
#
# NOTE:
# No unbound-anchor required for Debian 13.
# ----------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# Create writable directories
#
# /var/lib/unbound  -> writable trust anchor location
# /run/unbound      -> runtime (PID/socket files)
#
# Debian normally creates these via systemd.
# In containers, we must create them manually.
# ----------------------------------------------------------
RUN mkdir -p /var/lib/unbound \
    && mkdir -p /run/unbound \
    && chown -R unbound:unbound /var/lib/unbound \
    && chown -R unbound:unbound /run/unbound

# ----------------------------------------------------------
# Copy configuration
# ----------------------------------------------------------
COPY unbound.conf /etc/unbound/unbound.conf

# ----------------------------------------------------------
# Copy entrypoint
# ----------------------------------------------------------
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# ----------------------------------------------------------
# Expose DNS port
# ----------------------------------------------------------
EXPOSE 5335/tcp
EXPOSE 5335/udp

# ----------------------------------------------------------
# Entrypoint + default command
#
# - Entrypoint handles trust anchor initialization
# - CMD starts unbound in foreground mode
# ----------------------------------------------------------
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]