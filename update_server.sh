# # Download OpenVPN scripts
declare -A scripts=(
    #     ["createClient.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/createClient.sh"
    #     ["deleteClient.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/deleteClient.sh"
    #     ["returnClientTemplate.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/returnClientTemplate.sh"
    ["returnConnectedClients.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/returnConnectedClients.sh"
    #     ["setVPNDNS.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/setVPNDNS.sh"
    #     ["setVPNPort.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/setVPNPort.sh"
    #     ["setVPNProtocol.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/setVPNProtocol.sh"
    #     ["toggleVPNStatus.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/toggleVPNStatus.sh"
    #     ["removeVPN.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/removeVPN.sh"
    #     ["updateServer.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/updateServer.sh"
    #     ["changeSpeedLimit.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/changeSpeedLimit.sh"
)
# # Remove current scripts
# rm -r /var/www/*
rm -r /var/www/returnConnectedClients.sh
# # Add new scripts
for script in "${!scripts[@]}"; do
    curl -o "/var/www/$script" -L "${scripts[$script]}"
    chmod +x "/var/www/$script"
done

# # Download web files
# curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/web_dir/api.php
# curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/web_dir/functions.php

# # Move web files to /var/www/html/
# mv api.php functions.php /var/www/html/

SERVER_UDP_CONF="/etc/openvpn/udp_premium.conf"
SERVER_TCP_CONF="/etc/openvpn/tcp_premium.conf"

sed -i 's/^status .*/port /var/log/openvpn/status_udp.log/;' "$SERVER_UDP_CONF"
sed -i 's/^status .*/port /var/log/openvpn/status_tcp.log/;' "$SERVER_TCP_CONF"

systemctl restart openvpn@udp_premium.service
systemctl restart openvpn@tcp_premium.service