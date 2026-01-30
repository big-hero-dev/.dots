#!/usr/bin/env bash

check() {
  command -v "$1" 1>/dev/null
}

notify() {
  check notify-send && {
    notify-send -a "UpdateCheck Waybar" "$@"
    return
  }
  echo "$@"
}

stringToLen() {
  local STRING="$1"
  local LEN="$2"
  if [ ${#STRING} -gt "$LEN" ]; then
    echo "${STRING:0:$((LEN - 2))}.."
  else
    printf "%-${LEN}s" "$STRING"
  fi
}

escapeHTML() {
  echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}

check aur || {
  notify "Ensure aurutils is installed"
  cat <<EOF
{"text":"ERR","tooltip":"aurutils is not installed"}
EOF
  exit 1
}

check checkupdates || {
  notify "Ensure pacman-contrib is installed"
  cat <<EOF
{"text":"ERR","tooltip":"pacman-contrib is not installed"}
EOF
  exit 1
}

IFS=$'\n'
killall -q checkupdates 2>/dev/null

cup() {
  # checkupdates output: package old-version -> new-version
  checkupdates --nocolor 2>/dev/null
  # aur vercmp output: package old-version new-version
  pacman -Qm 2>/dev/null | aur vercmp 2>/dev/null
}

mapfile -t updates < <(cup)

max=10
total=${#updates[@]}
text=${#updates[@]}
tooltip="<b>$text  updates (arch+aur) </b>\n"
tooltip+="<b>$(stringToLen "PkgName" 20) $(stringToLen "PrevVersion" 15) $(stringToLen "NextVersion" 15)</b>\n"

[ "$text" -eq 0 ] && text="" || text="󰦘"

count=0
for i in "${updates[@]}"; do
  ((count++))
  [ "$count" -gt "$max" ] && break

  # Parse both formats
  if [[ "$i" =~ ^([^[:space:]]+)[[:space:]]+([^[:space:]]+)[[:space:]]+\-\>[[:space:]]+([^[:space:]]+) ]]; then
    # checkupdates format: package old -> new
    pkgname="${BASH_REMATCH[1]}"
    prev="${BASH_REMATCH[2]}"
    next="${BASH_REMATCH[3]}"
  elif [[ "$i" =~ ^([^[:space:]]+)[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+) ]]; then
    # aur vercmp format: package old new
    pkgname="${BASH_REMATCH[1]}"
    prev="${BASH_REMATCH[2]}"
    next="${BASH_REMATCH[3]}"
  else
    continue
  fi

  update="$(stringToLen "$(escapeHTML "$pkgname")" 20)"
  prevstr="$(stringToLen "$(escapeHTML "$prev")" 15)"
  nextstr="$(stringToLen "$(escapeHTML "$next")" 15)"
  tooltip+="<b>$update</b> $prevstr $nextstr\n"
done

if [ "$total" -gt "$max" ]; then
  rest=$((total - max))
  tooltip+="\n<i>… and $rest more</i>"
fi

tooltip=${tooltip%\\n}

cat <<EOF
{"text":"$text", "tooltip":"$tooltip"}
EOF
