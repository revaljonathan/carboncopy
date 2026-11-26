#!/usr/bin/env bash

options="Lock\nLock n power off monitor\nSuspend\nReboot\nShutdown\nLogout"

selected=$(echo -e "$options" |  fuzzel  --dmenu)

case "$selected" in
    "Lock")
        ~/.local/bin/dynalock.sh
        ;;
    "Lock n power off monitor")
        ~/.local/bin/dynalock.sh
        niri msg action power-off-monitors
        ;;
    "Suspend")
        ~/.local/bin/sleepcheck.sh
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Logout")
        niri msg action quit --skip-confirmation
        ;;
    *)
        exit 0
        ;;
esac
