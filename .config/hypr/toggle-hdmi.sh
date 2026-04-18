#!/bin/bash
# Toggle HDMI monitor

MONITOR="HDMI-A-1"

# Check if monitor is currently active
if hyprctl monitors | grep -q "Monitor $MONITOR"; then
    # Monitor is active, disable it
    hyprctl keyword monitor "$MONITOR,disable"
else
    # Monitor is disabled, enable it
    hyprctl keyword monitor "$MONITOR,1920x1080@60,0x0,1.25"
fi
