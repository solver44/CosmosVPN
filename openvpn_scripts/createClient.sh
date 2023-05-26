#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: <script> username"
    exit 1
fi
User="$1"

function outputConfig() {
    CLIENT=$1
    PASSWORD=$2

    echo "$PASSWORD"
    echo "\n"
    cat /etc/openvpn/client-template.txt
    echo "<ca>"
    cat "/etc/openvpn/easy-rsa/pki/ca.crt"
    echo "</ca>"
    echo "<cert>"
    awk '/BEGIN/,/END/' "/etc/openvpn/easy-rsa/pki/issued/$CLIENT.crt"
    echo "</cert>"
    echo "<key>"
    cat "/etc/openvpn/easy-rsa/pki/private/$CLIENT.key"
    echo "</key>"
    echo "<tls-crypt>"
    cat /etc/openvpn/tls-crypt.key
    echo "</tls-crypt>"
}

if [[ $(grep -c "^$User" /etc/passwd) -ne 0 ]]; then
    clear
    echo "User already exists"
    PASSWORD=$(grep -E "^${User}:" /etc/openvpn/credentials.txt | cut -d: -f2)
    outputConfig "$User" "$PASSWORD"
    exit
else
    Pass=$(openssl rand -base64 16)
    Days=365

    # IP=$(wget -4qO- http://ipinfo.io/ip)
    Exp=$(date +%Y-%m-%d -d "$Days days")
    useradd -m -s /bin/false -e "$Exp" "$User" -p $(openssl passwd -1 "${Pass}") &>/dev/null
    # Date=$(chage -l "$User" | grep -i "account expires" | awk -F": " '{print $2}')

    # printf "\n"
    # printf " Account Created!\n\n"
    # printf "Host/IP   : %s \n" "$IP"
    # printf "Username  : %s \n" "$User"
    # printf "Password  : %s \n" "$Pass"
    # printf "Expires on: %s \n" "$Date"
    # printf "Ovpn config: \n"

    cd /etc/openvpn/easy-rsa/ || return
    echo yes | ./easyrsa build-client-full "$User" nopass >/dev/null

    clear
    outputConfig "$User" "$Pass"
    echo "${User}:${Pass}" >>/etc/openvpn/credentials.txt
    exit 0
fi
