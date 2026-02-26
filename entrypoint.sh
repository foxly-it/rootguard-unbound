#!/bin/sh
set -e

# =========================================================
# RootGuard Unbound – Enterprise Entrypoint
# ---------------------------------------------------------
# Runtime Model:
#  - PID 1 runs as root
#  - Mounted state directory is prepared
#  - Ownership is fixed for runtime user
#  - DNSSEC trust anchor is bootstrapped if missing
#  - Unbound drops privileges internally
#
# Security Model:
#  - Requires CAP_CHOWN
#  - Requires CAP_SETUID
#  - Requires CAP_SETGID
#  - No filesystem modifications outside state dir
# =========================================================

STATE_DIR="/var/lib/unbound"
ROOTKEY="$STATE_DIR/root.key"

echo "[RootGuard] Preparing state directory..."

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Fix ownership (required for Docker volume mounts)
chown -R unbound:unbound "$STATE_DIR"

# Initialize DNSSEC trust anchor if not present
if [ ! -f "$ROOTKEY" ]; then
    echo "[RootGuard] Initializing DNSSEC trust anchor..."
    unbound-anchor -a "$ROOTKEY"
fi

echo "[RootGuard] Starting Unbound..."

exec "$@"