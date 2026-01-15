#!/usr/bin/env bash

# ============================================================================
# Polybar Playerctl Script - Multi-player Support
# ============================================================================

MAX_LENGTH=40

# Check playerctl exists
if ! command -v playerctl &> /dev/null; then
    exit 0
fi

# Priority order for players (customize as needed)
PRIORITY_PLAYERS=(
    "spotify"
    "vlc"
    "mpv"
    "chromium"
    "firefox"
    "brave"
)

# ============================================================================
# Find active player
# ============================================================================

get_active_player() {
    local players=$(playerctl -l 2>/dev/null)

    if [ -z "$players" ]; then
        return 1
    fi

    # First, check priority players
    for priority in "${PRIORITY_PLAYERS[@]}"; do
        for player in $players; do
            if [[ "$player" == "$priority"* ]]; then
                local status=$(playerctl -p "$player" status 2>/dev/null)
                if [ "$status" = "Playing" ]; then
                    echo "$player"
                    return 0
                fi
            fi
        done
    done

    # If no priority player is playing, check any playing player
    for player in $players; do
        local status=$(playerctl -p "$player" status 2>/dev/null)
        if [ "$status" = "Playing" ]; then
            echo "$player"
            return 0
        fi
    done

    # If nothing is playing, check for paused
    for player in $players; do
        local status=$(playerctl -p "$player" status 2>/dev/null)
        if [ "$status" = "Paused" ]; then
            echo "$player"
            return 0
        fi
    done

    # Return first player as fallback
    echo "$players" | head -n1
    return 0
}

# ============================================================================
# Main Logic
# ============================================================================

ACTIVE_PLAYER=$(get_active_player)

if [ -z "$ACTIVE_PLAYER" ]; then
    exit 0
fi

# Get metadata from active player
STATUS=$(playerctl -p "$ACTIVE_PLAYER" status 2>/dev/null)
TITLE=$(playerctl -p "$ACTIVE_PLAYER" metadata title 2>/dev/null)
ARTIST=$(playerctl -p "$ACTIVE_PLAYER" metadata artist 2>/dev/null)

# Exit if no title
if [ -z "$TITLE" ]; then
    exit 0
fi

# Build output
if [ -n "$ARTIST" ]; then
    OUTPUT="${ARTIST} - ${TITLE}"
else
    OUTPUT="${TITLE}"
fi

# Truncate
if [ ${#OUTPUT} -gt $MAX_LENGTH ]; then
    OUTPUT="${OUTPUT:0:$((MAX_LENGTH-1))}…"
fi

# Show with icon based on status
case "$STATUS" in
    Playing)
        echo "%{F#a7c080}󰐊%{F-} $OUTPUT"
        ;;
    Paused)
        echo "%{F#dbbc7f}󰏤%{F-} $OUTPUT"
        ;;
    *)
        exit 0
        ;;
esac
