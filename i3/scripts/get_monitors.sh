#!/bin/bash
# ~/.config/i3/scripts/get_monitors.sh
#
# Detects connected monitor IDs by connection type so xrandr output names
# (e.g. DP-1-1, DP-1-4, HDMI-1-3) can change without breaking anything.
#
# Usage:
#   Run directly to print detected monitors:
#       bash get_monitors.sh
#
#   Source from another script to get variables:
#       source get_monitors.sh
#       echo "Left: $LEFT_MON  Internal: $INT_MON  Right: $RIGHT_MON"

# ── Collect all currently connected outputs ──────────────────────────────────
CONNECTED=$(xrandr --query | awk '/ connected/{print $1}')

# ── Identify each role ───────────────────────────────────────────────────────

# Internal laptop panel  →  always starts with eDP
INT_MON=$(echo "$CONNECTED" | grep -E '^eDP' | head -1)

# External left          →  DisplayPort (DP / DP-n / DP-n-m / DisplayPort-n)
LEFT_MON=$(echo "$CONNECTED" | grep -Ev '^eDP' | grep -E '^(DP|DisplayPort)' | head -1)

# External right         →  HDMI (HDMI-n / HDMI-n-m)
RIGHT_MON=$(echo "$CONNECTED" | grep -Ev '^eDP' | grep -E '^HDMI' | head -1)

# ── Fallback: if only one external exists and didn't match either pattern ─────
UNMATCHED=$(echo "$CONNECTED" | grep -Ev '^eDP' | grep -Ev '^(DP|DisplayPort|HDMI)')
if [ -n "$UNMATCHED" ]; then
    [ -z "$LEFT_MON" ]  && LEFT_MON=$(echo "$UNMATCHED"  | head -1)
    [ -z "$RIGHT_MON" ] && RIGHT_MON=$(echo "$UNMATCHED" | tail -1)
fi

# ── When sourced, just set the variables and return ───────────────────────────
# (The [ "$0" != ... ] test is true when the script is *run*, not sourced.)
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "INT_MON   = ${INT_MON:-(not found)}"
    echo "LEFT_MON  = ${LEFT_MON:-(not connected)}"
    echo "RIGHT_MON = ${RIGHT_MON:-(not connected)}"
fi
