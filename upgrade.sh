#!/bin/bash
SERVER_CONF="/etc/openvpn/server.conf"
SERVER_UDP_CONF="/etc/openvpn/udp_premium.conf"
SERVER_TCP_CONF="/etc/openvpn/tcp_premium.conf"
TC_SCRIPT="/etc/openvpn/tc.sh"
TC_SCRIPT_URL="https://raw.githubusercontent.com/solver44/CosmosVPN/main/tc.sh"

# Check if the server.conf file exists
if [[ ! -f "$SERVER_CONF" ]]; then
    echo "The server.conf file does not exist: $SERVER_CONF"
    exit 1
fi

# Copy the server.conf file to udp_premium.conf and tcp_premium
cp "$SERVER_CONF" "$SERVER_UDP_CONF"
cp "$SERVER_CONF" "$SERVER_TCP_CONF"

# Append the additional lines to the original server.conf file
{
    echo "script-security 2"
    echo "down-pre"
    echo "client-connect $TC_SCRIPT"
    echo "client-disconnect $TC_SCRIPT"
} >> "$SERVER_CONF"

# Change the port and protocol in the udp_premium.conf and tcp_premium files
sed -i 's/^port .*/port 1196/; s/^proto .*/proto udp/' "$SERVER_UDP_CONF"
sed -i 's/^port .*/port 1198/' "$SERVER_TCP_CONF"

# Download the tc.sh script if it doesn't exist
if [[ ! -f "$TC_SCRIPT" ]]; then
    echo "Downloading tc.sh script from $TC_SCRIPT_URL..."
    curl -o "$TC_SCRIPT" "$TC_SCRIPT_URL"
    chmod +x "$TC_SCRIPT"
fi

echo "The server.conf file has been copied to $SERVER_UDP_CONF adn $SERVER_TCP_CONF."
echo "Additional lines have been added to $SERVER_CONF."
