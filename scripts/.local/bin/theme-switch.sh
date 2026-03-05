#!/bin/bash
WALLPAPER=$1
THEME=$(basename $(dirname "$WALLPAPER"))
WAL_THEME="$HOME/.config/wal/themes/${THEME}.json"

# Map theme to icon pack
case "$THEME" in
  amethyst) ICON_THEME="Tela-purple-dark" ;;
  aquamarine) ICON_THEME="Nordzy" ;;
  *) ICON_THEME="Tela-purple-dark" ;;
esac

# Set current wallpaper for Hyprlock
ln -sf "$WALLPAPER" "$HOME/dotfiles/wallpaper/.current_wallpaper"

# Apply Pywal theme (generates all cache files first)
wal --theme "$WAL_THEME" -q

# Apply symlinks to generated files
ln -sf ~/.cache/wal/colors-gtk4.css ~/.config/gtk-4.0/gtk.css
ln -sf ~/.cache/wal/yazi-theme.toml "$HOME/.config/yazi/theme.toml"

# Apply GTK settings
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Update Hyprlock theme name
sed -i "/### TAG BOT ###/,/^}/ s/text\s*=\s*.*/text        = ${THEME^^}/" "$HOME/dotfiles/hypr/.config/hypr/hyprlock.conf"

# Reload apps
killall waybar && waybar &
pkill swaync; swaync &
pkill -SIGUSR1 rofi 2>/dev/null
echo "Theme switched to $THEME"
