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

# If ~/.local is a symlink (from earlier folded stow runs), remove it
if [[ -L "$HOME/.local" ]]; then
  rm "$HOME/.local"
fi

# If ~/.local/bin was a folded symlink, back it up; otherwise preserve user binaries in ~/.local/bin
if [[ -L "$HOME/.local/bin" ]]; then
  mv "$HOME/.local/bin" "$BAK/"
fi
mkdir -p "$HOME/.local/bin"

cd "$HOME/carboncopy"
for pkg in "${PACKAGES[@]}"; do
  stow --no-folding --dotfiles --target="$HOME" "$pkg"
done
