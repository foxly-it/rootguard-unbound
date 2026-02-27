#!/bin/sh

echo "========================================"
echo "RootGuard Unbound starting..."
echo "========================================"

############################################################
# Ensure required directories exist
############################################################
mkdir -p /var/lib/unbound
mkdir -p /run/unbound

# Correct ownership
chown -R unbound:unbound /var/lib/unbound 2>/dev/null
chown -R unbound:unbound /run/unbound 2>/dev/null

############################################################
# DNSSEC Trust Anchor Initialization
#
# Only generate if root.key is missing.
# Anchor failure should NOT abort container start.
############################################################
if [ ! -f /var/lib/unbound/root.key ]; then
    echo "Initializing DNSSEC trust anchor..."

    if unbound-anchor -a /var/lib/unbound/root.key; then
        echo "Trust anchor successfully created."
    else
        echo "Warning: unbound-anchor failed. Continuing startup."
    fi

    chown unbound:unbound /var/lib/unbound/root.key 2>/dev/null
    chmod 640 /var/lib/unbound/root.key 2>/dev/null
fi

############################################################
# Start Unbound
#
# Unbound drops privileges internally via:
# username: "unbound" in unbound.conf
############################################################
exec "$@"