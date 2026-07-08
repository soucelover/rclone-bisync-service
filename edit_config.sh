#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/rclone-bisync-service/
CONFIG_PATH=$CONFIG_DIR/config

mkdir -p $CONFIG_DIR

if [[ ! -f "$CONFIG_PATH" ]]; then
    install ./config.default $CONFIG_PATH
fi

nano $CONFIG_PATH
