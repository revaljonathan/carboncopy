#!/bin/bash

swayidle -w \
  timeout 450 'brightnessctl -s set 5%' \
  resume 'brightnessctl -r' \
  timeout 900 'niri msg action power-off-monitors' \
  resume 'niri msg action power-on-monitors' \
  timeout 1200 '~/.local/bin/dynalock.sh' \
  before-sleep "~/.local/bin/dynalock.sh"
