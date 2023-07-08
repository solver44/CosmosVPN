# Download and install install_dir.sh
curl -O https://raw.githubusercontent.com/solver44/CosmosVPN/main/install_dir.sh
chmod +x install_dir.sh
./install_dir.sh

sudo touch /etc/openvpn/credentials.txt
sudo chmod 600 /etc/openvpn/credentials.txt

rm -r ./*
echo "Successfully installed!"