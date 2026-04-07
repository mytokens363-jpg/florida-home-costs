#!/bin/bash
# Launch IB Gateway 10.45 with proper configuration

IB_APP="IB Gateway 10.45"
IB_PATH="/Users/dariusvitkus/Applications/IB Gateway 10.45/IB Gateway 10.45.app/Contents/MacOS/IB Gateway"

# Check if IB Gateway 10.45 is already running
if pgrep -f "IB Gateway 10.45" > /dev/null; then
    echo "IB Gateway 10.45 is already running."
    echo "PID: $(pgrep -f 'IB Gateway 10.45')"
    exit 0
fi

echo "Starting IB Gateway 10.45..."
open -a "$IB_APP"

echo "Waiting for IB Gateway 10.45 to start..."
sleep 8

# Verify it's running
if pgrep -f "IB Gateway 10.45" > /dev/null; then
    echo "IB Gateway 10.45 started successfully!"
    echo "PID: $(pgrep -f 'IB Gateway 10.45')"
else
    echo "Failed to start IB Gateway 10.45"
    exit 1
fi
