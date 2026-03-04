#!/bin/bash

WALLPAPER=$1
THEME=$(basename $(dirname "$WALLPAPER"))
WAL_THEME="$HOME/dotfiles/wal/themes/${THEME}.json"

# Set current wallpaper for Hyprlock
ln -sf "$WALLPAPER" "$HOME/dotfiles/wallpaper/.current_wallpaper"

# Apply Pywal theme
wal --theme "$WAL_THEME" -q

# Reload apps
killall waybar && waybar &
pkill swaync; swaync &
pkill -SIGUSR1 rofi 2>/dev/null

echo "Theme switched to $THEME"
