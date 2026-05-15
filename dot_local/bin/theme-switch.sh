#!/bin/bash
#!/bin/bash
WALLPAPER=$1
THEME=$(basename $(dirname "$WALLPAPER"))
WAL_THEME="$HOME/.config/wal/themes/${THEME}.json"
CURRENT_THEME_FILE="$HOME/.cache/wal/current-theme"
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE" 2>/dev/null)

# Set current wallpaper for Hyprlock
ln -sf "$WALLPAPER" "$HOME/dotfiles/wallpaper/.current_wallpaper"
swww img "$WALLPAPER" --transition-type wipe --transition-duration 1

# Apply Pywal theme (generates all cache files first)
wal --theme "$WAL_THEME" -q

if [ "$THEME" != "$CURRENT_THEME" ]; then
    # Map theme to icon pack
    case "$THEME" in
      amethyst) ICON_THEME="Tela-purple-dark" ;;
      aquamarine) ICON_THEME="Nordzy" ;;
      *) ICON_THEME="Tela-purple-dark" ;;
    esac

    # Apply symlinks to generated files
    ln -sf ~/.cache/wal/colors-gtk4.css ~/.config/gtk-4.0/gtk.css
    ln -sf ~/.cache/wal/yazi-theme.toml "$HOME/.config/yazi/theme.toml"

    # Update Vencord theme
    cp ~/.cache/wal/discord.css ~/.var/app/com.discordapp.Discord/config/Vencord/themes/${THEME}.css
    python3 -c "
import json
with open('$HOME/.var/app/com.discordapp.Discord/config/Vencord/settings/settings.json', 'r') as f:
    s = json.load(f)
s['enabledThemes'] = ['${THEME}.css']
with open('$HOME/.var/app/com.discordapp.Discord/config/Vencord/settings/settings.json', 'w') as f:
    json.dump(s, f, indent=4)
"
	if flatpak ps | grep -q com.discordapp.Discord; then
        flatpak kill com.discordapp.Discord && flatpak run com.discordapp.Discord &
    fi

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

    # Save current theme
    echo "$THEME" > "$CURRENT_THEME_FILE"
fi

echo "Theme switched to $THEME"
