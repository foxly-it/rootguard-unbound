#!/bin/sh
set -e

echo "========================================"
echo "RootGuard Unbound starting..."
echo "========================================"

############################################################
# Ensure required directories exist
############################################################

mkdir -p /var/lib/unbound
mkdir -p /run/unbound

# Correct ownership for runtime
chown -R unbound:unbound /var/lib/unbound
chown -R unbound:unbound /run/unbound

############################################################
# DNSSEC Trust Anchor Bootstrap
#
# Only generate if missing
############################################################

if [ ! -f /var/lib/unbound/root.key ]; then
    echo "Generating DNSSEC trust anchor..."
    unbound-anchor -a /var/lib/unbound/root.key
    chown unbound:unbound /var/lib/unbound/root.key
    chmod 640 /var/lib/unbound/root.key
fi

############################################################
# Start Unbound
#
# Unbound drops privileges internally
# via: username: "unbound" in config
############################################################

exec "$@"