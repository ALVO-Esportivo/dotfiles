#!/usr/bin/env bash

if command -v jq >/dev/null 2>&1; then
    next=$(hyprctl workspaces -j | jq '[.[].id | select(. > 0)] | (max // 0) + 1')
else
    next=$(hyprctl workspaces | grep -oE 'workspace ID [0-9]+' | awk '{if ($3 > max) max = $3} END {print max + 1}')
fi

if [ "$1" = "silent" ]; then
    hyprctl dispatch "'movetoworkspacesilent', $next"
else
    hyprctl dispatch "'workspace', $next"
fi
