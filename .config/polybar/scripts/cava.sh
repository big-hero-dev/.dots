#!/bin/bash

# Cava config file for Polybar
cava_config="$HOME/.config/polybar/scripts/cava_config"

# Create cava config if it doesn't exist
if [ ! -f "$cava_config" ]; then
    cat > "$cava_config" << EOF
[general]
bars = 8
bar_width = 2
bar_spacing = 1

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
fi

# Bar characters for visualization (from lowest to highest)
bar_chars=(" " "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# Run cava and process output
cava -p "$cava_config" | while read -r line; do
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
        output+="${bar_chars[$i]}"
    done
    echo "$output"
done
