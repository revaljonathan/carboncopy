#!/usr/bin/env bash
# Volume control script using minosd OSD
# Usage: vol.sh up|down|mute

ACTION="$1"

case "$ACTION" in
    up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0 ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-       ;;
    mute) wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle    ;;
    *)    echo "Usage: $0 {up|down|mute}" >&2; exit 1     ;;
esac

# Read current state
RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOLUME=$(echo "$RAW" | awk '{print int($2 * 100)}')
MUTED=$(echo "$RAW" | grep -c MUTED)

# Pick icon
if [ "$MUTED" -eq 1 ]; then
    ICON="󰝟"
    TEXT="Muted"
elif [ "$VOLUME" -ge 66 ]; then
    ICON="󰕾"
    TEXT="Volume"
elif [ "$VOLUME" -ge 33 ]; then
    ICON="󰖀"
    TEXT="Volume"
else
    ICON="󰕿"
    TEXT="Volume"
fi

# Send to minosd
SOCKET="${XDG_RUNTIME_DIR:-/tmp}/minosd.sock"

if [ ! -S "$SOCKET" ]; then
    echo "minosd not running" >&2
    exit 1
fi

PAYLOAD=$(printf '%s\t%s\t%s\n' "$VOLUME" "$ICON" "$TEXT")

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
