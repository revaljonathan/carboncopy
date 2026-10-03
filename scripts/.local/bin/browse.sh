#!/usr/bin/env bash

PREDEFINED=(
    "github"
    "Wikipedia"
    "Youtube"
    "Arch Wiki"
    "Deepseek"
    "GPT"
    "Claude"
    "Gemini"
    "Dodgers"
    "Catppuccin"
)

CHOICE=$(printf '%s\n' "${PREDEFINED[@]}" | rofi -i -dmenu)
[ -z "$CHOICE" ] && exit 0

urlencode() {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

case "$CHOICE" in
">"*)
    URL="${CHOICE#>}"
    URL="${URL#"${URL%%[![:space:]]*}"}"   
    URL="${URL%"${URL##*[![:space:]]}"}"   
    [ -z "$URL" ] && exit 0
    if [[ "$URL" =~ ^[a-zA-Z][a-zA-Z0-9+.-]*:// ]]; then
        helium-browser "$URL"
    elif [[ "$URL" =~ ^(localhost|[^[:space:]/]+\.[^[:space:]/]+)(:[0-9]+)?(/.*)?$ ]]; then
        helium-browser "https://$URL"
    else
        helium-browser "https://search.brave.com/search?q=$(urlencode "$URL")"
    fi
    ;;
*github*) helium-browser "https://github.com" ;;
"Wikipedia"*) helium-browser "https://en.wikipedia.org/wiki/Main_Page" ;;
"Youtube"*) helium-browser "https://www.youtube.com/" ;;
"Arch Wiki"*) helium-browser "https://wiki.archlinux.org/title/Main_page" ;;
"Deepseek"*) helium-browser "https://chat.deepseek.com/" ;;
"GPT"*) helium-browser "https://chatgpt.com/" ;;
"Claude"*) helium-browser "https://claude.ai/new" ;;
"Gemini"*) helium-browser "https://gemini.google.com/app" ;;
"Dodgers"*) helium-browser "https://search.brave.com/search?q=!g dodgers" ;;
"Catppuccin"*) helium-browser "https://catppuccin.com/palette/" ;;
*) helium-browser "https://search.brave.com/search?q=$(urlencode "$CHOICE")" ;;
esac
