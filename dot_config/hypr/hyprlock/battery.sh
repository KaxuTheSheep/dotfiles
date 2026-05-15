#!/bin/bash

CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
STATUS=$(cat /sys/class/power_supply/BAT1/status)

if [ "$STATUS" = "Charging" ]; then
    ICON="󰂄"
elif [ "$CAPACITY" -ge 90 ]; then
    ICON="󰁹"
elif [ "$CAPACITY" -ge 70 ]; then
    ICON="󰂀"
elif [ "$CAPACITY" -ge 50 ]; then
    ICON="󰁾"
elif [ "$CAPACITY" -ge 30 ]; then
    ICON="󰁼"
elif [ "$CAPACITY" -ge 10 ]; then
    ICON="󰁺"
else
    ICON="󰂃"
fi

echo "$ICON $CAPACITY%"
