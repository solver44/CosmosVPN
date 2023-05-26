#!/bin/bash
# Download and install OpenVPN
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn-install.sh
chmod +x openvpn-install.sh
AUTO_INSTALL=y ./openvpn-install.sh

echo -e "\nOpenVPN installed!"