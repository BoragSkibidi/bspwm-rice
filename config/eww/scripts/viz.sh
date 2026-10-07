#!/usr/bin/env bash
# cava -> a JSON array for eww, e.g. [12,45,78,33]. Restarts cava if it exits
# (for example when the audio server isn't up yet).
conf="$(dirname "$(readlink -f "$0")")/../cava.conf"

while true; do
    cava -p "$conf" 2>/dev/null | sed -u 's/;$//; s/;/,/g; s/.*/[&]/'
    sleep 2
done
