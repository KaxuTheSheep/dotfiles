#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/.local/libexec/xdg-desktop-portal-termfilechooser/xdgtermfilechooser.initd"
DEST="/etc/init.d/xdgtermfilechooser"

if [ ! -f "$SRC" ]; then
    echo "Tracked init script not found: $SRC"
    exit 1
fi

sudo cp "$SRC" "$DEST"
sudo chmod 755 "$DEST"
echo "Synced $SRC -> $DEST"
echo "Reminder: this only copies the file. OpenRC doesn't need a restart for"
echo "an already-running service's script edits to take effect next start,"
echo "but if the service is currently running, run: rc-service xdgtermfilechooser restart"
