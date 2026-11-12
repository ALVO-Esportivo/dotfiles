#!/usr/bin/env bash

# Opções do menu
opcoes=" Bloquear\n Encerrar Sessão\n Suspender\n Reiniciar\n Desligar"

# Exibe o menu compacto via fuzzel
escolha=$(echo -e "$opcoes" | fuzzel --dmenu -p "Sessão: " --lines 5 --width 18)

case "$escolha" in
    " Bloquear")
        hyprlock
        ;;
    " Encerrar Sessão")
        hyprctl dispatch exit
        ;;
    " Suspender")
        systemctl suspend
        ;;
    " Reiniciar")
        systemctl reboot
        ;;
    " Desligar")
        systemctl poweroff
        ;;
esac
