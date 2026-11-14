#!/bin/sh
set -eu
# Usage: grimshot.sh [snippet|snippet-save|fullscreen|fullscreen-save]
#   snippet          select region, copy PNG to clipboard
#   snippet-save     select region, save to file
#   fullscreen       whole output, copy PNG to clipboard
#   fullscreen-save  whole output, save to file

mode=${1:-}

SAVE_DIR=${DWL_DIR:-$HOME/Pictures/Screenshots}

geometry() {
    g=$(slurp 2>/dev/null) || return 1
    [ -n "$g" ] || return 1
    printf '%s\n' "$g"
}

save_to_file() {
    mkdir -p "$SAVE_DIR"
    ts=$(date +%Y%m%d-%H%M%S)
    f="$SAVE_DIR/shot-$ts.png"
    n=1
    while [ -e "$f" ]; do
        n=$((n + 1))
        f="$SAVE_DIR/shot-$ts-$n.png"
    done
    printf '%s\n' "$f"
}

case $mode in
    snippet)
        g=$(geometry) || exit 1
        grim -g "$g" - | wl-copy --type image/png
        ;;
    snippet-save)
        g=$(geometry) || exit 1
        f=$(save_to_file)
        grim -g "$g" "$f"
        printf '%s\n' "$f"
        ;;
    fullscreen)
        grim - | wl-copy --type image/png
        ;;
    fullscreen-save)
        f=$(save_to_file)
        grim "$f"
        printf '%s\n' "$f"
        ;;
    *)
        echo "Usage: $0 snippet|snippet-save|fullscreen|fullscreen-save" >&2
        exit 2
        ;;
esac