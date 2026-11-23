#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOST="${1:-$(hostname)}"
HOST_DIR="$DOTFILES/hosts/$HOST"

# Validate host
if [[ ! -d "$HOST_DIR" ]]; then
  echo "error: no host config found for '$HOST'"
  echo "available hosts: $(ls "$DOTFILES/hosts/" | tr '\n' ' ')"
  exit 1
fi

echo "==> stowing for host: $HOST"

BAK="$HOME/config-bak-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BAK"

# --- shared packages ---
SHARED_PACKAGES=(
  cava fastfetch lazygit nvim zsh
)

SHARED_CONFIGS=(
  cava fastfetch lazygit nvim
)

for cfg in "${SHARED_CONFIGS[@]}"; do
  if [[ -e "$HOME/.config/$cfg" ]]; then
    mv "$HOME/.config/$cfg" "$BAK/"
  fi
done

echo "==> stowing shared packages..."
cd "$DOTFILES"
for pkg in "${SHARED_PACKAGES[@]}"; do
  [[ -d "$pkg" ]] || { echo "  skip $pkg (not found)"; continue; }
  echo "  stow $pkg"
  stow --no-folding --dotfiles --target="$HOME" "$pkg"
done

# --- host-specific packages ---

# If ~/.local is a symlink (from earlier folded stow runs), remove it
if [[ -L "$HOME/.local" ]]; then
  rm "$HOME/.local"
fi

# If ~/.local/bin was a folded symlink, back it up; otherwise preserve user binaries in ~/.local/bin
if [[ -L "$HOME/.local/bin" ]]; then
  mv "$HOME/.local/bin" "$BAK/"
fi
mkdir -p "$HOME/.local/bin"

echo "==> stowing host packages from hosts/$HOST/..."
cd "$HOST_DIR"
for pkg_dir in */; do
  pkg="${pkg_dir%/}"
  echo "  stow $pkg"
  stow --no-folding --dotfiles --target="$HOME" "$pkg"
done

echo "==> done! backup at $BAK (delete if empty)"
