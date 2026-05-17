#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=${IMAGE_NAME:-cc-switch-ubuntu22:local}
CONTAINER_NAME=${CONTAINER_NAME:-cc-switch-gui}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [[ -z "${APPIMAGE_HOST:-}" ]]; then
  APPIMAGE_HOST=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name 'CC-Switch-v*-Linux-x86_64.AppImage' | sort -V | tail -n 1)
fi

APPIMAGE_DIR=$(dirname "$APPIMAGE_HOST")
APPIMAGE_FILE=$(basename "$APPIMAGE_HOST")
HOST_UID=$(id -u)
HOST_GID=$(id -g)
HOST_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$HOST_UID}
HOST_DBUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-unix:path=$HOST_RUNTIME_DIR/bus}

if [[ ! -f "$APPIMAGE_HOST" ]]; then
  echo "AppImage not found: $APPIMAGE_HOST" >&2
  echo "Place a file like CC-Switch-v3.15.0-Linux-x86_64.AppImage in $SCRIPT_DIR" >&2
  echo "or set APPIMAGE_HOST=/path/to/CC-Switch.AppImage." >&2
  exit 1
fi

mkdir -p \
  "$HOME/.cc-switch" \
  "$HOME/.agents" \
  "$HOME/.claude" \
  "$HOME/.codex" \
  "$HOME/.gemini" \
  "$HOME/.config"

tty_args=(-i)
if [[ -t 0 && -t 1 ]]; then
  tty_args=(-it)
fi

device_args=()
if [[ -e /dev/dri ]]; then
  device_args+=(--device /dev/dri)
fi

if command -v xhost >/dev/null 2>&1; then
  xhost +SI:localuser:$(id -un) >/dev/null 2>&1 || xhost +local:docker >/dev/null 2>&1 || true
fi

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

exec docker run --rm "${tty_args[@]}" \
  --name "$CONTAINER_NAME" \
  --network=host \
  --ipc=host \
  --user "$HOST_UID:$HOST_GID" \
  --group-add video \
  "${device_args[@]}" \
  -e HOME=/home/appuser \
  -e DISPLAY="${DISPLAY:-:0}" \
  -e XDG_RUNTIME_DIR="$HOST_RUNTIME_DIR" \
  -e DBUS_SESSION_BUS_ADDRESS="$HOST_DBUS_ADDRESS" \
  -e GDK_BACKEND=x11 \
  -e QT_X11_NO_MITSHM=1 \
  -e NO_AT_BRIDGE=1 \
  -e WEBKIT_DISABLE_COMPOSITING_MODE=1 \
  -e CC_SWITCH_EXTRACT="${CC_SWITCH_EXTRACT:-1}" \
  -e CC_SWITCH_APPIMAGE="/downloads/$APPIMAGE_FILE" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v "$HOST_RUNTIME_DIR:$HOST_RUNTIME_DIR:rw" \
  -v "$APPIMAGE_DIR:/downloads:ro" \
  -v "$HOME/.cc-switch:/home/appuser/.cc-switch:rw" \
  -v "$HOME/.agents:/home/appuser/.agents:rw" \
  -v "$HOME/.claude:/home/appuser/.claude:rw" \
  -v "$HOME/.codex:/home/appuser/.codex:rw" \
  -v "$HOME/.gemini:/home/appuser/.gemini:rw" \
  -v "$HOME/.config:/home/appuser/.config:rw" \
  "$IMAGE_NAME" "$@"
