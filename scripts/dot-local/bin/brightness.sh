#!/usr/bin/env bash
# Brightness control script using minosd OSD
# Usage: brightness.sh up|down

ACTION="$1"

case "$ACTION" in
    up)   brightnessctl set 5%+ ;;
    down) brightnessctl set 5%- ;;
    *)    echo "Usage: $0 {up|down}" >&2; exit 1 ;;
esac

# Read current brightness percentage
BRIGHTNESS=$(brightnessctl get)
MAX=$(brightnessctl max)
PERCENT=$((BRIGHTNESS * 100 / MAX))

# Pick icon
if [ "$PERCENT" -ge 75 ]; then
    ICON="󰃠"
elif [ "$PERCENT" -ge 50 ]; then
    ICON="󰃝"
elif [ "$PERCENT" -ge 25 ]; then
    ICON="󰃞"
else
    ICON="󰃟"
fi

# Send to minosd
SOCKET="${XDG_RUNTIME_DIR:-/tmp}/minosd.sock"

if [ ! -S "$SOCKET" ]; then
    echo "minosd not running" >&2
    exit 1
fi

PAYLOAD=$(printf '%s\t%s\t%s\n' "$PERCENT" "$ICON" "Brightness")

if command -v socat >/dev/null 2>&1; then
    printf '%s' "$PAYLOAD" | socat - "UNIX-CONNECT:$SOCKET"
elif command -v nc >/dev/null 2>&1; then
    printf '%s' "$PAYLOAD" | nc -U "$SOCKET"
else
    python3 -c "
import socket
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect('$SOCKET')
s.sendall('''$PAYLOAD'''.encode())
s.close()
"
fi
