#!/usr/bin/env bash
emit() {
    local class word out=""
    class=$(bspc query -T -n focused 2>/dev/null | grep -oP '"className":"\K[^"]*')
    class=${class##*.}
    class=${class//[-_]/ }
    for word in $class; do out+="${word^} "; done
    printf '%s\n' "${out% }"
}

while true; do
    emit
    bspc subscribe node_focus node_remove node_add desktop_focus monitor_focus 2>/dev/null |
        while read -r _; do emit; done
    sleep 1
done
