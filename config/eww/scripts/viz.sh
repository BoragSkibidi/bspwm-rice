#!/usr/bin/env bash
conf="$HOME/.config/eww/cava.conf"

while true; do
    cava -p "$conf" 2>/dev/null | sed -u 's/;$//; s/;/,/g; s/.*/[&]/'
    sleep 2
done
