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
)

for script in "${!scripts[@]}"; do
    curl -o "/var/www/$script" -L "${scripts[$script]}"
    chmod +x "/var/www/$script"
done

# Add NOPASSWD lines to sudoers file
bash -c "cat > /etc/sudoers.d/cosmosvpn" <<EOL
www-data ALL=(root) NOPASSWD: /var/www/returnConnectedClients.sh
www-data ALL=(root) NOPASSWD: /var/www/createClient.sh
www-data ALL=(root) NOPASSWD: /var/www/returnClientTemplate.sh
www-data ALL=(root) NOPASSWD: /var/www/deleteClient.sh
www-data ALL=(root) NOPASSWD: /var/www/setVPNPort.sh
www-data ALL=(root) NOPASSWD: /var/www/setVPNProtocol.sh
www-data ALL=(root) NOPASSWD: /var/www/setVPNDNS.sh
www-data ALL=(root) NOPASSWD: /var/www/toggleVPNStatus.sh
www-data ALL=(root) NOPASSWD: /var/www/removeVPN.sh
EOL
