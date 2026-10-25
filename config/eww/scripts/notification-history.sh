#!/usr/bin/env bash
set -o pipefail

dunstctl history | python3 -c '
import json
import sys

response = json.load(sys.stdin)
raw_items = response["data"][0]
items = []

for raw in raw_items:
    def value(name):
        return raw[name]["data"]

    items.append({
        "id": value("id"),
        "appname": value("appname"),
        "summary": value("summary"),
        "body": value("body"),
        "urgency": value("urgency"),
    })

print(json.dumps(items, ensure_ascii=False))
'
