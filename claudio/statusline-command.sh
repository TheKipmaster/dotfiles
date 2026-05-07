#!/bin/sh
# Claude Code statusLine command
# Derived from PS1 in ~/.bashrc: \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$

input=$(cat)

user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Bold green user@host, reset, colon, bold blue cwd, reset
prompt=$(printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' "$user" "$host" "$cwd")

# Append model name if available
extras=""
if [ -n "$model" ]; then
    extras="$model"
fi

# Append context usage if available
if [ -n "$used" ]; then
    used_fmt=$(printf '%.0f' "$used")
    if [ -n "$extras" ]; then
        extras="$extras | ctx:${used_fmt}%"
    else
        extras="ctx:${used_fmt}%"
    fi
fi

# Append 5-hour session usage if available
if [ -n "$five_hour" ]; then
    five_fmt=$(printf '%.0f' "$five_hour")
    if [ -n "$extras" ]; then
        extras="$extras | 5h:${five_fmt}%"
    else
        extras="5h:${five_fmt}%"
    fi
fi

# Append 7-day weekly usage if available
if [ -n "$seven_day" ]; then
    seven_fmt=$(printf '%.0f' "$seven_day")
    if [ -n "$extras" ]; then
        extras="$extras | 7d:${seven_fmt}%"
    else
        extras="7d:${seven_fmt}%"
    fi
fi

if [ -n "$extras" ]; then
    printf '%s [%s]\n' "$prompt" "$extras"
else
    printf '%s\n' "$prompt"
fi
