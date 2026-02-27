############################################################
# RootGuard Unbound
# Debian 13 (Trixie) based recursive resolver
############################################################

FROM debian:stable-slim

############################################################
# Install required packages
#
# unbound        -> DNS resolver
# dns-root-data  -> root.hints + root.key
# ca-certificates -> TLS trust store
############################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

############################################################
# Create runtime directory
#
# /run/unbound is required because we do not use systemd
############################################################
RUN mkdir -p /run/unbound && \
    chown -R unbound:unbound /run/unbound

############################################################
# Copy configuration
############################################################
COPY unbound.conf /etc/unbound/unbound.conf

############################################################
# Copy entrypoint
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