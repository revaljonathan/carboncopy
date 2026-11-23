#!/usr/bin/env bash

selected=$(tmux ls -F '#{session_name} (#{session_windows} windows)' 2>/dev/null \
    | fuzzel --dmenu)

[ -z "$selected" ] && exit 0

session=${selected% (*}   # strip the trailing " (N windows)"
footclient tmux attach -t "$session"
