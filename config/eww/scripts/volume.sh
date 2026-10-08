#!/usr/bin/env bash

SINK=@DEFAULT_SINK@
MAX=150

level() { pactl get-sink-volume "$SINK" | grep -oP '\d+(?=%)' | head -1; }

case $1 in
    up)
        l=$(level)
        if (( l + 5 > MAX )); then pactl set-sink-volume "$SINK" "${MAX}%"
        else pactl set-sink-volume "$SINK" +5%; fi
        exit ;;
    down)
        pactl set-sink-volume "$SINK" -5%
        exit ;;
esac

emit() {
    local l m icon label
    l=$(level); l=${l:-0}
    m=$(pactl get-sink-mute "$SINK" | awk '{print $2}')
    if   [[ $m == yes ]]; then icon=volume-mute; label=muted; m=true
    else
        m=false; label="${l}%"
        if   (( l > 66 )); then icon=volume-high
        elif (( l > 33 )); then icon=volume-medium
        else                    icon=volume-low
        fi
    fi
    printf '{"level":%s,"muted":%s,"icon":"%s","label":"%s"}\n' "$l" "$m" "$icon" "$label"
}

while true; do
    emit
    pactl subscribe 2>/dev/null | while read -r line; do
        case $line in
            *"on sink #"*|*"on server"*) emit ;;
        esac
    done
    sleep 1        # audio server went away or isn't up yet: try again
done
