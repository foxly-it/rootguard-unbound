#!/bin/sh
set -e

# Ensure runtime directory ownership (important for Docker volumes)
chown -R unbound:unbound /var/lib/unbound

# Drop privileges and start Unbound
exec su -s /bin/sh -c "$*" unbound