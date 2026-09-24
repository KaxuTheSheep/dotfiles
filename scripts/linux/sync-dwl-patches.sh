#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/.config/dwl/patches"
PKGDIR="$HOME/kaxu-overlay/gui-wm/dwl"
DEST="$PKGDIR/files"

if [ ! -d "$SRC" ]; then
    echo "Source patch dir not found: $SRC" >&2
    exit 1
fi
mkdir -p "$DEST"
shopt -s nullglob

# Versions that have an ebuild in the overlay (live ebuilds ignored,
# revisions stripped: dwl-0.9-r1.ebuild -> 0.9)
versions=()
for e in "$PKGDIR"/dwl-*.ebuild; do
    v="${e##*/dwl-}"
    v="${v%.ebuild}"
    v="${v%-r[0-9]*}"
    if [[ $v != 9999* ]]; then
        versions+=("$v")
    fi
done
if [ "${#versions[@]}" -eq 0 ]; then
    echo "No dwl ebuilds found in $PKGDIR" >&2
    exit 1
fi

# Only take <name>-<version>.patch for versions actually shipped.
# Skips other versions, READMEs and per-patch subdirectory clutter.
declare -A wanted=()
for v in "${versions[@]}"; do
    for patch in "$SRC"/*/*-"$v".patch; do
        base="${patch##*/}"
        if [[ -n ${wanted[$base]:-} ]]; then
            echo "Name collision: $base ($patch vs ${wanted[$base]})" >&2
            exit 1
        fi
        wanted[$base]="$patch"
    done
done

for base in "${!wanted[@]}"; do
    cp -v "${wanted[$base]}" "$DEST/$base"
done

# Prune stale patches
for f in "$DEST"/*.patch; do
    base="${f##*/}"
    if [[ -z ${wanted[$base]:-} ]]; then
        rm -v "$f"
    fi
done

# Every patch an ebuild references must exist
pv_pat='${PV}'
for e in "$PKGDIR"/dwl-*.ebuild; do
    v="${e##*/dwl-}"
    v="${v%.ebuild}"
    v="${v%-r[0-9]*}"
    while IFS= read -r ref; do
        ref="${ref//"$pv_pat"/$v}"
        if [ ! -f "$DEST/$ref" ]; then
            echo "WARNING: ${e##*/} references missing files/$ref" >&2
        fi
    done < <(grep -o '\${FILESDIR}/[^"]*' "$e" | sed 's#^\${FILESDIR}/##' || true)
done

echo
echo "Synced patches to $DEST"
if command -v pkgdev >/dev/null; then
    (cd "$PKGDIR" && pkgdev manifest)
else
    echo "pkgdev not found; run: cd $PKGDIR && ebuild dwl-<version>.ebuild manifest"
fi
echo "Next: emerge -1 gui-wm/dwl"
