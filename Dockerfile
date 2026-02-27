############################################
# RootGuard Unbound – Immutable Runtime
# Debian-based, DNSSEC-ready, fail-fast
############################################

# --------
# Base Image
# --------
FROM debian:stable-slim

# --------
# Install required packages
#  - unbound: DNS resolver
#  - dns-root-data: offizielle Root-Hints + Root-Key
#  - ca-certificates: TLS trust store (für spätere Erweiterungen)
# --------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unbound \
        dns-root-data \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# --------
# Prepare directories
# /etc/unbound       -> Konfiguration
# /var/lib/unbound   -> Trust Anchor (Volume!)
# --------
RUN mkdir -p /etc/unbound && \
    mkdir -p /var/lib/unbound && \
    chown -R unbound:unbound /var/lib/unbound

# --------
# Copy configuration
# --------
COPY unbound.conf /etc/unbound/unbound.conf

# --------
# Minimal Fail-Fast Entrypoint
# (Keine Generierung, kein Bootstrap!)
# --------
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# --------
# Drop privileges permanently
# Ab hier läuft alles als unbound
# --------
USER unbound

# --------
# Entry + Default Command
# --------
ENTRYPOINT ["/entrypoint.sh"]
CMD ["unbound", "-d", "-p"]