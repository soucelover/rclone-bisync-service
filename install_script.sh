#!/usr/bin/env bash

set -euo pipefail

SERVICE_NAME="rclone-bisync"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rclone-bisync-service"
CONFIG_FILE="$CONFIG_DIR/config"
SYSTEMD_DIR="$HOME/.config/systemd/user"

INTERVAL="${SYNC_INTERVAL_MINUTES:-5}"

mkdir -p \
    "$BIN_DIR" \
    "$CONFIG_DIR" \
    "$SYSTEMD_DIR"

install -m 755 "$SCRIPT_DIR/rclone_sync.sh" "$BIN_DIR/rclone_sync.sh"
install -m 755 "$SCRIPT_DIR/rclone_sync_init.sh" "$BIN_DIR/rclone_sync_init.sh"
install -m 644 "$SCRIPT_DIR/config.default" "$BIN_DIR/rclone_sync_config.default"

if [[ ! -f "$CONFIG_FILE" ]]; then
    cp "$BIN_DIR/rclone_sync_config.default" "$CONFIG_FILE"

    echo "Created default configuration:"
    echo "  $CONFIG_FILE"
else
    echo "Using existing configuration:"
    echo "  $CONFIG_FILE"
fi

cat >"$SYSTEMD_DIR/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Periodic rclone bisync

[Service]
Type=oneshot
ExecStart=$BIN_DIR/rclone_sync.sh
EOF

cat >"$SYSTEMD_DIR/${SERVICE_NAME}.timer" <<EOF
[Unit]
Description=Run rclone bisync every ${INTERVAL} minutes

[Timer]
OnBootSec=30s
OnUnitActiveSec=${INTERVAL}min
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo
echo "Initializing rclone service..."
"$BIN_DIR/rclone_sync_init.sh" "$@"

systemctl --user daemon-reload
systemctl --user enable --now "${SERVICE_NAME}.timer"

echo
echo "Installation completed successfully."
echo
echo "Timer status:"
systemctl --user --no-pager status "${SERVICE_NAME}.timer"
