#!/bin/bash

# Install necessary packages
apt-get update
apt-get install -y openvpn easy-rsa libpam0g-dev curl

# Set up EasyRSA
make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa
./easyrsa init-pki
echo "yes" | ./easyrsa build-ca nopass
./easyrsa build-server-full server nopass

# Set up OpenVPN server
cp pki/ca.crt pki/private/ca.key /etc/openvpn/
cp pki/issued/server.crt pki/private/server.key /etc/openvpn/
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/server.conf

# Update server.conf
sed -i 's|;tls-auth ta.key 0|tls-auth ta.key 0|' /etc/openvpn/server.conf
sed -i 's|;cipher AES-256-CBC|cipher AES-256-CBC|' /etc/openvpn/server.conf
sed -i 's|;user nobody|user nobody|' /etc/openvpn/server.conf
sed -i 's|;group nogroup|group nogroup|' /etc/openvpn/server.conf
sed -i '/plugin.*pam.so/d' /etc/openvpn/server.conf
echo '\nplugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so openvpn' >> /etc/openvpn/server.conf

# Generate tls-auth key
openvpn --genkey secret /etc/openvpn/ta.key

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Configure PAM authentication
echo 'auth required pam_unix_auth.so shadow nodelay' > /etc/pam.d/openvpn
echo 'account required pam_unix_acct.so' >> /etc/pam.d/openvpn

# Detect public IP address
SERVER_PUBLIC_IP=$(curl -s https://api.ipify.org)

# Create client configuration template
cat > /etc/openvpn/client-template.ovpn << EOL
client
dev tun
proto udp
remote $SERVER_PUBLIC_IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
mute-replay-warnings
cipher AES-256-CBC
auth-nocache
auth-user-pass
verb 3
<ca>
INSERT_CA_CERT_HERE
</ca>
key-direction 1
EOL

# Create client-config script
cat > /etc/openvpn/create-client-config.sh << 'EOL'
#!/bin/bash
client_name=$1
password=$2
cd /etc/openvpn/easy-rsa
./easyrsa build-client-full "$client_name" nopass
ca_content=$(cat pki/ca.crt)
client_crt=$(cat "pki/issued/$client_name.crt")
client_key=$(cat "pki/private/$client_name.key")
cp /etc/openvpn/client-template.ovpn "/etc/openvpn/ccd/$client_name.ovpn"
awk -v ca_content="$ca_content" '{gsub(/INSERT_CA_CERT_HERE/, ca_content)}1' "/etc/openvpn/ccd/$client_name.ovpn" > "/etc/openvpn/ccd/$client_name.tmp" && mv "/etc/openvpn/ccd/$client_name.tmp" "/etc/openvpn/ccd/$client_name.ovpn"
echo "<cert>" >> "/etc/openvpn/ccd/$client_name.ovpn"
echo "$client_crt" >> "/etc/openvpn/ccd/$client_name.ovpn"
echo "</cert>" >> "/etc/openvpn/ccd/$client_name.ovpn"
echo "<key>" >> "/etc/openvpn/ccd/$client_name.ovpn"
echo "$client_key" >> "/etc/openvpn/ccd/$client_name.ovpn"
echo "</key>" >> "/etc/openvpn/ccd/$client_name.ovpn"

# Save the client's password
echo "$client_name:$password" | sudo tee -a /etc/openvpn/client_passwords
EOL
chmod +x /etc/openvpn/create-client-config.sh

# Secure the password file
touch /etc/openvpn/client_passwords
chown root:root /etc/openvpn/client_passwords
chmod 600 /etc/openvpn/client_passwords

# Start OpenVPN server
systemctl enable openvpn@server
systemctl start openvpn@server