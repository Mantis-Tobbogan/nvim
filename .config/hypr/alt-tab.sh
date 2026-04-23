#!/bin/bash
# Alt+Tab: cycle windows on the same workspace
# Preserves the fullscreen state (0=none, 1=real fullscreen, 2=maximize)

direction="${1:-next}"

active=$(hyprctl activewindow -j 2>/dev/null)
fs_mode=$(echo "$active" | jq -r '.fullscreen')
active_addr=$(echo "$active" | jq -r '.address')
ws_id=$(echo "$active" | jq -r '.workspace.id')

# Get all windows on current workspace
windows=$(hyprctl clients -j | jq -c "[.[] | select(.workspace.id == $ws_id)]")

count=$(echo "$windows" | jq 'length')
if [ "$count" -le 1 ]; then
    exit 0
fi

# Find current window index
current_idx=$(echo "$windows" | jq "[.[].address] | index(\"$active_addr\")")

# Calculate next index
if [ "$direction" = "prev" ]; then
    next_idx=$(( (current_idx - 1 + count) % count ))
else
    next_idx=$(( (current_idx + 1) % count ))
fi

next_addr=$(echo "$windows" | jq -r ".[$next_idx].address")

# Focus the next window
hyprctl dispatch focuswindow "address:$next_addr"

# Re-apply the same fullscreen state using fullscreenstate (explicit set, not toggle)
# .fullscreen: 0=none, 1=real fullscreen, 2=maximize
# fullscreenstate args: <internal> <client>
if [ "$fs_mode" = "1" ]; then
    hyprctl dispatch fullscreenstate 1 1
elif [ "$fs_mode" = "2" ]; then
    hyprctl dispatch fullscreenstate 2 2
fi
