#!/bin/bash

ICONS=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
ICON_INDEX=0

PLAYING_ICON="󰐊"    # Playing
PAUSED_ICON="󰏤"     # Paused
STOPPED_ICON="󰝚"    # Stopped

get_music_status() {
    if ! command -v playerctl &> /dev/null; then
        printf '{"text":"%s","class":"stopped","tooltip":"Need to install playerctl: sudo pacman -S playerctl"}\n' "$STOPPED_ICON"
        return
    fi

    STATUS=$(playerctl status 2>/dev/null)

    if [ "$STATUS" = "Playing" ]; then
        ARTIST=$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")
        TITLE=$(playerctl metadata title 2>/dev/null || echo "Unknown Title")
        ALBUM=$(playerctl metadata album 2>/dev/null)

        ARTIST="${ARTIST//\\/\\\\}"
        ARTIST="${ARTIST//\"/\\\"}"
        TITLE="${TITLE//\\/\\\\}"
        TITLE="${TITLE//\"/\\\"}"
        ALBUM="${ALBUM//\\/\\\\}"
        ALBUM="${ALBUM//\"/\\\"}"

        SPINNER="${ICONS[$ICON_INDEX]}"
        ICON_INDEX=$(( (ICON_INDEX + 1) % ${#ICONS[@]} ))

        TOOLTIP="🎵 Playing\\n${ARTIST}\\n${TITLE}"
        [ -n "$ALBUM" ] && TOOLTIP="${TOOLTIP}\\n📀 ${ALBUM}"

        printf '{"text":"%s","class":"playing","tooltip":"%s"}\n' "$SPINNER" "$TOOLTIP"

    elif [ "$STATUS" = "Paused" ]; then
        ARTIST=$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")
        TITLE=$(playerctl metadata title 2>/dev/null || echo "Unknown Title")

        ARTIST="${ARTIST//\\/\\\\}"
        ARTIST="${ARTIST//\"/\\\"}"
        TITLE="${TITLE//\\/\\\\}"
        TITLE="${TITLE//\"/\\\"}"

        TOOLTIP="⏸ Paused\\n${ARTIST}\\n${TITLE}"

        printf '{"text":"%s","class":"paused","tooltip":"%s"}\n' "$PAUSED_ICON" "$TOOLTIP"

    else
        printf '{"text":"%s","class":"stopped","tooltip":"No music playing"}\n' "$STOPPED_ICON"
    fi
}

while true; do
    get_music_status
    sleep 0.5
done
