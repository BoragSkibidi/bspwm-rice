#!/bin/bash
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
