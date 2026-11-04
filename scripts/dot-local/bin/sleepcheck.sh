#!/usr/bin/bash

if [ "$(~/.local/bin/caf.sh status)" = "Caffeinated" ]; then
    notify-send -a "system" "you cant suspend, caffeine is ON" "turn it off first"
else
    ~/.local/bin/dynalock.sh 
    systemctl suspend
fi
