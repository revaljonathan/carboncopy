# export GTK_THEME=adw-gtk3-dark
export LS_COLORS=""
export COLORTERM=truecolor
export BAT_THEME="base16"
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=kitty
export MANPAGER="nvim +Man!"
export FZF_DEFAULT_OPTS="
  --layout=reverse \
  --border=sharp \
  --ansi \
  --no-separator \
  --color=base16,fg+:blue,bg+:black,border:bright-black,pointer:blue
"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/.go
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/opt/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/home/reval/.spicetify
export PATH=~/.npm-global/bin:$PATH
export PATH="/home/reval/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
