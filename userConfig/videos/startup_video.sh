#!/bin/bash

# Path to the video file
VIDEO_PATH="$HOME/userConfig/videos/Wake the F Up Samurai.mp4"

# Check if the video file exists
if [ ! -f "$VIDEO_PATH" ]; then
    notify-send "System Error" "Video file not found at $VIDEO_PATH" -u critical
    exit 1
fi

# Display Cyberpunk 2077-style system boot notifications
notify-send "NETRUNNER OS v7.7" "BOOT SEQUENCE INITIATED" -u normal -t 2000
sleep 2
notify-send "System" "> Initializing hardware... [OK]" -u low -t 2000
sleep 2
notify-send "System" "> Loading cyberware drivers... [OK]" -u low -t 2000
sleep 2
notify-send "Night City Grid" "> Connecting to Night City grid... [SECURE]" -u normal -t 2000
sleep 2

# Wait for PipeWire to initialize and detect audio devices
sleep 3  # Extended delay to ensure PipeWire is ready

# Get the sink name for USB headphones
AUDIO_SINK=$(pactl list short sinks | grep -i "usb" | awk '{print $2}')

# Set the USB headphone sink as default if found
if [ -n "$AUDIO_SINK" ]; then
    pactl set-default-sink "$AUDIO_SINK"
    notify-send "Audio System" "> Audio output rerouted to USB cyber-enhanced headphones... [OK]" -u normal -t 2000
else
    notify-send "Audio Warning" "> No USB headphones detected. Default sink unchanged." -u normal -t 2000
fi


# Launch VLC with software rendering, specific size, and wait for it to finish
notify-send "System" "> Video feed engaged. System online." -u normal -t 2000
cvlc --no-video-title-show "$VIDEO_PATH" &

exit 0
