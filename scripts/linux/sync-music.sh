#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/.env"
target="${1:-}"

sanitize_name() {
  local name="$1"
  name="${name//:/ -}"      # colon -> " -"
  name="${name//\"/'}"      # double quote -> single quote
  name="${name//</＜}"      # fullwidth 
  name="${name//>/＞}"      # fullwidth >
  name="${name//\?/？}"     # fullwidth ?
  name="${name//\*/＊}"     # fullwidth *
  name="${name//|/｜}"      # fullwidth |
  echo "$name"
}

build_staging() {
  local staging="$1"
  rm -rf "$staging"
  mkdir -p "$staging"
  find ~/Music -type f -print0 | while IFS= read -r -d '' src; do
    rel="${src#$HOME/Music/}"
    dir="$(dirname "$rel")"
    base="$(basename "$rel")"
    safe_base="$(sanitize_name "$base")"
    mkdir -p "$staging/$dir"
    ln "$src" "$staging/$dir/$safe_base"
  done
}

case "$target" in
  phone)
    STAGING="${HOME}/.cache/music-sync-staging"
    build_staging "$STAGING"
    rsync -av --delete -e "ssh -p ${PHONE_PORT}" \
      "$STAGING/" \
      "${PHONE_USER}@${PHONE_IP}:${PHONE_MUSIC_PATH}/"
    ;;
  laptop)
    rsync -av --delete -e "ssh -p ${LAPTOP_PORT}" \
      ~/Music/ \
      "${LAPTOP_USER}@${LAPTOP_IP}:${LAPTOP_MUSIC_PATH}/"
    ;;
  *)
    echo "Usage: $0 {phone|laptop}" >&2
    exit 1
    ;;
esac
