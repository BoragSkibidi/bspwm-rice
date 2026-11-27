#!/usr/bin/env bash
set -euo pipefail
export LC_NUMERIC=C

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-gamma"
PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-gamma.pid"
STATE_LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-gamma-state.lock"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/eww-gamma.lock"
STEP="0.05"
MIN="0.50"
MAX="1.50"

apply_debounce() {
  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null || true
  fi

  (
    sleep 0.08
    exec 8>"$LOCK_FILE"
    flock -w 2 8
    target=$(cat "$STATE_FILE")
    output="${MONITOR_OUTPUT:-$(xrandr --query | awk '/ connected primary/{print $1; exit}')}"
    output="${output:-$(xrandr --query | awk '/ connected/{print $1; exit}')}"
    xrandr --output "$output" --gamma "${target}:${target}:${target}"
  ) </dev/null &

  echo $! >"$PID_FILE"
}

case "${1:-}" in
get)
  cat "$STATE_FILE" 2>/dev/null || echo "1.00"
  exit 0
  ;;
up)
  action=up
  ;;
down)
  action=down
  ;;
reset)
  action=reset
  ;;
*)
  cat "$STATE_FILE" 2>/dev/null || echo "1.00"
  exit 0
  ;;
esac

exec 9>"$STATE_LOCK_FILE"
flock -x 9
current=$(cat "$STATE_FILE" 2>/dev/null || echo "1.00")
case "$action" in
up)
  next=$(awk -v c="$current" -v s="$STEP" -v max="$MAX" 'BEGIN { v = c + s; if (v > max) v = max; printf "%.2f", v }')
  ;;
down)
  next=$(awk -v c="$current" -v s="$STEP" -v min="$MIN" 'BEGIN { v = c - s; if (v < min) v = min; printf "%.2f", v }')
  ;;
reset)
  next="1.00"
  ;;
esac
echo "$next" >"$STATE_FILE"
flock -u 9
eww update gamma="$next"
apply_debounce
