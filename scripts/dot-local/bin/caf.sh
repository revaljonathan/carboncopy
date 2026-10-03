#!/usr/bin/env bash
set -euo pipefail

if pgrep -x sleep.sh > /dev/null; then
    pkill -x swayidle
    ~/.local/bin/caffed.sh & disown
else
    pkill -x swayidle
    ~/.local/bin/sleep.sh & disown
fi

pkill -sigrtmin+13 waybar
