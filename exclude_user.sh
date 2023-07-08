#!/bin/bash

CLIENT_NAME="$common_name"
EXCLUDE_NAME="CosmosVPN_FREE_ACCOUNT"

# Function to disable the connection for a specific client on the connected interface
disable_client_connection() {
    # Get the client's IP address
    client_ip="$ifconfig_pool_remote_ip"

    # Get the connected client's interface
    connected_interface="$dev"

    # Block the client's traffic using iptables on the connected interface
    iptables -I FORWARD -i "$connected_interface" -s "$client_ip" -j DROP
    iptables -I FORWARD -i "$connected_interface" -d "$client_ip" -j DROP

    # Log the action
    echo "$(date) - Connection disabled for client: $CLIENT_NAME (IP: $client_ip) on interface: $connected_interface"
}


# Main script logic
case "$script_type" in
    client-connect)
        if [ "$CLIENT_NAME" = "$EXCLUDE_NAME" ]; then
            disable_client_connection
            exit 1
        fi
        ;;
    *)
        echo "Invalid script type: $script_type"
        exit 1
        ;;
esac

exit 0
