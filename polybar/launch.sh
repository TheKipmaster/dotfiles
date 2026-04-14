#!/usr/bin/env bash

# Terminate already running bar instances
killall polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Get monitors dynamically
mapfile -t MONITORS < <(polybar -M | cut -d ':' -f1)
CONFIG_DIR=$(dirname $0)/config.ini
# LOGS_DIR=$(dirname $0)/logs.txt

# Laptop screen (usually eDP)
MONITOR="${MONITORS[0]}" polybar main -r -c $CONFIG_DIR &

# External monitors
[ -n "${MONITORS[1]}" ] && MONITOR="${MONITORS[1]}" polybar left -r -c $CONFIG_DIR &
[ -n "${MONITORS[2]}" ] && MONITOR="${MONITORS[2]}" polybar right -r -c $CONFIG_DIR &