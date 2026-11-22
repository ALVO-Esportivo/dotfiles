#!/usr/bin/env bash

# Obtém o maior ID numérico positivo aberto
max=$(hyprctl workspaces -j 2>/dev/null | jq -r '[.[].id | select(. > 0)] | max // 0' 2>/dev/null)

# Fallback caso jq não esteja instalado
if ! [[ "$max" =~ ^[0-9]+$ ]]; then
    max=$(hyprctl workspaces | awk '/^workspace ID [0-9]+/ {id=$3; if (id+0 > m) m=id+0} END {print m+0}')
fi

next=$((max + 1))

if [ "$1" = "silent" ]; then
    hyprctl dispatch "'movetoworkspacesilent', $next"
else
    hyprctl dispatch "'workspace', $next"
fi
