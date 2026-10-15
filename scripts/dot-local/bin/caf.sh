#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/caffeine.state"
LOCKER="$HOME/.local/bin/dynalock.sh"

stop_idle() {
    if pgrep -x swayidle >/dev/null 2>&1; then
        pkill -x swayidle 2>/dev/null || true
        for _ in {1..20}; do
            pgrep -x swayidle >/dev/null 2>&1 || break
            sleep 0.05
        done
    fi
}

notify_ui() {
    pkill -sigrtmin+13 waybar 2>/dev/null || true
}

start_sleep() {
    stop_idle
    echo "sleep" > "$STATE_FILE"
    setsid -f swayidle -w \
        timeout 150 'brightnessctl -s set 5%' \
        resume 'brightnessctl -r' \
        timeout 300 'niri msg action power-off-monitors' \
        resume 'niri msg action power-on-monitors' \
        timeout 600 'systemctl suspend' \
        before-sleep "$LOCKER" \
        </dev/null >/dev/null 2>&1
    notify_ui
}

start_caffed() {
    stop_idle
    echo "caffed" > "$STATE_FILE"
    setsid -f swayidle -w \
        timeout 450 'brightnessctl -s set 5%' \
        resume 'brightnessctl -r' \
        timeout 900 'niri msg action power-off-monitors' \
        resume 'niri msg action power-on-monitors' \
        timeout 1200 "$LOCKER" \
        before-sleep "$LOCKER" \
        </dev/null >/dev/null 2>&1
    notify_ui
}

is_caffed() {
    if [[ -f "$STATE_FILE" ]]; then
        [[ "$(<"$STATE_FILE")" == "caffed" ]]
    else
        pgrep -f 'swayidle.*1200' >/dev/null 2>&1
    fi
}

toggle() {
    if is_caffed; then
        start_sleep
        # notify-send -a "Caffeine" "Caffeine OFF" "Normal sleep timeouts active" 2>/dev/null || true
    else
        start_caffed
        # notify-send -a "Caffeine" "Caffeine ON" "Suspend disabled, longer screen timeouts active" 2>/dev/null || true
    fi
}

ACTION="${1:-}"

if [[ -z "$ACTION" ]]; then
    case "$(basename "$0")" in
        sleep.sh)  ACTION="sleep" ;;
        caffed.sh) ACTION="caffed" ;;
        *)         ACTION="toggle" ;;
    esac
fi

case "$ACTION" in
    sleep|off|normal)
        start_sleep
        ;;
    caffed|on|caffeine)
        start_caffed
        ;;
    toggle)
        toggle
        ;;
    status)
        if is_caffed; then
            echo "Caffeinated"
        else
            echo "Sleepy"
        fi
        ;;
    is-caffed|is-caffeinated)
        if is_caffed; then
            exit 0
        else
            exit 1
        fi
        ;;
    is-sleep|is-sleepy)
        if is_caffed; then
            exit 1
        else
            exit 0
        fi
        ;;
    -h|--help)
        echo "Usage: $(basename "$0") [sleep|caffed|toggle|status|is-caffed|is-sleep]"
        echo "Controls swayidle timeout profiles (normal sleep vs caffeinated)."
        ;;
    *)
        echo "Unknown action: $ACTION" >&2
        echo "Usage: $(basename "$0") [sleep|caffed|toggle|status|is-caffed|is-sleep]" >&2
        exit 1
        ;;
esac
