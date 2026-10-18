#!/bin/sh
set -eu
src="$HOME/.config/librewolf-chrome"
for base in "$HOME/.config/librewolf/librewolf" "$HOME/.librewolf"; do
  [ -f "$base/profiles.ini" ] || continue
  for p in "$base"/*.default-release; do
    [ -d "$p" ] || continue
    if [ -d "$p/chrome" ] && [ ! -L "$p/chrome" ]; then
      mv "$p/chrome" "$p/chrome.bak"
    fi
    ln -sfn "$src" "$p/chrome"
  done
done