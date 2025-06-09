#!/usr/bin/env bash

# Kiểm tra trạng thái player
playerctlstatus=$(playerctl status 2>/dev/null)
if [[ $? -ne 0 || -z "$playerctlstatus" ]]; then
  echo ""
  exit 0
fi

# Lấy trạng thái và metadata
status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

# Kiểm tra metadata trống
if [[ -z "$title" && -z "$artist" ]]; then
  echo ""
  exit 0
fi

# Kết hợp artist và title
if [[ -n "$artist" && -n "$title" ]]; then
  display_text="$artist - $title"
elif [[ -n "$title" ]]; then
  display_text="$title"
else
  display_text="$artist"
fi

# Hàm đếm số ký tự Hán (CJK)
count_cjk() {
  echo "$1" | grep -o "[\p{Han}]" | wc -l
}

# Hàm tính độ rộng hiển thị (CJK = 2, Latin/Dấu = 1)
calculate_width() {
  local text="$1"
  local width=0
  for ((i=0; i<${#text}; i++)); do
    char="${text:$i:1}"
    if [[ $(count_cjk "$char") -eq 1 ]]; then
      ((width+=2))
    else
      ((width+=1))
    fi
  done
  echo "$width"
}

# Giới hạn độ rộng hiển thị (tổng cộng 20 đơn vị, tối đa 10 ký tự Hán)
max_width=50    # Tổng độ rộng hiển thị (tương đương ~10 ký tự CJK hoặc ~20 ký tự Latin)
max_cjk=25      # Giới hạn số ký tự Hán

cjk_count=$(count_cjk "$display_text")
total_width=$(calculate_width "$display_text")

if [ $total_width -gt $max_width ] || [ $cjk_count -gt $max_cjk ]; then
  # Cắt ngắn chuỗi dựa trên độ rộng
  truncated=""
  cjk_so_far=0
  width_so_far=0
  for ((i=0; i<${#display_text}; i++)); do
    char="${display_text:$i:1}"
    if [[ $(count_cjk "$char") -eq 1 ]]; then
      if [ $cjk_so_far -lt $max_cjk ] && [ $((width_so_far + 2)) -le $max_width ]; then
        truncated="$truncated$char"
        ((cjk_so_far++))
        ((width_so_far+=2))
      fi
    else
      if [ $((width_so_far + 1)) -le $max_width ]; then
        truncated="$truncated$char"
        ((width_so_far+=1))
      fi
    fi
  done
  display_text="${truncated}..."
fi

# Hiển thị dựa trên trạng thái
if [[ "$status" == "Playing" ]]; then
  echo "$display_text"
elif [[ "$status" == "Paused" ]]; then
  echo "(PAUSED) $display_text"
else
  echo ""
fi
