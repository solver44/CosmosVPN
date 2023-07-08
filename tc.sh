#!/bin/bash

INTERFACE="tun0"
LIMIT="20mbit"
LOG_FILE="/var/log/openvpn/tc.log"

# Function to check if a user is already limited
is_user_limited() {
    local user_ip=$1
    local result=$(tc filter show dev "$INTERFACE" | grep -w "$user_ip")
    [[ -n "$result" ]]
}

# Function to set speed limit for a user
set_speed_limit() {
    local user_ip=$1
    tc qdisc del dev "$INTERFACE" root &>/dev/null
    tc qdisc add dev "$INTERFACE" root handle 1: htb default 10
    tc class add dev "$INTERFACE" parent 1: classid 1:10 htb rate "$LIMIT"
    tc filter add dev "$INTERFACE" protocol ip parent 1: prio 1 u32 match ip dst "$user_ip" flowid 1:10
}

# Function to remove speed limit for a user
remove_speed_limit() {
    local user_ip=$1
    tc filter del dev "$INTERFACE" protocol ip parent 1: prio 1 u32 match ip dst "$user_ip" flowid 1:10
}

# Function to log events
log_event() {
    local event=$1
    local message=$2
    echo "$(date) - $event: $message" >> "$LOG_FILE"
}

# Main script logic
case "$script_type" in
    client-connect)
        if ! is_user_limited "$trusted_ip"; then
            set_speed_limit "$trusted_ip"
            # log_event "client-connect" "Speed limit set for client IP: $trusted_ip"
        # else
            # log_event "client-connect" "Client IP $trusted_ip is already limited"
        fi
        ;;
    client-disconnect)
        if is_user_limited "$trusted_ip"; then
            remove_speed_limit "$trusted_ip"
            # log_event "client-disconnect" "Speed limit removed for client IP: $trusted_ip"
        # else
        #     log_event "client-disconnect" "No speed limit found for client IP: $trusted_ip"
        fi
        ;;
    *)
        log_event "invalid-script-type" "Invalid script_type: $script_type"
        exit 1
        ;;
esac

exit 0