#!/bin/sh
set -e

# =========================================================
# RootGuard Unbound – Immutable Runtime Entrypoint
# ---------------------------------------------------------
# Runtime Model:
#  - PID 1 runs as root
#  - No ownership modification
#  - No trust anchor bootstrap
#  - Assumes state directory already initialized
#  - Unbound drops privileges internally
#
# This entrypoint is used ONLY for runtime operation.
# Volume preparation must be handled separately.
# =========================================================

echo "[RootGuard] Starting Unbound (immutable runtime mode)..."

exec "$@"