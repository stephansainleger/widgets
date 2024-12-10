#!/bin/bash

# Path to the battery files
BATTERY_PATH="/sys/class/power_supply/BAT0/capacity"
STATUS_PATH="/sys/class/power_supply/BAT0/status"
POWER_NOW_PATH="/sys/class/power_supply/BAT0/power_now"
ENERGY_NOW_PATH="/sys/class/power_supply/BAT0/energy_now"
ENERGY_FULL_PATH="/sys/class/power_supply/BAT0/energy_full"

# Check if files exist
if [ -f "$BATTERY_PATH" ] && [ -f "$STATUS_PATH" ]; then
    BATTERY_LEVEL=$(cat "$BATTERY_PATH")
    BATTERY_STATUS=$(cat "$STATUS_PATH")

    # Check if files needed for time calculation exist
    if [ -f "$POWER_NOW_PATH" ] && [ -f "$ENERGY_NOW_PATH" ]; then
        POWER_NOW=$(cat "$POWER_NOW_PATH")
        ENERGY_NOW=$(cat "$ENERGY_NOW_PATH")

        if [ "$BATTERY_STATUS" == "Discharging" ] && [ "$POWER_NOW" -gt 0 ]; then
            TIME_REMAINING=$(echo "scale=2; $ENERGY_NOW / $POWER_NOW" | bc)
            HOURS=$(echo "$TIME_REMAINING" | awk -F. '{print $1}')
            MINUTES=$(echo "scale=0; (.$(echo "$TIME_REMAINING" | awk -F. '{print $2}') * 60)/1" | bc)
            TIME_REMAINING="${HOURS}h ${MINUTES}m"
        else
            TIME_REMAINING="Calcul non applicable (Batterie en charge ou non mesurable)"
        fi
    else
        TIME_REMAINING="Non disponible (informations manquantes)"
    fi

    notify-send "Batterie : $BATTERY_LEVEL% ($BATTERY_STATUS)" "Temps estimé restant : $TIME_REMAINING"
else
    notify-send "Erreur" "Impossible de détecter la batterie."
fi
