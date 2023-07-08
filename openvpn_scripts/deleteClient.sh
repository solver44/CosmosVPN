#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: <script> username"
    exit 1
fi

User="$1"

function removeConfig() {
    CLIENT=$1

    rm "/etc/openvpn/easy-rsa/pki/issued/$CLIENT.crt"
    rm "/etc/openvpn/easy-rsa/pki/private/$CLIENT.key"
    sed -i "/^$CLIENT:/d" /etc/openvpn/credentials.txt
#     echo "Client $CLIENT removed successfully."
    clear
    echo "Revocation was successful."
}

if [[ $(grep -c "^$User" /etc/passwd) -eq 0 ]]; then
    echo "User $User does not exist."
    exit
else
    userdel -r "$User"
    removeConfig "$User"
    exit 0
fi
