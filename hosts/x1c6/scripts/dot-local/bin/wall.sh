#!/usr/bin/env bash

dir="$HOME/Pictures/walls"

wall=$(cd "$dir" && fd -e jpg -e jpeg -e png . | \
  fzf --layout=reverse \
      --color=base16,fg+:200,bg+:black,border:bright-black,pointer:200 \
      --preview "chafa -s \${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} '$dir'/{}" \
      --preview-window=right:70%:border:sharp)

[ -z "$wall" ] && exit 0

path="$dir/$wall"

old=$(pgrep -x swaybg)
setsid -f swaybg -m fill -i "$path" >/dev/null 2>&1
sleep 0.2
[ -n "$old" ] && kill $old

echo "$path" > "$HOME/.config/wallpaper"
