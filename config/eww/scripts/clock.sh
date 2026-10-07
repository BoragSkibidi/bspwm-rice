#!/usr/bin/env bash
# Clock with milliseconds, one JSON line every ~50 ms:
# {"day":"Wednesday","date":"07 October 2026","time":"11:03:05:482"}
# Pure bash: no processes are spawned inside the loop.

exec {fd}<> <(:)        # a pipe that never delivers data, so `read -t` works as a sleep

while :; do
    now=$EPOCHREALTIME                      # 1791342186.482113 (separator follows the locale)
    secs=${now%[.,]*}
    frac=${now#*[.,]}
    printf -v day  '%(%A)T'        "$secs"
    printf -v date '%(%d %B %Y)T'  "$secs"
    printf -v hms  '%(%H:%M:%S)T'  "$secs"
    printf '{"day":"%s","date":"%s","time":"%s:%s"}\n' "$day" "$date" "$hms" "${frac:0:3}"
    read -rt 0.05 -u "$fd"
done
