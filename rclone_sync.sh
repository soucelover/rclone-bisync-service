#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/rclone-bisync-service/
CONFIG_PATH=$CONFIG_DIR/config

if [ -f "$CONFIG_PATH" ]; then
    source "$CONFIG_PATH"
fi

: "${LOCAL_DIR:=$HOME/Google_Drive}"
: "${REMOTE_DIR:=gdrive:}"
: "${COMPARE:=size,modtime}"
: "${MODWINDOW:=1s}"
: "${RCLONE_FLAGS:=
    --create-empty-src-dirs
    --metadata
    --track-renames
    --fix-case
    --check-access
    --create-empty-src-dirs
    --metadata
    --track-renames
    --fix-case
    --check-access
    --drive-skip-gdocs
    --drive-skip-shortcuts
    --drive-skip-dangling-shortcuts
}"

echo "Sync started between $LOCAL_DIR and $REMOTE_DIR"

rclone bisync \
    "$LOCAL_DIR" \
    "$REMOTE_DIR" \
    --resilient \
    --recover \
    --max-lock 2m \
    --compare $COMPARE \
    --modify-window $MODWINDOW \
    "${RCLONE_FLAGS[@]}"
