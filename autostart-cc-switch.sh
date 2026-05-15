#!/usr/bin/env bash
set -euo pipefail

LOG_DIR=${XDG_STATE_HOME:-$HOME/.local/state}/cc-switch-docker
LOG_FILE=$LOG_DIR/autostart.log
RUNNER=/home/ghz/Work/agent_ws/cc-switch-docker/run-cc-switch.sh

mkdir -p "$LOG_DIR"

{
  echo "[$(date --iso-8601=seconds)] CC Switch autostart requested"

  if [[ ! -x "$RUNNER" ]]; then
    echo "Runner is not executable: $RUNNER"
    exit 1
  fi

  for _ in $(seq 1 30); do
    if docker info >/dev/null 2>&1; then
      echo "Docker is ready"
      break
    fi
    sleep 2
  done

  if ! docker info >/dev/null 2>&1; then
    echo "Docker is not ready after waiting"
    exit 1
  fi

  exec "$RUNNER"
} >>"$LOG_FILE" 2>&1
