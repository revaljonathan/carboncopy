#!/usr/bin/env bash

PREDEFINED=(
    "github"
    "Wikipedia"
    "Youtube"
    "Reddit"
    "Arch Wiki"
    "Deepseek"
    "GPT"
    "Claude"
    "Gemini"
    "Dodgers"
)

CHOICE=$(printf '%s\n' "${PREDEFINED[@]}" | fuzzel --dmenu)
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
        librewolf "$URL"
    elif [[ "$URL" =~ ^(localhost|[^[:space:]/]+\.[^[:space:]/]+)(:[0-9]+)?(/.*)?$ ]]; then
        librewolf "https://$URL"
    else
        librewolf "https://search.brave.com/search?q=$(urlencode "$URL")"
    fi
    ;;
*github*) librewolf "https://github.com" ;;
"Wikipedia"*) librewolf "https://en.wikipedia.org/wiki/Main_Page" ;;
"Youtube"*) librewolf "https://www.youtube.com/" ;;
"Reddit"*) librewolf "https://www.reddit.com/" ;;
"Arch Wiki"*) librewolf "https://wiki.archlinux.org/title/Main_page" ;;
"Deepseek"*) librewolf "https://chat.deepseek.com/" ;;
"GPT"*) librewolf "https://chatgpt.com/" ;;
"Claude"*) librewolf "https://claude.ai/new" ;;
"Gemini"*) librewolf "https://gemini.google.com/app" ;;
"Dodgers"*) librewolf "https://search.brave.com/search?q=!g dodgers" ;;
*) librewolf "https://search.brave.com/search?q=$(urlencode "$CHOICE")" ;;
esac
