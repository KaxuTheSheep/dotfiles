#!/usr/bin/env bash
set -euo pipefail

ATOM=$(portageq best_version / gui-wm/dwl)   # gui-wm/dwl-0.7
PF="${ATOM#gui-wm/}"                          # dwl-0.7
DEST="/etc/portage/savedconfig/gui-wm/${PF}"

sudo mkdir -p "$(dirname "$DEST")"
sudo cp "$HOME/.config/dwl/config.h" "$DEST"
echo "Synced config.h -> $DEST"
echo "Run: emerge --oneshot gui-wm/dwl"
