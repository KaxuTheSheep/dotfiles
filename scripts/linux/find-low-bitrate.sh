#!/bin/bash
set -euo pipefail

targetDir="${1:-$HOME/Music}"
outFile="$HOME/low-bitrate-songs.txt"

: > "$outFile"

find "$targetDir" -type f -iname "*.mp3" -print0 | \
while IFS= read -r -d '' f; do
    bitrate=$(ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate \
        -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null) || {
        echo "SKIP (ffprobe failed): $f" >&2
        continue
    }
    case $bitrate in
        ''|*[!0-9]*)
            echo "SKIP (no usable bitrate '$bitrate'): $f" >&2
            continue
            ;;
    esac
    if [ "$bitrate" -lt 320000 ]; then
        printf '%d kbps  -  %s\n' "$((bitrate / 1000))" "$f" >> "$outFile"
    fi
done

count=$(wc -l < "$outFile")
echo "Done. $count file(s) under 320kbps written to $outFile"
