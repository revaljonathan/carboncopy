#!/bin/env bash

# example -> ./single-stow.sh btop
# using this flags prevent weirdness

stow --dotfiles --no-folding --target="$HOME" $1
