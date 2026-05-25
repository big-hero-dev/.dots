#!/bin/bash

PLAYING_ICON="󰐊"
PAUSED_ICON="󰏤"
STOPPED_ICON="󰝚"
ARTIST_ICON="󰠃"
TITLE_ICON="󰎈"
ALBUM_ICON="󰀥"

CACHE_DIR="/tmp/waybar_art"
CACHE="$CACHE_DIR/current.png"
LAST_URL_FILE="$CACHE_DIR/last_url.txt"
FRAME_DIR="$CACHE_DIR/frames"
CURRENT_FRAME_FILE="$CACHE_DIR/current_frame.txt"

mkdir -p "$CACHE_DIR" "$FRAME_DIR"

make_circle_art() {
    local url="$1"
    local size=64
    local tmp="$CACHE_DIR/raw.jpg"

    curl -sL "$url" -o "$tmp" || return 1

    convert "$tmp" \
        -resize "${size}x${size}^" \
        -gravity Center \
        -extent "${size}x${size}" \
        \( +clone -alpha extract \
           -draw "fill black polygon 0,0 0,${size} ${size},0 fill white circle $((size/2)),$((size/2)) $((size/2)),0" \
           \( +clone -flip \) -compose Multiply -composite \
           \( +clone -flop \) -compose Multiply -composite \
        \) \
        -alpha off -compose CopyOpacity -composite \
        "$CACHE" 2>/dev/null
}

make_frames() {
    rm -f "$FRAME_DIR"/frame_*.png
    local total=72
    local size=64
    local half=$((size/2))
    for i in $(seq 0 $((total - 1))); do
        local angle=$(( i * 360 / total ))
        convert "$CACHE" \
            -distort SRT "$angle" \
            \( +clone -alpha extract \
               -draw "fill black polygon 0,0 0,${size} ${size},0 fill white circle ${half},${half} ${half},0" \
               \( +clone -flip \) -compose Multiply -composite \
               \( +clone -flop \) -compose Multiply -composite \
            \) \
            -alpha off -compose CopyOpacity -composite \
            "$FRAME_DIR/$(printf 'frame_%03d.png' $i)" 2>/dev/null
    done
    echo "0" > "$CURRENT_FRAME_FILE"
}

if ! command -v playerctl &>/dev/null || ! command -v convert &>/dev/null; then
    exit 1
fi

STATUS=$(playerctl status 2>/dev/null)

if [[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]]; then
    ARTIST=$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")
    TITLE=$(playerctl metadata title 2>/dev/null || echo "Unknown Title")
    ALBUM=$(playerctl metadata album 2>/dev/null)
    ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)

    # Escape JSON
    ARTIST="${ARTIST//\\/\\\\}"; ARTIST="${ARTIST//\"/\\\"}"
    TITLE="${TITLE//\\/\\\\}";   TITLE="${TITLE//\"/\\\"}"
    ALBUM="${ALBUM//\\/\\\\}";   ALBUM="${ALBUM//\"/\\\"}"

    # Tải và tạo frames nếu track đổi
    if [[ -n "$ART_URL" ]]; then
        LAST=$(cat "$LAST_URL_FILE" 2>/dev/null)
        if [[ "$ART_URL" != "$LAST" ]]; then
            make_circle_art "$ART_URL" && make_frames
            echo "$ART_URL" > "$LAST_URL_FILE"
        fi
    fi

    if [[ "$STATUS" == "Playing" ]]; then
        TOOLTIP="${PLAYING_ICON} ${ARTIST} — ${TITLE}"
        [[ -n "$ALBUM" ]] && TOOLTIP="${TOOLTIP} | ${ALBUM_ICON} ${ALBUM}"
        CLASS="playing"
    else
        TOOLTIP="${PAUSED_ICON} ${ARTIST} — ${TITLE}"
        CLASS="paused"
    fi
    [[ -n "$ALBUM" ]] && TOOLTIP="${TOOLTIP}\n${ALBUM_ICON} ${ALBUM}"

    # Chọn frame hiện tại
    if [[ "$STATUS" == "Playing" && -d "$FRAME_DIR" && -f "$CURRENT_FRAME_FILE" ]]; then
        FRAME_INDEX=$(cat "$CURRENT_FRAME_FILE" 2>/dev/null || echo "0")
        TOTAL_FRAMES=$(ls "$FRAME_DIR"/frame_*.png 2>/dev/null | wc -l)
        if [[ $TOTAL_FRAMES -gt 0 ]]; then
            FRAME_INDEX=$(( (FRAME_INDEX + 1) % TOTAL_FRAMES ))
            echo "$FRAME_INDEX" > "$CURRENT_FRAME_FILE"
            IMG_PATH="$FRAME_DIR/$(printf 'frame_%03d.png' $FRAME_INDEX)"
        else
            IMG_PATH="$CACHE"
        fi
    else
        IMG_PATH="$CACHE"
    fi

    # Output cho image module: path \n tooltip \n class
    if [[ -f "$IMG_PATH" ]]; then
        echo "$IMG_PATH"
    else
        echo ""
    fi
    echo -e "$TOOLTIP"
    echo "$CLASS"

else
    exit 1
fi
