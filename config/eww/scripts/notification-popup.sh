#!/usr/bin/env bash
set -euo pipefail

if (($# < 5)); then
    printf 'Expected Dunst arguments: appname summary body icon urgency\n' >&2
    exit 2
fi

json_string() {
    python3 -c 'import json, sys; print(json.dumps(sys.argv[1], ensure_ascii=False))' "$1"
}

eww close notification-popup >/dev/null 2>&1 || true
eww update \
    "notification_app=$(json_string "$1")" \
    "notification_summary=$(json_string "$2")" \
    "notification_body=$(json_string "$3")" \
    "notification_urgency=$(json_string "$5")"
eww open --duration 5s notification-popup
