#!/usr/bin/env bash

selected=$(tmux ls -F '#{session_name} (#{session_windows} windows)' 2>/dev/null \
    | fuzzel --dmenu -p "tmux: ")

[ -z "$selected" ] && exit 0
session=$(echo "$selected" | awk '{print $1}')
foot tmux attach -t "$session"

[ -z "$selected" ] && exit 0

session=$(echo "$selected" | cut -d: -f1)

foot tmux attach -t "$session"
