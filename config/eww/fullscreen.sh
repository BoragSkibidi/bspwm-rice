#!/bin/bash

exec 9>"${XDG_RUNTIME_DIR:-/tmp}/eww-fullscreen-${UID}.lock"
flock -n 9 || exit 0

update_layer() {
    if bspc query -N -d focused -n .fullscreen.!hidden > /dev/null; then
        xdo lower -N "Eww"
    else
        xdo raise -N "Eww"
    fi
}

sleep 1
update_layer

bspc subscribe node_state desktop_focus node_transfer node_remove | while read -r _; do
    update_layer
done
