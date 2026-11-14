#!/bin/sh
set -eu

SRC="${DWL_PATCHES:-$HOME/.config/dwl/patches}"
PKGDIR="${DWL_OVERLAY:-$HOME/kaxu-overlay/gui-wm/dwl}"
DEST="$PKGDIR/files"

[ -d "$SRC" ] || { echo "Source patch dir not found: $SRC" >&2; exit 1; }
mkdir -p "$DEST"

tmp=$(mktemp -d) || { echo "mktemp failed" >&2; exit 1; }
trap 'rm -rf "$tmp"' EXIT INT TERM

versions=""
for e in "$PKGDIR"/dwl-*.ebuild; do
    [ -e "$e" ] || continue
    v=${e##*/dwl-}
    v=${v%.ebuild}
    case $v in
        *-r[0-9]*) v=${v%-r[0-9]*} ;;
        9999*) ;;
        *) versions="$versions $v" ;;
    esac
done
[ -n "$versions" ] || { echo "No dwl ebuilds found in $PKGDIR" >&2; exit 1; }

: > "$tmp/list"
for v in $versions; do
    for patch in "$SRC"/*/*-"$v".patch; do
        [ -e "$patch" ] || continue
        base=${patch##*/}
        printf '%s\t%s\n' "$base" "$patch" >> "$tmp/list"
    done
done

dups=$(cut -f1 "$tmp/list" | sort | uniq -d)
if [ -n "$dups" ]; then
    printf 'Name collision: %s\n' $dups >&2
    printf '%s\n' "$dups" | while IFS= read -r d; do
        grep "^${d}	" "$tmp/list" | cut -f2 | sed 's/^/    /' >&2
    done
    exit 1
fi

while IFS='	' read -r base path; do
    cp -v "$path" "$DEST/$base"
done < "$tmp/list"

: > "$tmp/names"
cut -f1 "$tmp/list" | sort -u > "$tmp/names"
for f in "$DEST"/*.patch; do
    [ -e "$f" ] || continue
    base=${f##*/}
    if ! grep -qxF "$base" "$tmp/names"; then
        rm -v "$f"
    fi
done

for e in "$PKGDIR"/dwl-*.ebuild; do
    [ -e "$e" ] || continue
    v=${e##*/dwl-}
    v=${v%.ebuild}
    case $v in *-r[0-9]*) v=${v%-r[0-9]*} ;; esac

    grep -o '\${FILESDIR}/[^"]*' "$e" 2>/dev/null \
        | sed 's#^\${FILESDIR}/##' \
        | sed "s|\\\${PV}|$v|g" > "$tmp/refs" || true

    while IFS= read -r ref; do
        [ -n "$ref" ] || continue
        [ -f "$DEST/$ref" ] || \
            echo "WARNING: ${e##*/} references missing files/$ref" >&2
    done < "$tmp/refs"
done

echo
echo "Synced patches to $DEST"
if command -v pkgdev >/dev/null 2>&1; then
    ( cd "$PKGDIR" && pkgdev manifest )
else
    echo "pkgdev not found; run: cd $PKGDIR && ebuild dwl-<version>.ebuild manifest"
fi
echo "Next: emerge -1 gui-wm/dwl"