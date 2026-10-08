#!/usr/bin/env bash

state=$(nmcli -t -f TYPE,STATE device 2>/dev/null)

if   grep -q '^wifi:connected' <<<"$state";     then echo wifi
elif grep -q '^ethernet:connected' <<<"$state"; then echo ethernet
else                                                 echo wifi-off
fi
