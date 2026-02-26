#!/bin/sh
set -e

# --------------------------------------------------------------------
# Ensure runtime directory exists
# --------------------------------------------------------------------
mkdir -p /var/lib/unbound

# --------------------------------------------------------------------
# Bootstrap trust anchor on first start
# --------------------------------------------------------------------
if [ ! -f /var/lib/unbound/root.key ]; then
    cp /usr/share/dns/root.key /var/lib/unbound/root.key
fi

# --------------------------------------------------------------------
# Fix ownership (important if Docker volume is mounted)
# --------------------------------------------------------------------
chown -R unbound:unbound /var/lib/unbound

# --------------------------------------------------------------------
# Start Unbound (Debian will drop privileges internally)
# --------------------------------------------------------------------
exec "$@"