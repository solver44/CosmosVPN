#!/bin/bash

# Set your MySQL root password
MYSQL_ROOT_PASSWORD="cosmos@123"

# Update packages and upgrade the system
apt update && apt upgrade -y

# Install Apache, MySQL, and PHP
DEBIAN_FRONTEND=noninteractive apt install -y apache2 default-mysql-server php libapache2-mod-php php-mysql

# Enable the Apache service to start at boot and start the service
systemctl enable apache2
systemctl start apache2

# Set the MySQL root password
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# Secure MySQL installation
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "DELETE FROM mysql.user WHERE User='';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS test;"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Create a PHP info file to test the LAMP stack
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Restart Apache to make sure all components are working together
systemctl restart apache2

# Disable firewall blocks
ufw allow 80/tcp
ufw allow 1196/udp
ufw allow 1194/tcp
ufw reload

echo "Installation complete. Visit http://your_server_ip/info.php to test your LAMP stack."
