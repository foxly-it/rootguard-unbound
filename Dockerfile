############################################################
# RootGuard Unbound – Stable Base Image
# Debian based, DNSSEC validating, GUI-ready
############################################################

FROM debian:stable-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create required directories
RUN mkdir -p /etc/unbound \
    && mkdir -p /var/lib/unbound \
    && chown -R unbound:unbound /var/lib/unbound

# Copy default configuration
COPY unbound.conf /etc/unbound/unbound.conf

# Copy entrypoint
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5335

ENTRYPOINT ["/entrypoint.sh"]
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]