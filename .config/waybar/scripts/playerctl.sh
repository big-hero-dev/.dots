#!/usr/bin/env bash

MAX_LENGTH=40

command -v playerctl &>/dev/null || exit 0

PRIORITY_PLAYERS=(
  spotify
  vlc
  mpv
  chromium
  firefox
  brave
)

get_active_player() {
  local players
  players=$(playerctl -l 2>/dev/null) || return 1
  [ -z "$players" ] && return 1

  for p in "${PRIORITY_PLAYERS[@]}"; do
    for pl in $players; do
      [[ "$pl" == "$p"* ]] || continue
      [ "$(playerctl -p "$pl" status 2>/dev/null)" = "Playing" ] && {
        echo "$pl"; return 0;
      }
    done
  done

  for pl in $players; do
    [ "$(playerctl -p "$pl" status 2>/dev/null)" = "Playing" ] && {
      echo "$pl"; return 0;
    }
  done

  for pl in $players; do
    [ "$(playerctl -p "$pl" status 2>/dev/null)" = "Paused" ] && {
      echo "$pl"; return 0;
    }
  done

  echo "$players" | head -n1
}

ACTIVE_PLAYER=$(get_active_player) || {
  echo '{"text":"— silence —","class":"idle"}'
  exit 0
}

STATUS=$(playerctl -p "$ACTIVE_PLAYER" status 2>/dev/null)
TITLE=$(playerctl -p "$ACTIVE_PLAYER" metadata title 2>/dev/null)
ARTIST=$(playerctl -p "$ACTIVE_PLAYER" metadata artist 2>/dev/null)

[ -z "$TITLE" ] && {
  echo '{"text":"— silence —","class":"idle"}'
  exit 0
}

if [ -n "$ARTIST" ]; then
  OUTPUT="$ARTIST - $TITLE"
else
  OUTPUT="$TITLE"
fi

[ ${#OUTPUT} -gt $MAX_LENGTH ] && \
  OUTPUT="${OUTPUT:0:$((MAX_LENGTH-1))}…"

case "$STATUS" in
  Playing)
    echo "{\"text\":\"󰐊 $OUTPUT\",\"class\":\"playing\",\"tooltip\":\"$OUTPUT\"}"
    ;;
  Paused)
    echo "{\"text\":\"󰏤 $OUTPUT\",\"class\":\"paused\",\"tooltip\":\"$OUTPUT\"}"
    ;;
  *)
    echo '{"text":"— silence —","class":"idle"}'
    ;;
esac
