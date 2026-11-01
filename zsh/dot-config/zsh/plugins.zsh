plugins=(
    zsh-autosuggestions
    sudo
    fzf-tab
    zsh-syntax-highlighting
)

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --height=50% --min-height=10+

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
