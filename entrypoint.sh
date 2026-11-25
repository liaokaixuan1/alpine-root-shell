#!/bin/sh
# Alpine root web shell over ttyd. Container runs as root (uid 0) by default.
set -eu

PORT="${PORT:-8080}"
TTYD_USER="${TTYD_USER:-admin}"
TTYD_PASS="${TTYD_PASS:-}"

if [ -z "$TTYD_PASS" ]; then
  TTYD_PASS="$(head -c 18 /dev/urandom | base64 | tr -d '/+=' | head -c 16)"
fi

# Persist creds so they survive a redeploy read
mkdir -p /root
printf '%s\n' "$TTYD_USER" > /root/.ttyd_user
printf '%s\n' "$TTYD_PASS" > /root/.ttyd_pass
chmod 600 /root/.ttyd_pass

echo "=================================================="
echo " alpine-root web shell"
echo " user: $TTYD_USER"
echo " pass: $TTYD_PASS"
echo " port: $PORT"
echo " uid : $(id -u)  ($(id -un))"
echo "=================================================="

export TMPDIR=/tmp
export HOME=/root

exec /usr/bin/ttyd \
  -p "$PORT" \
  -i 0.0.0.0 \
  -b / \
  -w /root \
  -W \
  -t rendererType=canvas \
  -t fontSize=15 \
  -c "$TTYD_USER:$TTYD_PASS" \
  /bin/bash -l