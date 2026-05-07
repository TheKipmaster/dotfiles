#!/bin/bash

BLUE="%{F#44D1EF}"
GRAY="%{F#757575}"
RESET="%{F-}"

BT_ON="󰂯"
BT_OFF="󰂲"

if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo "${GRAY}${BT_OFF}${RESET}"
    exit 0
fi

connected=$(bluetoothctl devices Connected 2>/dev/null | grep -c "^Device" || true)

if [ "$connected" -gt 0 ]; then
    echo "${BLUE}${BT_ON} (${connected})${RESET}"
else
    echo "${BLUE}${BT_ON}${RESET}"
fi
