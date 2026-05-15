#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=${IMAGE_NAME:-cc-switch-ubuntu22:local}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

docker build -t "$IMAGE_NAME" "$SCRIPT_DIR"
