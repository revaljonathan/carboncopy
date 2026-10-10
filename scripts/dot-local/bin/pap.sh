#!/usr/bin/env bash
# Recolor Papirus-Dark folder icons with your own hex codes.
#
# Usage:
#   ./papirus-recolor.sh -p 89b4fa -s f5c2e7 -d 1e1e2e [-n My-Papirus] [-a]
#
#   -p  primary color    (folder body,   replaces #5294e2)
#   -s  secondary color  (folder accents, replaces #c9a554 / #e4e4e4 / #ffffff)
#   -d  dark color       (folder shading, replaces #4877b1 / #1d344f)
#   -n  theme name       (default: Papirus-Custom)
#   -a  apply the theme with gsettings when done
#   -r  remove the theme named by -n and exit

set -euo pipefail

NAME="Papirus-Custom"
APPLY=0
REMOVE=0
PRIMARY="" SECONDARY="" DARK=""

while getopts "p:s:d:n:ar" opt; do
    case $opt in
        p) PRIMARY="${OPTARG#\#}" ;;
        s) SECONDARY="${OPTARG#\#}" ;;
        d) DARK="${OPTARG#\#}" ;;
        n) NAME="$OPTARG" ;;
        a) APPLY=1 ;;
        r) REMOVE=1 ;;
        *) echo "Usage: $0 -p HEX -s HEX -d HEX [-n NAME] [-a] [-r]"; exit 1 ;;
    esac
done

ICONS_DIR="$HOME/.local/share/icons"
THEME_DIR="$ICONS_DIR/$NAME"
CACHE="$HOME/.cache/papirus-recolor/papirus"

if [ "$REMOVE" -eq 1 ]; then
    rm -rf "$THEME_DIR"
    echo "Removed $THEME_DIR"
    exit 0
fi

hex_re='^[0-9a-fA-F]{6}$'
for v in "$PRIMARY" "$SECONDARY" "$DARK"; do
    [[ "$v" =~ $hex_re ]] || { echo "Error: need -p, -s, -d as 6-digit hex (e.g. 89b4fa)"; exit 1; }
done

for cmd in git sed find; do
    command -v "$cmd" >/dev/null || { echo "Missing dependency: $cmd"; exit 1; }
done

# Fetch (or update) Papirus once, reuse on later runs
mkdir -p "$(dirname "$CACHE")" "$ICONS_DIR"
if [ ! -d "$CACHE/.git" ]; then
    echo "Cloning Papirus..."
    git clone --depth 1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git "$CACHE"
else
    git -C "$CACHE" pull -q --rebase || true
fi

echo "Building $NAME..."
rm -rf "$THEME_DIR"
cp -rL "$CACHE/Papirus-Dark" "$THEME_DIR"
sed -i "s/^Name=.*/Name=$NAME/" "$THEME_DIR/index.theme"

echo "Recoloring..."
find "$THEME_DIR" -name "*.svg" -path "*/places/*" -print0 | xargs -0 -P "$(nproc)" sed -i \
    -e "s/fill:#5294e2/fill:#${PRIMARY}/gI" \
    -e "s/fill:#4877b1/fill:#${DARK}/gI" \
    -e "s/fill:#1d344f/fill:#${DARK}/gI" \
    -e "s/fill:#c9a554/fill:#${SECONDARY}/gI" \
    -e "s/fill:#e4e4e4/fill:#${SECONDARY}/gI" \
    -e "s/fill:#ffffff/fill:#${SECONDARY}/gI"

if command -v gtk-update-icon-cache >/dev/null; then
    gtk-update-icon-cache -f -t "$THEME_DIR" 2>/dev/null || true
fi

if [ "$APPLY" -eq 1 ] && command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface icon-theme "$NAME"
    echo "Applied $NAME via gsettings."
fi

echo "Done: $THEME_DIR"
