############################################################
# RootGuard Unbound - Production Base (Debian 13 stable-slim)
############################################################

FROM debian:stable-slim

############################################################
# Install packages
#
# - unbound        : resolver
# - dns-root-data  : root.hints + root.key (reference)
# - ca-certificates: TLS trust store
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
# /var/lib/unbound       -> writable trust anchor location
# /run/unbound           -> runtime directory
# /etc/unbound/unbound.d -> GUI modules directory
############################################################
RUN mkdir -p /var/lib/unbound \
    && mkdir -p /run/unbound \
    && mkdir -p /etc/unbound/unbound.d

############################################################
# Copy config + entrypoint
############################################################
COPY unbound.conf /etc/unbound/unbound.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

############################################################
# Expose DNS port
############################################################
EXPOSE 5335/tcp
EXPOSE 5335/udp

############################################################
# Security: run as non-root (recommended)
#
# Notes:
# - Binding to port 5335 does not require root
# - Our writable paths are under /var/lib/unbound
# - Module directory exists and is writable for later mounts
############################################################
USER unbound

############################################################
# Start command
############################################################
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]