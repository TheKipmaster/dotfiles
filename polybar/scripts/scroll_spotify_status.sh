#!/bin/bash

# see man zscroll for documentation of the following parameters
# F0F71 - music-note-eighth (l7)
zscroll -l 30 \
        --delay 0.1 \
        --scroll-padding " 󰎈 " \
        --match-command "`dirname $0`/get_spotify_status.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "`dirname $0`/get_spotify_status.sh" &

wait
