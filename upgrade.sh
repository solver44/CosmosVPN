#!/bin/bash
SERVER_CONF="/etc/openvpn/server.conf"
SERVER_UDP_CONF="/etc/openvpn/udp_premium.conf"
SERVER_TCP_CONF="/etc/openvpn/tcp_premium.conf"
TC_SCRIPT="/etc/openvpn/tc.sh"
TC_SCRIPT_URL="https://raw.githubusercontent.com/solver44/CosmosVPN/main/tc.sh"
EXCLUDE_SCRIPT="/etc/openvpn/exclude_user.sh"
EXCLUDE_SCRIPT_URL="https://raw.githubusercontent.com/solver44/CosmosVPN/main/exclude_user.sh"

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
# s/^dev .*/dev tun1/
# server 10.8.0.0 255.255.255.0
sed -i 's/^port .*/port 1196/; s/^proto .*/proto udp/; s/^server .*/server 10.9.0.0 255.255.255.0/' "$SERVER_UDP_CONF"
sed -i 's/^port .*/port 1198/; s/^server .*/server 10.10.0.0 255.255.255.0/' "$SERVER_TCP_CONF"
echo "client-connect $EXCLUDE_SCRIPT" >> "$SERVER_UDP_CONF"
echo "client-connect $EXCLUDE_SCRIPT" >> "$SERVER_TCP_CONF"
# add rules
NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
iptables -t nat -I POSTROUTING 1 -s 10.9.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -I POSTROUTING 1 -s 10.10.0.0/24 -o $NIC -j MASQUERADE
iptables -I INPUT 1 -i tun1 -j ACCEPT
iptables -I FORWARD 1 -i $NIC -o tun1 -j ACCEPT
iptables -I FORWARD 1 -i tun1 -o $NIC -j ACCEPT
iptables -I INPUT 1 -i tun2 -j ACCEPT
iptables -I FORWARD 1 -i $NIC -o tun2 -j ACCEPT
iptables -I FORWARD 1 -i tun2 -o $NIC -j ACCEPT

# allo ports
ufw allow 1196/udp
ufw allow 1198/tcp
ufw reload

# Download the tc.sh script if it doesn't exist
if [[ ! -f "$TC_SCRIPT" ]]; then
    echo "Downloading tc.sh script from $TC_SCRIPT_URL..."
    curl -o "$TC_SCRIPT" "$TC_SCRIPT_URL"
    chmod +x "$TC_SCRIPT"
fi
# Download the exclude.sh script if it doesn't exist
if [[ ! -f "$EXCLUDE_SCRIPT" ]]; then
    echo "Downloading exclude_user.sh script from $EXCLUDE_SCRIPT_URL..."
    curl -o "$EXCLUDE_SCRIPT" "$EXCLUDE_SCRIPT_URL"
    chmod +x "$EXCLUDE_SCRIPT"
fi

start_openvpn() {
    systemctl start openvpn@udp_premium.service
    systemctl start openvpn@tcp_premium.service
}

start_openvpn
echo "The server.conf file has been copied to $SERVER_UDP_CONF and $SERVER_TCP_CONF."
echo "Additional lines have been added to $SERVER_CONF."
