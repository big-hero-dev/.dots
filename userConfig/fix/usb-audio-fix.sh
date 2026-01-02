#!/bin/bash

systemctl --user restart pipewire-pulse
sleep 2
pactl set-default-sink $(pactl list short sinks | grep usb | head -1 | cut -f1)
