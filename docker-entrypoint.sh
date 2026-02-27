#!/bin/sh

echo "========================================"
echo "RootGuard Unbound starting..."
echo "========================================"

# Ensure writable trust anchor directory
mkdir -p /var/lib/unbound
chown -R unbound:unbound /var/lib/unbound

# Copy Debian root.key if not already present
if [ ! -f /var/lib/unbound/root.key ]; then
    echo "Initializing writable trust anchor..."
    cp /usr/share/dns/root.key /var/lib/unbound/root.key
    chown unbound:unbound /var/lib/unbound/root.key
    chmod 640 /var/lib/unbound/root.key
fi

exec "$@"
