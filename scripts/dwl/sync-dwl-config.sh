#!/usr/bin/env bash
set -euo pipefail
 
# Usage: config-sync.sh [version]
#   no argument  -> target the version emerge would pick right now
#   0.8 / 0.9    -> target that version explicitly
 
CFG="${DWL_CONFIG:-$HOME/.config/dwl/config.h}"
 
if [ ! -r "$CFG" ]; then
    echo "Config not found: $CFG" >&2
    exit 1
fi
 
if [ $# -ge 1 ]; then
    PF="dwl-${1#dwl-}"
else
    # best_visible = what emerge will build (respects masks/keywords),
    # unlike best_version, which is what is installed right now
    ATOM=$(portageq best_visible / gui-wm/dwl)
    ATOM="${ATOM%%::*}"
    PF="${ATOM#gui-wm/}"
fi
 
if [ -z "$PF" ] || [ "$PF" = "dwl-" ]; then
    echo "Could not determine a dwl version" >&2
    exit 1
fi
 
DEST="/etc/portage/savedconfig/gui-wm/${PF}"
 
doas install -Dm644 "$CFG" "$DEST"
echo "Synced $CFG -> $DEST"
 
if ! grep -rqsw savedconfig /etc/portage/package.use /etc/portage/make.conf; then
    echo "Note: no USE=savedconfig found for gui-wm/dwl; the build will ignore this file" >&2
fi
 
echo "Run: doas emerge -1av =gui-wm/${PF}"

