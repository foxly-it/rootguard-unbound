#!/bin/sh

echo "========================================"
echo "RootGuard Unbound starting..."
echo "========================================"

############################################################
# Ensure runtime directory exists
############################################################
mkdir -p /run/unbound
chown -R unbound:unbound /run/unbound 2>/dev/null

############################################################
# Start Unbound
#
# Unbound will:
#  - read root.key from /usr/share/dns/root.key
#  - drop privileges to user "unbound"
############################################################
exec "$@"
