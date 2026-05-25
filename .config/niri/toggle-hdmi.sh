#!/bin/bash
# Toggle HDMI monitor for niri

OUTPUT="HDMI-A-1"

# Check current output state via niri msg
if niri msg outputs 2>/dev/null | grep -A3 "$OUTPUT" | grep -q "current mode"; then
    # Output is active → disable it
    niri msg action output "$OUTPUT" off
else
    # Output is off → enable it
    niri msg action output "$OUTPUT" on
fi
