#!/usr/bin/env bash

# Lista atalhos do Hyprland e mostra no Fuzzel.
# Uso: ~/.config/hypr/scripts/hyprland-shortcuts.sh

cd ~/.config/hypr 2>/dev/null || {
    notify-send -u low "hypr-shortcuts" "Não encontrei ~/config/hypr"
    exit 0
}

hyprctl binds -j 2>/dev/null | jq -r '
    .[]
    | select(.key != "" or .submap != "")
    | .key as $key
    | .submap as $submap
    | .action as $action
    | if $submap != "" then
        "SUPER + \($key) -> \($submap)"
      else
        "SUPER + \($key) -> \($action)"
      end
' 2>/dev/null | sort -u > /tmp/hypr-shortcuts-$$-tmp

if [ -s /tmp/hypr-shortcuts-$$-tmp ]; then
    fuzzel --dmenu -p "Atalhos do Hyprland:" < /tmp/hypr-shortcuts-$$-tmp
else
    notify-send -u low "hypr-shortcuts" "Nenhum atalho ativo encontrado."
fi

rm -f /tmp/hypr-shortcuts-$$-tmp
