#!/bin/bash

ROFI_CMD="rofi -theme ~/.config/rofi/bluetooth.rasi -dmenu -no-custom"

bt_is_powered() {
    bluetoothctl show | grep -q "Powered: yes"
}

parse_mac() { echo "$1" | awk '{print $2}'; }
parse_name() { echo "$1" | cut -d' ' -f3-; }

device_is_connected() {
    bluetoothctl info "$1" 2>/dev/null | grep -q "Connected: yes"
}

# ---- Build main menu ----

declare -a opts_display opts_action opts_mac

if bt_is_powered; then
    opts_display+=("󰂲  Bluetooth: ON  ·  Turn Off")
    opts_action+=("power_off")
else
    opts_display+=("󰂯  Bluetooth: OFF  ·  Turn On")
    opts_action+=("power_on")
fi
opts_mac+=("")

opts_display+=("󰍉  Scan for new devices")
opts_action+=("scan")
opts_mac+=("")

while IFS= read -r line; do
    [ -z "$line" ] && continue
    mac=$(parse_mac "$line")
    name=$(parse_name "$line")
    opts_display+=("󰂱  $name  [disconnect]")
    opts_action+=("disconnect")
    opts_mac+=("$mac")
done < <(bluetoothctl devices Connected 2>/dev/null | grep "^Device")

while IFS= read -r line; do
    [ -z "$line" ] && continue
    mac=$(parse_mac "$line")
    name=$(parse_name "$line")
    if ! device_is_connected "$mac"; then
        opts_display+=("󰂯  $name  [connect]")
        opts_action+=("connect")
        opts_mac+=("$mac")
    fi
done < <(bluetoothctl paired-devices 2>/dev/null | grep "^Device")

chosen_idx=$(printf '%s\n' "${opts_display[@]}" | $ROFI_CMD -p "Bluetooth" -format i)
[ -z "$chosen_idx" ] && exit 0

action="${opts_action[$chosen_idx]}"
mac="${opts_mac[$chosen_idx]}"

# ---- Handle selection ----

case "$action" in
    power_on)
        bluetoothctl power on
        ;;
    power_off)
        bluetoothctl power off
        ;;
    connect)
        bluetoothctl connect "$mac"
        ;;
    disconnect)
        bluetoothctl disconnect "$mac"
        ;;
    scan)
        notify-send "Bluetooth" "Scanning for 8 seconds..." -t 3000

        # Scan for 8 seconds then stop
        timeout 8 bluetoothctl scan on > /dev/null 2>&1 || true
        bluetoothctl scan off > /dev/null 2>&1

        # Build set of already-paired MACs to exclude
        paired_macs=$(bluetoothctl paired-devices 2>/dev/null | grep "^Device" | awk '{print $2}')

        declare -a disc_display disc_mac

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            d_mac=$(parse_mac "$line")
            d_name=$(parse_name "$line")
            echo "$paired_macs" | grep -qx "$d_mac" && continue
            disc_display+=("󰋒  $d_name")
            disc_mac+=("$d_mac")
        done < <(bluetoothctl devices 2>/dev/null | grep "^Device")

        if [ "${#disc_display[@]}" -eq 0 ]; then
            notify-send "Bluetooth" "No new devices found"
            exit 0
        fi

        chosen_dev=$(printf '%s\n' "${disc_display[@]}" | $ROFI_CMD -p "Pair device" -format i)
        [ -z "$chosen_dev" ] && exit 0

        pair_mac="${disc_mac[$chosen_dev]}"
        pair_name="${disc_display[$chosen_dev]#*  }"

        notify-send "Bluetooth" "Pairing with $pair_name..."
        if bluetoothctl pair "$pair_mac" && bluetoothctl connect "$pair_mac"; then
            notify-send "Bluetooth" "Connected to $pair_name"
        else
            notify-send "Bluetooth" "Failed to pair with $pair_name"
        fi
        ;;
esac
