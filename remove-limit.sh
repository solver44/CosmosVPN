#!/bin/bash

INTERFACE="tun0"

# Function to remove speed limit for all users
remove_speed_limit() {
    tc qdisc del dev "$INTERFACE" root &>/dev/null
}

# Remove speed limits
remove_speed_limit

echo "All speed limits have been removed"