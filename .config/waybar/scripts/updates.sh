#!/usr/bin/env bash

updates=0

if command -v pacman &>/dev/null; then
    if command -v checkupdates &>/dev/null; then
        updates=$(checkupdates 2>/dev/null | wc -l)
    else
        updates=$(pacman -Qu 2>/dev/null | wc -l)
    fi
elif command -v apt &>/dev/null; then
    updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
elif command -v dnf &>/dev/null; then
    updates=$(dnf check-update --quiet 2>/dev/null | wc -l)
elif command -v zypper &>/dev/null; then
    updates=$(zypper list-updates 2>/dev/null | grep -c "^v ")
fi

# output cho waybar
if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo ""
fi
