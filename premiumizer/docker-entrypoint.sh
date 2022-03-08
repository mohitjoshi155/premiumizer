#!/usr/bin/env sh

PUID=${PUID:-6006}
PGID=${PGID:-6006}

groupmod -o -g "$PGID" premiumizer || true
usermod -o -u "$PUID" premiumizer || true

chown -R premiumizer:premiumizer /conf || true

# Allow write access on downloaded files to group and others
umask 0000

exec su-exec premiumizer "$@"

aria2c --on-download-complete=/conf/rclone.conf --disable-ipv6=true --enable-rpc --rpc-allow-origin-all --rpc-listen-all --rpc-listen-port=6800 --rpc-secret=premiumizer --max-connection-per-server=16 --file-allocation=none --disk-cache=0
