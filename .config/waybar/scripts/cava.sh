#!/usr/bin/env bash
sleep 1

BARS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

export LC_ALL=C

cava -p "$HOME/.config/cava/config" | while IFS= read -r line; do
  out=""

  IFS=';' read -ra values <<< "$line"
  for v in "${values[@]}"; do
    [[ "$v" =~ ^[0-7]$ ]] || continue
    out+="${BARS[v]}"
  done

  printf '{"text":"%s","class":"cava"}\n' "$out"
done
