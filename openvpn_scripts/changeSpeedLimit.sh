#!/bin/bash

NEW_LIMIT="$1"
TC_SCRIPT="/etc/openvpn/tc.sh"

# Validate the input limit value
validate_limit() {
    local limit=$1
    local regex="^[0-9]+(kbit|mbit|gbit)$"
    if [[ $limit =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}

# Main script logic
if [[ $# -eq 0 ]]; then
    # echo "Usage: $0 <limit>"
    exit 1
fi

if validate_limit "$NEW_LIMIT"; then
    sed -i "s/^LIMIT=\"[^\"]*\"/LIMIT=\"$NEW_LIMIT\"/" "$TC_SCRIPT"
    echo "Limit changed to $NEW_LIMIT"
    clear
    echo true
else
    echo "Invalid limit value. Valid format: <number>kbit|mbit|gbit"
    clear
fi
