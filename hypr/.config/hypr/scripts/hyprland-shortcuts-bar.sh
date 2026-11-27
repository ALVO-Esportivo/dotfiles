#!/usr/bin/env bash

# Quantidade de atalhos ativos do Hyprland -> Waybar.
# Entrada: nenhuma.
# Saída: "Atalhos: N"

cd ~/.config/hypr 2>/dev/null || exit 0

count=$(hyprctl binds -j 2>/dev/null | jq '[.[]] | length' 2>/dev/null)
if [[ -z "${count// }" ]]; then
    count=0
fi
echo "Atalhos: ${count}"
