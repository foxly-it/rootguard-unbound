#!/bin/sh
set -e

echo "Starting RootGuard Unbound..."

# Ensure trust anchor exists
if [ ! -f /var/lib/unbound/root.key ]; then
    echo "Generating DNSSEC trust anchor..."
    unbound-anchor -a /var/lib/unbound/root.key
fi

# Ensure correct ownership
chown -R unbound:unbound /var/lib/unbound

# Start Unbound
exec "$@"