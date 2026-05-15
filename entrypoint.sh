#!/usr/bin/env bash
set -euo pipefail

APPIMAGE=${CC_SWITCH_APPIMAGE:-/downloads/CC-Switch-v3.14.1-Linux-x86_64.AppImage}

if [[ ! -f "$APPIMAGE" ]]; then
  echo "CC Switch AppImage not found: $APPIMAGE" >&2
  echo "Mount the directory containing the AppImage to /downloads or set CC_SWITCH_APPIMAGE." >&2
  exit 1
fi

chmod +x "$APPIMAGE" 2>/dev/null || true

if [[ "${CC_SWITCH_EXTRACT:-0}" == "1" ]]; then
  workdir=${CC_SWITCH_WORKDIR:-/tmp/cc-switch-appimage}
  rm -rf "$workdir"
  mkdir -p "$workdir"
  cd "$workdir"
  "$APPIMAGE" --appimage-extract >/tmp/cc-switch-appimage-extract.log 2>&1
  exec ./squashfs-root/AppRun "$@"
fi

exec "$APPIMAGE" "$@"
