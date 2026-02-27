#!/bin/sh

echo "========================================"
echo "RootGuard Unbound starting..."
echo "========================================"

############################################################
# Ensure writable trust anchor directory exists
############################################################
mkdir -p /var/lib/unbound
chown -R unbound:unbound /var/lib/unbound 2>/dev/null

############################################################
# Initialize writable trust anchor
#
# Debian provides a reference root.key in:
#   /usr/share/dns/root.key
#
# We copy it once to:
#   /var/lib/unbound/root.key
#
# This location is writable so Unbound can perform
# RFC 5011 automatic key rollover.
############################################################
if [ ! -f /var/lib/unbound/root.key ]; then
    echo "Initializing writable trust anchor..."
    cp /usr/share/dns/root.key /var/lib/unbound/root.key
    chown unbound:unbound /var/lib/unbound/root.key
    chmod 640 /var/lib/unbound/root.key
fi

############################################################
# Start Unbound
#
# Unbound:
#  - starts as root
#  - drops privileges internally via username directive
############################################################
exec "$@"
