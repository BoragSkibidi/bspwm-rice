#!/usr/bin/env bash
conf="$(dirname "$(readlink -f "$0")")/../cava.conf"

while true; do
    cava -p "$conf" 2>/dev/null | sed -u 's/;$//; s/;/,/g; s/.*/[&]/'
    sleep 2
done
