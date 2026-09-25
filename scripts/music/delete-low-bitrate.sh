#!/bin/bash
# Deletes files listed in low-bitrate-songs.txt
# Format expected per line: "XXX kbps  -  /path/to/file.mp3"
#
# Usage:
#   ./delete-low-bitrate.sh            # dry run - shows what WOULD be deleted
#   ./delete-low-bitrate.sh --confirm  # actually deletes
set -euo pipefail

listFile="$HOME/low-bitrate-songs.txt"
mode="${1:-}"

if [[ ! -f "$listFile" ]]; then
    echo "List file not found: $listFile"
    exit 1
fi

count=0
missing=0

while IFS= read -r line; do
    # extract everything after " - "
    path="${line#*  -  }"

    if [[ ! -f "$path" ]]; then
        echo "SKIP (not found): $path"
        ((missing++)) || true
        continue
    fi

    if [[ "$mode" == "--confirm" ]]; then
        rm -- "$path"
        echo "DELETED: $path"
    else
        echo "WOULD DELETE: $path"
    fi
    ((count++)) || true
done < "$listFile"

echo ""
if [[ "$mode" == "--confirm" ]]; then
    echo "Done. Deleted $count file(s). $missing not found."
else
    echo "Dry run complete. $count file(s) would be deleted. $missing not found."
    echo "Re-run with --confirm to actually delete."
fi
