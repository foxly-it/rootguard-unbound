#!/bin/sh
set -e

# =========================================================
# RootGuard Unbound Entrypoint
# ---------------------------------------------------------
# Runs as root (PID 1)
# Unbound drops privileges internally
# No ownership manipulation
# =========================================================

ROOTKEY="/var/lib/unbound/root.key"

# Ensure working directory exists
mkdir -p /var/lib/unbound

# Initialize DNSSEC trust anchor if missing
if [ ! -f "$ROOTKEY" ]; then
    echo "Initializing DNSSEC root trust anchor..."
    unbound-anchor -a "$ROOTKEY"
fi

# Start Unbound in foreground
exec "$@"