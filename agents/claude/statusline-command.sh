#!/bin/sh
# Claude Code statusLine command
#
# Line 1: user@host:cwd [model | ctx | 7d]   (derived from the PS1 in ~/.bashrc)
# Line 2: a pacing gauge — two parallel horizontal lines packed into ONE row of
#         text. Every cell is U+2580 UPPER HALF BLOCK: the glyph paints the top
#         half in the foreground colour and leaves the bottom half showing the
#         background colour, so a single row of cells renders two independent
#         bars stacked on top of each other.
#
#           top line (amber/red) = share of the 5-hour quota consumed
#           bottom line (blue)   = share of the 5-hour window elapsed
#
#         Read them against each other: while blue leads amber you are on pace
#         to coast to the reset; when amber pulls ahead you are burning quota
#         faster than the clock is refilling it.

set -u

# printf's %f parses according to LC_NUMERIC, and this box runs a pt_BR locale
# where the decimal separator is a comma — so "41.2" would parse as 41. Pin the
# C locale rather than depend on the caller's environment. The block glyph is
# emitted as raw octal bytes below, so this costs us nothing.
export LC_ALL=C

BAR_WIDTH=24
WINDOW_SECONDS=18000 # the "5-hour" session window

# 1 = gauge gets its own row below the prompt; 0 = appended to the prompt row.
# Flip to 0 if a future Claude Code build ever renders only the first line.
GAUGE_OWN_LINE=${GAUGE_OWN_LINE:-0}

# xterm-256 palette
C_USED=214     # amber - quota consumed
C_USED_HOT=196 # red   - quota consumed, once past $HOT_THRESHOLD
C_TIME=39      # blue  - window elapsed
C_TRACK=236    # grey  - the unconsumed remainder of either bar
HOT_THRESHOLD=80

input=$(cat)

# One jq process, one field per line, read back in order. Emitting @tsv and
# splitting on tabs would be tempting but wrong: tab is an IFS *whitespace*
# character, so `read` collapses runs of them and empty fields silently shift
# every later value one slot to the left.
cwd='' model='' ctx_pct='' five_pct='' five_resets='' seven_pct=''
{
	IFS= read -r cwd
	IFS= read -r model
	IFS= read -r ctx_pct
	IFS= read -r five_pct
	IFS= read -r five_resets
	IFS= read -r seven_pct
} <<EOF
$(printf '%s' "$input" | jq -r '
    [ .workspace.current_dir // .cwd // "",
      .model.display_name // "",
      .context_window.used_percentage // "",
      .rate_limits.five_hour.used_percentage // "",
      .rate_limits.five_hour.resets_at // "",
      .rate_limits.seven_day.used_percentage // ""
    ] | .[] | tostring')
EOF

# --- helpers ----------------------------------------------------------------

# Round a percentage (possibly fractional) to a whole number of bar cells.
# Anything non-zero claims at least one cell, so "just started" never reads as
# "not started".
pct_to_cells() {
	_p=$(printf '%.0f' "$1")
	[ "$_p" -lt 0 ] && _p=0
	[ "$_p" -gt 100 ] && _p=100
	_cells=$(((_p * BAR_WIDTH + 50) / 100)) # +50 rounds to nearest, not down
	# "Non-zero claims a cell" has to be judged on the raw value: 0.4 rounds to
	# 0 above, yet is still usage. Deleting every '0' and '.' leaves an empty
	# string only for a genuine zero.
	if [ "$_cells" -eq 0 ] && [ -n "$(printf '%s' "$1" | tr -d '0.')" ]; then
		_cells=1
	fi
	printf '%s' "$_cells"
}

# The statusLine payload documents resets_at as Unix epoch *seconds*, but the
# same field travels as an ISO 8601 string elsewhere in Claude Code, so accept
# either rather than betting the gauge on one representation surviving.
to_epoch() {
	_v=${1%%.*} # drop a fractional part: epoch floats, ISO fractional seconds
	case "$_v" in
	'') ;;
	*[!0-9]*) date -d "$1" +%s 2>/dev/null ;;                                 # ISO 8601
	*) if [ "$_v" -gt 100000000000 ]; then echo $((_v / 1000)); else echo "$_v"; fi ;; # epoch s / ms
	esac
}

fmt_left() {
	_s=$1
	[ "$_s" -lt 0 ] && _s=0
	_h=$((_s / 3600))
	_m=$(((_s % 3600) / 60))
	if [ "$_h" -gt 0 ]; then
		printf '%dh%02dm' "$_h" "$_m"
	else
		printf '%dm' "$_m"
	fi
}

# Paint BAR_WIDTH half-block cells: $1 filled cells on the top line coloured
# $3, $2 filled cells on the bottom line coloured $C_TIME.
gauge() {
	_used=$1 _elapsed=$2 _used_color=$3 _i=0
	while [ "$_i" -lt "$BAR_WIDTH" ]; do
		if [ "$_i" -lt "$_used" ]; then _fg=$_used_color; else _fg=$C_TRACK; fi
		if [ "$_i" -lt "$_elapsed" ]; then _bg=$C_TIME; else _bg=$C_TRACK; fi
		printf '\033[38;5;%s;48;5;%sm\342\226\200' "$_fg" "$_bg"
		_i=$((_i + 1))
	done
	printf '\033[0m'
}

# --- line 1: prompt + inline metadata ---------------------------------------

prompt=$(printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' "$(whoami)" "$(hostname -s)" "$cwd")

extras=""
append() {
	if [ -n "$extras" ]; then extras="$extras | $1"; else extras="$1"; fi
}

[ -n "$model" ] && append "$model"
[ -n "$ctx_pct" ] && append "ctx:$(printf '%.0f' "$ctx_pct")%"
[ -n "$seven_pct" ] && append "7d:$(printf '%.0f' "$seven_pct")%"

if [ -n "$extras" ]; then
	line1=$(printf '%s [%s]' "$prompt" "$extras")
else
	line1=$prompt
fi

# --- line 2: the pacing gauge -----------------------------------------------

# No subscription usage in the payload (API key auth, or before the first API
# response of a session) — nothing to gauge, so emit the prompt alone.
if [ -z "$five_pct" ]; then
	printf '%s\n' "$line1"
	exit 0
fi

used_cells=$(pct_to_cells "$five_pct")
used_color=$C_USED
[ "$(printf '%.0f' "$five_pct")" -ge "$HOT_THRESHOLD" ] && used_color=$C_USED_HOT

elapsed_cells=0
left_label=""
resets_epoch=$(to_epoch "$five_resets")
if [ -n "$resets_epoch" ]; then
	remaining=$((resets_epoch - $(date +%s)))
	[ "$remaining" -lt 0 ] && remaining=0
	[ "$remaining" -gt "$WINDOW_SECONDS" ] && remaining=$WINDOW_SECONDS
	elapsed_cells=$(((WINDOW_SECONDS - remaining) * BAR_WIDTH / WINDOW_SECONDS))
	left_label=$(fmt_left "$remaining")
fi

printf '%s' "$line1"
if [ "$GAUGE_OWN_LINE" -eq 1 ]; then printf '\n  '; else printf '  '; fi

gauge "$used_cells" "$elapsed_cells" "$used_color"
printf ' \033[38;5;%sm%s%% used\033[0m' "$used_color" "$(printf '%.0f' "$five_pct")"
[ -n "$left_label" ] && printf ' \033[38;5;244m·\033[0m \033[38;5;%sm%s left\033[0m' "$C_TIME" "$left_label"
printf '\n'
