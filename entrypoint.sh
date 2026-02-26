#!/bin/sh
set -e

# =========================================================
# RootGuard Unbound – Stable Enterprise Entrypoint
# ---------------------------------------------------------
# - PID 1 runs as root
# - Ensures writable state directory
# - Copies Debian root trust anchor if missing
# - Unbound drops privileges internally
# =========================================================

STATE_DIR="/var/lib/unbound"
ROOTKEY="$STATE_DIR/root.key"
DEBIAN_ROOTKEY="/usr/share/dns/root.key"

echo "[RootGuard] Preparing state directory..."

mkdir -p "$STATE_DIR"

# Fix ownership for runtime user
chown -R unbound:unbound "$STATE_DIR"

# Bootstrap trust anchor by copying Debian-maintained file
if [ ! -f "$ROOTKEY" ]; then
    echo "[RootGuard] Installing Debian root trust anchor..."
    cp "$DEBIAN_ROOTKEY" "$ROOTKEY"
    chown unbound:unbound "$ROOTKEY"
fi

echo "[RootGuard] Starting Unbound..."

exec "$@"