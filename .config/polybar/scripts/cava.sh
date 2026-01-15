#!/bin/bash

# ============================================================================
# Cava Audio Visualizer for Polybar - Clean Version
# ============================================================================

# Cava config file
cava_config="$HOME/.config/polybar/scripts/cava_config"

# Create cava config if it doesn't exist
if [ ! -f "$cava_config" ]; then
    cat > "$cava_config" << EOF
[general]
bars = 12
bar_width = 2
bar_spacing = 1
framerate = 60
autosens = 1
sensitivity = 100

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[smoothing]
monstercat = 1
waves = 0
gravity = 100
ignore = 0

[eq]
1 = 1
2 = 1
3 = 1
4 = 1
5 = 1
EOF
fi

# Bar characters for visualization (from lowest to highest)
bar_chars=(" " "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# Run cava and process output
cava -p "$cava_config" 2>/dev/null | while read -r line; do
    output=""

    # Split by semicolon and process each value
    IFS=';' read -ra values <<< "$line"

    for i in "${values[@]}"; do
        # Ensure value is within bounds
        if [ "$i" -lt 0 ] 2>/dev/null; then
            i=0
        elif [ "$i" -gt 7 ] 2>/dev/null; then
            i=7
        fi

        # Default to 0 if not a valid number
        if ! [[ "$i" =~ ^[0-9]+$ ]]; then
            i=0
        fi

        # Add bar character
        output+="${bar_chars[$i]}"
    done

    echo "$output"
done
