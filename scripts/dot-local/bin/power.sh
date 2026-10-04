#!/usr/bin/env bash

options="Lock\nSuspend\nReboot\nShutdown\nLogout"

selected=$(echo -e "$options" |  fuzzel  --dmenu)

case "$selected" in
    "Lock")
        ~/.local/bin/dynalock.sh
        ;;
    "Suspend")
        systemctl suspend
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
