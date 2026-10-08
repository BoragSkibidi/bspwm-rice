#!/usr/bin/env bash
exec {fd}<> <(:)

while :; do
	now=$EPOCHREALTIME
	secs=${now%[.,]*}
	frac=${now#*[.,]}
	printf -v day  '%(%A)T'        "$secs"
	printf -v date '%(%d %B %Y)T'  "$secs"
	printf -v hms  '%(%H:%M:%S)T'  "$secs"
	printf '{"day":"%s","date":"%s","time":"%s:%s"}\n' "$day" "$date" "$hms" "${frac:0:3}"
	read -rt 0.05 -u "$fd"
done
