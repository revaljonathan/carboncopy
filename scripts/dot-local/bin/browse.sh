#!/usr/bin/env bash

LIST="${XDG_CONFIG_HOME:-$HOME/Documents/}sites.txt"
[ -f "$LIST" ] || { echo "Missing $LIST" >&2; exit 1; }

urlencode() {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

# Show only the names (left of the |), skipping comments and blank lines
CHOICE=$(awk -F'|' 'NF && $1 !~ /^[[:space:]]*#/ {print $1}' "$LIST" | fuzzel --dmenu)
[ -z "$CHOICE" ] && exit 0

# ">" prefix = direct URL / search, same as before
if [[ "$CHOICE" == ">"* ]]; then
    URL="${CHOICE#>}"
    URL="${URL#"${URL%%[![:space:]]*}"}"
    URL="${URL%"${URL##*[![:space:]]}"}"
    [ -z "$URL" ] && exit 0
    if [[ "$URL" =~ ^[a-zA-Z][a-zA-Z0-9+.-]*:// ]]; then
        librewolf "$URL"
    elif [[ "$URL" =~ ^(localhost|[^[:space:]/]+\.[^[:space:]/]+)(:[0-9]+)?(/.*)?$ ]]; then
        librewolf "https://$URL"
    else
        librewolf "https://search.brave.com/search?q=$(urlencode "$URL")"
    fi
    exit 0
fi

# Look up the chosen name in the file
URL=$(CHOICE="$CHOICE" awk -F'|' '$1 == ENVIRON["CHOICE"] {print $2; exit}' "$LIST")

if [ -n "$URL" ]; then
    librewolf "$URL"
else
    # Not in the list -> search it
    librewolf "https://search.brave.com/search?q=$(urlencode "$CHOICE")"
fi
