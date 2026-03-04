#!/bin/bash

WALLPAPER=$1
THEME=$(basename $(dirname "$WALLPAPER"))
WAL_THEME="$HOME/.config/wal/themes/${THEME}.json"

# Set current wallpaper for Hyprlock
ln -sf "$WALLPAPER" "$HOME/dotfiles/wallpaper/.current_wallpaper"

# Apply Pywal theme
wal --theme "$WAL_THEME" -q
sed -i "/### TAG BOT ###/,/^}/ s/text\s*=\s*.*/text        = ${THEME^^}/" "$HOME/dotfiles/hypr/.config/hypr/hyprlock.conf"
ln -sf ~/.cache/wal/yazi-theme.toml "$HOME/.config/yazi/theme.toml"

# Reload apps
killall waybar && waybar &
pkill swaync; swaync &
pkill -SIGUSR1 rofi 2>/dev/null

echo "Theme switched to $THEME"
