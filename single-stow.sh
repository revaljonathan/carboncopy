#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./single-stow.sh <package>              # shared package (e.g. nvim, zsh)
#   ./single-stow.sh <package> [hostname]   # host-specific package (e.g. niri x1c6)

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
PKG="${1:?usage: single-stow.sh <package> [hostname]}"
HOST="${2:-}"

if [[ -n "$HOST" ]]; then
  HOST_DIR="$DOTFILES/hosts/$HOST"
  if [[ ! -d "$HOST_DIR/$PKG" ]]; then
    echo "error: hosts/$HOST/$PKG not found"
    echo "available hosts: $(ls "$DOTFILES/hosts/" | tr '\n' ' ')"
    exit 1
  fi
  echo "==> stowing host package: hosts/$HOST/$PKG"
  cd "$HOST_DIR"
else
  if [[ ! -d "$DOTFILES/$PKG" ]]; then
    echo "error: shared package '$PKG' not found"
    exit 1
  fi
  echo "==> stowing shared package: $PKG"
  cd "$DOTFILES"
fi

stow --no-folding --dotfiles --target="$HOME" "$PKG"
