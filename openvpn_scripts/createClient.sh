#!/bin/bash

_ask_user ()
{
	printf "\nCREATE USER\n\n"
	read -p "Username : " User
}
_ask_pass ()
{
	read -p "Password (leave blank for random): " Pass
	[[ -z $Pass ]] && Pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8)
}
_ask_days ()
{
	read -p "How many days : " Days
}


clear
_ask_user
if [[ $(grep -c "^$User" /etc/passwd) -ne 0 ]]; then
	clear
	printf "\nUsername already taken" && sleep 2 && printf "\nUsername already taken\r\e[K"
	user_create
else
	_ask_pass
	_ask_days

	IP=$(wget -4qO- http://ipinfo.io/ip)
	Exp=$(date +%Y-%m-%d -d "$Days days")
	useradd -m -s /bin/false -e "$Exp" "$User" -p $(openssl passwd -1 "${Pass}") &> /dev/null
	Date=$(chage -l "$User" | grep -i "account expires" | awk -F": " '{print $2}')

	printf "\n"
	printf " Account Created!\n\n"
	printf "Host/IP   : %s \n" "$IP"
	printf "Username  : %s \n" "$User"
	printf "Password  : %s \n" "$Pass"
	printf "Expires on: %s \n" "$Date"
	printf "Ovpn config download link: http://%s:88\n" "$IP"	
	return
fi