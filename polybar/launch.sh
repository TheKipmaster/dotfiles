#!/usr/bin/env bash

# Terminate already running bar instances
killall polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

CONFIG_DIR=$(dirname $0)/config.ini
# LOGS_DIR=$(dirname $0)/logs.txt
polybar main -r -c $CONFIG_DIR &
polybar left -r -c $CONFIG_DIR &
polybar right -r -c $CONFIG_DIR &