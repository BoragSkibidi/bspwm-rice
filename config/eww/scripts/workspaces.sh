#!/usr/bin/env bash
# Prints the bspwm desktops as JSON every time bspwm reports a change:
# [{"name":"1","state":"focused"},{"name":"2","state":"occupied"},...]
# state = focused | occupied | urgent | empty
# Reconnects by itself, so it also works if eww starts before bspwm is ready or bspwm restarts.

parse() {
    local line=${1#W} item json=""
    local IFS=:
    for item in $line; do
        local name=${item:1} state
        case ${item:0:1} in
            O|F|U) state=focused ;;
            o)     state=occupied ;;
            u)     state=urgent ;;
            f)     state=empty ;;
            *)     continue ;;   # monitors (M/m) and layout/state/flags (L/T/G)
        esac
        json+="{\"name\":\"$name\",\"state\":\"$state\"},"
    done
    printf '[%s]\n' "${json%,}"
}

while true; do
    status=$(bspc wm --get-status 2>/dev/null) && [[ -n $status ]] && parse "$status"
    bspc subscribe report 2>/dev/null | while read -r line; do
        parse "$line"
    done
    sleep 1
done
