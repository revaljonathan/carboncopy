#!/bin/bash

swayidle -w \
    timeout 150 'brightnessctl -s set 5%' \
    resume 'brightnessctl -r' \
    timeout 300 'niri msg action power-off-monitors' \
    resume 'niri msg action power-on-monitors' \
    timeout 600 'systemctl suspend' \
    before-sleep "~/.local/bin/dynalock.sh"
