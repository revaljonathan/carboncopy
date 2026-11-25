ZSH_THEME="powerlevel10k/powerlevel10k"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# just in case, lol, p10k is still better
# eval "$(starship init zsh)"
# eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/steal.toml)"

# handrolled
# ZSH_THEME=""
# setopt PROMPT_SUBST
#
# zmodload zsh/datetime
# autoload -Uz add-zsh-hook add-zle-hook-widget
#
# _theme_preexec() {
#   typeset -g _theme_cmd_start=$EPOCHSECONDS
# }
#
# _theme_precmd() {
#   local last_status=$?
#
#   local duration_plain="" duration_colored=""
#   if (( $+_theme_cmd_start )); then
#     local elapsed=$(( EPOCHSECONDS - _theme_cmd_start ))
#     unset _theme_cmd_start
#     if (( elapsed >= 5 )); then
#       local unit="second"
#       (( elapsed != 5 )) && unit="seconds"
#       duration_plain="took ${elapsed} ${unit} "
#       duration_colored="%F{8}${duration_plain}%f"
#     fi
#   fi
#
#   local left_plain="%~"
#   local left_colored="%F{blue}%~%f"
#   if [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]]; then
#     left_plain="ssh: %m | %~"
#     left_colored="%F{magenta}ssh: %m%f %F{yellow}|%f %F{blue}%~%f"
#   fi
#
#   local right_plain="${duration_plain}at %D{%H:%M}"
#   local right_colored="${duration_colored}%F{7}at%F{yellow} %D{%H:%M}%f"
#
#   local left_len=${#${(%)left_plain}}
#   local right_len=${#${(%)right_plain}}
#   local pad=$(( COLUMNS - left_len - right_len ))
#   (( pad < 1 )) && pad=1
#
#   typeset -g _theme_prompt_char
#   if (( last_status != 0 )); then
#     _theme_prompt_char="%F{red}>%f"
#   else
#     _theme_prompt_char="%F{magenta}>%f"
#   fi
#
#   PROMPT="${left_colored}${(l:$pad:: :)}${right_colored}"$'\n'"${_theme_prompt_char} "
#
#   TRAPINT() {
#     PROMPT="${_theme_prompt_char} "
#     zle && zle .reset-prompt
#     return $(( 128 + $1 ))
#   }
# }
#
# _theme_zle_line_finish() {
#   PROMPT="${_theme_prompt_char} "
#   zle .reset-prompt
# }
#
# add-zsh-hook preexec _theme_preexec
# add-zsh-hook precmd _theme_precmd
# add-zle-hook-widget zle-line-finish _theme_zle_line_finish
