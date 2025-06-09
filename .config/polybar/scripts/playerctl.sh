#!/bin/bash

MAX_LENGTH=60
MUSIC_ICON=""

truncate_text() {
    local text="$1"

    if command -v python3 >/dev/null 2>&1; then
        echo "$text" | python3 -c "
text = input()
if len(text) > $MAX_LENGTH:
    print(text[:$((MAX_LENGTH-3))] + '...')
else:
    print(text)
"
    else
        if [ ${#text} -gt $MAX_LENGTH ]; then
            echo "${text:0:$((MAX_LENGTH/2))}..."
        else
            echo "$text"
        fi
    fi
}

status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

if [ "$status" = "Playing" ] && [ -n "$title" ]; then
    title=$(truncate_text "$title")
    echo "$MUSIC_ICON $title"
fi
