#!/usr/bin/env bash

current=$(powerprofilesctl get)

case "$current" in
    "power-saver")
        next="balanced"
        label="Balanceado"
        ;;
    "balanced")
        # Verifica se o hardware/kernel expõe o modo performance
        if powerprofilesctl list | grep -q "performance:"; then
            next="performance"
            label="Desempenho"
        else
            next="power-saver"
            label="Economia de Energia"
        fi
        ;;
    *)
        next="power-saver"
        label="Economia de Energia"
        ;;
esac

powerprofilesctl set "$next"

# A flag -r substitui a notificação anterior se você clicar várias vezes seguidas
notify-send -u low -t 2000 -r 9991 "Energia" "$label"
