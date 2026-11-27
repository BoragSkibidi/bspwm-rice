#!/usr/bin/env bash
set -euo pipefail

DISPLAY_NUM=1
STEP=5
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-brightness"
PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-brightness.pid"
STATE_LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-brightness-state.lock"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-brightness.lock"

apply_debounce() {
  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null || true
  fi

  (
    sleep 0.08
    exec 8>"$LOCK_FILE"
    flock -w 2 8
    target=$(cat "$STATE_FILE")
    ddcutil --display "$DISPLAY_NUM" setvcp 10 "$target"
  ) </dev/null &

  echo $! >"$PID_FILE"
}

case "${1:-get}" in
get)
  val=$(ddcutil --display "$DISPLAY_NUM" getvcp 10 --brief | awk '{print $4}')
  val="${val:-100}"
  echo "$val" >"$STATE_FILE"
  echo "$val"
  ;;
up | down | reset)
  exec 9>"$STATE_LOCK_FILE"
  flock -x 9
  current=$(cat "$STATE_FILE" 2>/dev/null || echo 100)
  case "$1" in
  up) next=$((current + STEP > 100 ? 100 : current + STEP)) ;;
  down) next=$((current - STEP < 0 ? 0 : current - STEP)) ;;
  reset) next=100 ;;
  esac
  echo "$next" >"$STATE_FILE"
  flock -u 9
  eww update brightness="$next"
  apply_debounce
  ;;
esac
