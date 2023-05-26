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
  echo "Usage: ./install_2.sh API_KEY"
  exit 1
fi

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

echo -e "\nLAMP installed and created Config with API key!"