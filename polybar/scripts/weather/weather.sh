#!/bin/sh
ENV_FILE="$HOME/.config/polybar/scripts/weather/.env"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"
python3 "$HOME/.config/polybar/scripts/weather/main.py" -u metric -v
