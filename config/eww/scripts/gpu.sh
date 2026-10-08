#!/usr/bin/env bash
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1
    exit
fi
for f in /sys/class/drm/card*/device/gpu_busy_percent; do
    [[ -r $f ]] && { cat "$f"; exit; }
done
exit 0
