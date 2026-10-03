wall=$(cd ~/Pictures/walls && fd -e jpg -e jpeg -e png . | \
  fzf --layout=reverse \
      --color=base16,fg+:red,bg+:-1,border:bright-black \
      --preview 'chafa -s $FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES ~/Pictures/walls/{}' \
      --preview-window=right:70%:border:sharp)

[ -z "$wall" ] && exit 0

awww img ~/Pictures/walls/"$wall" --transition-type none
echo ~/Pictures/walls/"$wall" > ~/.config/wallpaper
