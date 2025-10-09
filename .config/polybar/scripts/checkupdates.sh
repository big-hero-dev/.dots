#!/bin/bash

# Polybar module to check for available updates with password support
# Place this script in ~/.config/polybar/scripts/checkupdates.sh
# Make it executable with: chmod +x ~/.config/polybar/scripts/checkupdates.sh

# Check for updates (without requiring password)
if command -v pacman &> /dev/null; then
    # Arch Linux (using checkupdates if available)
    if command -v checkupdates &> /dev/null; then
        updates=$(checkupdates | wc -l)
    else
        updates=$(pacman -Qu | wc -l)
    fi
elif command -v apt &> /dev/null; then
    # Debian/Ubuntu
    updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
elif command -v dnf &> /dev/null; then
    # Fedora
    updates=$(dnf check-update --quiet | grep -v "^$" | wc -l)
elif command -v yum &> /dev/null; then
    # CentOS/RHEL
    updates=$(yum check-update --quiet | grep -v "^$" | wc -l)
elif command -v zypper &> /dev/null; then
    # openSUSE
    updates=$(zypper list-updates | grep -c "^v ")
else
    updates="?"
fi

# Handle click action
if [ "$1" == "update" ]; then
    # Determine what terminal and update command to use
    TERM="alacritty"  # Change to your preferred terminal

    if command -v pacman &> /dev/null; then
        # For Arch Linux
        if command -v paru &> /dev/null; then
            $TERM -e bash -c "paru -Syu; echo 'Press any key to exit'; read -n 1"
        else
            $TERM -e bash -c "sudo pacman -Syu; echo 'Press any key to exit'; read -n 1"
        fi
    elif command -v apt &> /dev/null; then
        # For Debian/Ubuntu
        $TERM -e bash -c "sudo apt update && sudo apt upgrade; echo 'Press any key to exit'; read -n 1"
    elif command -v dnf &> /dev/null; then
        # For Fedora
        $TERM -e bash -c "sudo dnf upgrade; echo 'Press any key to exit'; read -n 1"
    elif command -v yum &> /dev/null; then
        # For CentOS/RHEL
        $TERM -e bash -c "sudo yum update; echo 'Press any key to exit'; read -n 1"
    elif command -v zypper &> /dev/null; then
        # For openSUSE
        $TERM -e bash -c "sudo zypper update; echo 'Press any key to exit'; read -n 1"
    fi

    exit 0
fi

# Display updates count with icon
if [ "$updates" -gt 0 ] || [ "$updates" = "?" ]; then
    echo "[UPD: $updates]"
else
	echo ""
fi
