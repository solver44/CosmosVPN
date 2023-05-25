#!/bin/bash

function createConfig() {
  # Set the API key from the input argument
  API_KEY="$1"

  # Create the config.php content
  CONFIG_PHP="<?php \$apiKey='${API_KEY}'; ?>"

  # Write the content to the config.php file
  echo -e "${CONFIG_PHP}" >/var/www/html/config.php

  # Set the appropriate permissions
  chown www-data:www-data /var/www/html/config.php
  chmod 640 /var/www/html/config.php

  echo "config.php has been created and configured with the provided API key."
}

# Check if the input argument is provided
if [ -z "$1" ]; then
  echo "Usage: ./install_all.sh API_KEY"
  exit 1
fi

# Download and install OpenVPN
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/openvpn-install.sh
chmod +x openvpn-install.sh
AUTO_INSTALL=y ./openvpn-install.sh

# Download and install LAMP
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/lamp.sh
chmod +x lamp.sh
./lamp.sh

# Download web files
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/web_dir/api.php
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/web_dir/functions.php

# Move web files to /var/www/html/
mv api.php functions.php /var/www/html/

createConfig "$1"

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

# Download and install install_dir.sh
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/install_dir.sh
chmod +x install_dir.sh
./install_dir.sh

sudo touch /etc/openvpn/credentials.txt
sudo chmod 600 /etc/openvpn/credentials.txt

# sudo apt-get install expect -y

echo "Successfully installed!"
