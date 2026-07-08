#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rclone-bisync-service/"
CONFIG_PATH="$CONFIG_DIR/config"

if [[ ! -f "$CONFIG_PATH" ]]; then
    echo "Copying default configuration"

    mkdir -p "$CONFIG_DIR"
    cp "$HOME/.local/bin/config.default" "$CONFIG_PATH"
fi

source "$CONFIG_PATH"

: "${LOCAL_DIR:=$HOME/Google_Drive}"
: "${REMOTE_DIR:=gdrive:}"
: "${COMPARE:=size,modtime}"
: "${MODWINDOW:=1s}"

if [[ ! -v RCLONE_FLAGS ]]; then
    RCLONE_FLAGS=(
        --create-empty-src-dirs
        --metadata
        --track-renames
        --fix-case
        --drive-skip-gdocs
        --drive-skip-shortcuts
        --drive-skip-dangling-shortcuts
    )
fi

mkdir -p "$LOCAL_DIR"

if [[ ${1:-} == "--resync" ]]; then
    echo "Initializing local directory $LOCAL_DIR from remote $REMOTE_DIR..."

    rclone bisync \
        "$REMOTE_DIR" \
        "$LOCAL_DIR" \
        --resync \
        --max-lock 2m \
        --compare "$COMPARE" \
        --modify-window "$MODWINDOW" \
        "${RCLONE_FLAGS[@]}"
else
    echo "Performing initial bisync resync between $LOCAL_DIR and $REMOTE_DIR..."
    rclone sync \
        "$REMOTE_DIR" \
        "$LOCAL_DIR" \
        --progress \
        --modify-window "$MODWINDOW" \
        "${RCLONE_FLAGS[@]}"
fi

echo "Sync done"
