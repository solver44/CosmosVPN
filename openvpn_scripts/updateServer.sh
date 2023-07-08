# Download OpenVPN scripts
declare -A scripts=(
    ["createClient.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/createClient.sh"
    ["deleteClient.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/deleteClient.sh"
    ["returnClientTemplate.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/returnClientTemplate.sh"
    ["returnConnectedClients.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/returnConnectedClients.sh"
    ["setVPNDNS.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/setVPNDNS.sh"
    ["setVPNPort.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/setVPNPort.sh"
    ["setVPNProtocol.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/setVPNProtocol.sh"
    ["toggleVPNStatus.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/toggleVPNStatus.sh"
    ["removeVPN.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/removeVPN.sh"
    ["changeSpeedLimit.sh"]="https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn_scripts/changeSpeedLimit.sh"
)
# Remove current scripts
rm -r /var/www/*
# Add new scripts
for script in "${!scripts[@]}"; do
    curl -o "/var/www/$script" -L "${scripts[$script]}"
    chmod +x "/var/www/$script"
done

# Download web files
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/web_dir/api.php
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/web_dir/functions.php

# Move web files to /var/www/html/
mv api.php functions.php /var/www/html/