#!/bin/sh
set -e

############################################
# RootGuard Runtime Validation
############################################

# Prüfen ob Trust Anchor existiert
if [ ! -f /var/lib/unbound/root.key ]; then
  echo "========================================"
  echo "FATAL: root.key missing."
  echo "This container is immutable."
  echo "Run init phase before starting runtime."
  echo "========================================"
  exit 1
fi

# Start Unbound
exec "$@"