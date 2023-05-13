# CosmosVPN

First, get the script and make it executable:
```
curl -O https://raw.githubusercontent.com/solver44/cosmosvpn/master/openvpn-install.sh
chmod +x openvpn-install.sh
```
```
AUTO_INSTALL=y ./openvpn-install.sh

# or

export AUTO_INSTALL=y
./openvpn-install.sh
```

Install LAMP
```
sudo apt update
sudo apt install apache2 apache2-utils
sudo systemctl status apache2
sudo systemctl start apache2
sudo systemctl enable apache2
```
NOTE: If you have UFW firewall running, allow port 80 which is the HTTP port that Apache listens to as shown.
```
sudo ufw allow 80/tcp
sudo ufw reload
```
```
sudo apt install mariadb-server mariadb-client
sudo systemctl status mariadb

sudo systemctl start mariadb
sudo systemctl enable mariadb

# The default settings for MariaDB, just like MySQL, are weak and an attacker or anonymous user can easily gain access without authentication.
# Therefore, we need to harden our Database instance.
sudo mysql_secure_installation

#PHP 7.3
sudo apt install php7.3 libapache2-mod-php7.3 php7.3-mysql php-common php7.3-cli
php7.3-common php7.3-json php7.3-opcache php7.3-readline
sudo a2enmod php7.3
sudo systemctl restart apache2

sudo a2dismod php7.3
sudo apt install php7.3-fpm
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.3-fpm
sudo systemctl restart apache2
```
