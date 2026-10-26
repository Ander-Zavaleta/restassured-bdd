#!/bin/sh
set -e

# El repositorio llega montado desde Windows: Git debe confiar en esa carpeta.
git config --global --add safe.directory /workspace

exec code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  --disable-telemetry \
  /workspace
