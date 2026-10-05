#!/usr/bin/env bash
set -euo pipefail

BAK="$HOME/config-bak-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BAK"

PACKAGES=(
  btop cava fastfetch foot fuzzel gtk3 mako
  niri nvim scripts swaylock tmux waybar yazi zathura zsh
)

CONFIGS=(
  btop cava fastfetch foot fuzzel gtk-3.0 mako
  niri nvim swaylock tmux waybar yazi zathura
)

for cfg in "${CONFIGS[@]}"; do
  if [[ -e "$HOME/.config/$cfg" ]]; then
    mv "$HOME/.config/$cfg" "$BAK/"
  fi
done

[[ -e "$HOME/.local/bin" ]] && mv "$HOME/.local/bin" "$BAK/"

cd "$HOME/carboncopy"
for pkg in "${PACKAGES[@]}"; do
  stow --dotfiles --target="$HOME" "$pkg"
done
