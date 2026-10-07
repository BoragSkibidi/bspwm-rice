#!/usr/bin/env bash
# Prints the name of the icon to show: wifi | ethernet | wifi-off
state=$(nmcli -t -f TYPE,STATE device 2>/dev/null)

if   grep -q '^wifi:connected' <<<"$state";     then echo wifi
elif grep -q '^ethernet:connected' <<<"$state"; then echo ethernet
else                                                 echo wifi-off
fi
