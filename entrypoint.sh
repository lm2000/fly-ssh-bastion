#!/bin/sh
set -eu

authorized_keys=/home/tunnel/.ssh/authorized_keys
umask 077
: > "$authorized_keys"

if [ -n "${OPERATOR_PUBLIC_KEY:-}" ]; then
  printf '%s\n' "$OPERATOR_PUBLIC_KEY" >> "$authorized_keys"
fi

if [ -n "${GATEWAY_PUBLIC_KEY:-}" ]; then
  printf '%s %s\n' 'no-agent-forwarding,no-X11-forwarding,no-pty,permitlisten="127.0.0.1:2200"' "$GATEWAY_PUBLIC_KEY" >> "$authorized_keys"
fi

chown tunnel:tunnel "$authorized_keys"
chmod 0600 "$authorized_keys"

if [ ! -s "$authorized_keys" ]; then
  echo 'No authorized public keys configured; refusing to start sshd.' >&2
  exit 1
fi

exec /usr/sbin/sshd -D -e -f /etc/ssh/sshd_config
