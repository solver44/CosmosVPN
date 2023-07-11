#!/usr/bin/bash
# Extract data from status.log
sed -n '/Connected Since/,/ROUTING TABLE/{/Connected Since/b;/ROUTING TABLE/b;p}' /var/log/openvpn/status.log
# Extract data from status_udp.log
sed -n '/Connected Since/,/ROUTING TABLE/{/Connected Since/b;/ROUTING TABLE/b;p}' /var/log/openvpn/status_udp.log
# Extract data from status_tcp.log
sed -n '/Connected Since/,/ROUTING TABLE/{/Connected Since/b;/ROUTING TABLE/b;p}' /var/log/openvpn/status_tcp.log
