#!/usr/bin/env bash

# Add this script to your wm startup file.

# DIR="$HOME/.config/polybar/neon"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
echo $SCRIPT_DIR

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q main -c "${SCRIPT_DIR}"/config.ini &
