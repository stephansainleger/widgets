#!/bin/bash

battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
battery_status=$(upower -i $battery | awk '/state/ {print $2}')
battery_level=$(battery)

if [[ $battery_status =~ (discharging) ]]; then
    remaining_time=$(upower -i "$battery" | grep -E '(remain|time to empty)' | awk '{printf "%s %s left", $(NF-1), $(NF)}')
elif [[ $battery_status =~ (charged) ]]; then
    remaining_time="Charged"
else
    remaining_time=$(upower -i "$battery" | grep -E 'time to full' | awk '{printf "%s %s to full", $(NF-1), $(NF)}')
fi

notify-send "Batterie : $battery_level ($battery_status)" "$remaining_time"
