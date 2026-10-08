#!/usr/bin/env bash
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
