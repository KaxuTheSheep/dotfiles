#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/.env"

target="${1:-}"

case "$target" in
  phone)
    rsync -av --delete -e "ssh -p ${PHONE_PORT}" \
      ~/Music/ \
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
