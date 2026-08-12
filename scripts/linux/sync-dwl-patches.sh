#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/.config/dwl/patches"
DEST="$HOME/kaxu-overlay/gui-wm/dwl/files"

if [ ! -d "$SRC" ]; then
    echo "Source patch dir not found: $SRC"
    exit 1
fi

mkdir -p "$DEST"

# Flatten: only *.patch files, skip READMEs and anything else, skip
# per-patch subdirectories (autostart/, movestack/) — the ebuild's files/
# dir is flat.
shopt -s nullglob
found=0
for patch in "$SRC"/*/*.patch; do
    found=1
    base="$(basename "$patch")"
    cp -v "$patch" "$DEST/$base"
done

if [ "$found" -eq 0 ]; then
    echo "No .patch files found under $SRC"
    exit 0
fi

echo
echo "Synced patches to $DEST"
echo "Reminder: this only copies files. You still need to:"
echo "  1. Update dwl-0.8.ebuild if patch filenames changed"
echo "  2. Regenerate the Manifest (ebuild --manifest or repoman manifest)"
echo "  3. emerge --oneshot gui-wm/dwl to actually rebuild"
