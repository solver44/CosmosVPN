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
