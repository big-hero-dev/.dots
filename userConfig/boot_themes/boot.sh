#!/bin/bash

# === Select theme here ===
THEME="wukong"   # wukong | cyberpunk

THEME_DIR="$HOME/userConfig/boot_themes/themes/$THEME"
CONFIG_FILE="$THEME_DIR/config.conf"
MESSAGES_FILE="$THEME_DIR/messages.txt"

# Check for config and message files
if [ ! -f "$CONFIG_FILE" ] || [ ! -f "$MESSAGES_FILE" ]; then
    notify-send "Boot Error" "Missing config or messages for theme '$THEME'" -u critical
    exit 1
fi

# Load config (e.g., VIDEO_PATH and DEFAULT_SINK_KEYWORD)
source "$CONFIG_FILE"

# Check if video exists
if [ ! -f "$VIDEO_PATH" ]; then
    notify-send "System Error" "Video not found at $VIDEO_PATH" -u critical
    exit 1
fi

# Read messages
mapfile -t lines < "$MESSAGES_FILE"

for line in "${lines[@]}"; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Handle $TITLE = ...
    if [[ "$line" =~ ^\$TITLE[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        TITLE="${BASH_REMATCH[1]}"
        continue
    fi

    # Parse format: <title> > <message> | <urgency>
    IFS=">" read -r title rest <<< "$line"
    IFS="|" read -r message urgency <<< "$rest"

    final_title=$(echo "${title:-$TITLE}" | xargs)
    final_message=$(echo "$message" | xargs)
    final_urgency=$(echo "${urgency:-normal}" | xargs)

    notify-send --urgency="$final_urgency" "$final_title" "$final_message" -t 2000
    sleep 2
done

# Wait for PipeWire to initialize
sleep 3

# Set USB audio if available
AUDIO_SINK=$(pactl list short sinks | grep -i "$DEFAULT_SINK_KEYWORD" | awk '{print $2}')
if [ -n "$AUDIO_SINK" ]; then
    pactl set-default-sink "$AUDIO_SINK"
    notify-send --urgency=normal "Audio" "Audio output rerouted... [OK]"
else
    notify-send --urgency=normal "Warning" "No USB headset found. Default sink used."
fi

# Play video
notify-send --urgency=normal "System" "Launching memory feed..."
mpv "$VIDEO_PATH" &
