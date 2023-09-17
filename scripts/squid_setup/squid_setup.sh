#!/bin/bash

sudo apt-get update && apt-get upgrade -y

# install iptables and squid
sudo apt-get install -y iptables squid

sudo systemctl enable squid

# enable ip forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# config iptables to redirect incoming tcp traffic at port 80 to proxy port 3128
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128

# config iptables to redirect incoming tcp traffic at port 443 to proxy port 3128
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 3129

# backup squid.conf
sudo mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

# allow all traffic in squid with default settings
echo | sudo tee /etc/squid/squid.conf << EOF
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
acl all src 0.0.0.0/0
http_access allow all
http_access deny all
http_port 3128
http_port 3129
coredump_dir /var/spool/squid
refresh_pattern ^ftp:                           1440    20%     10080
refresh_pattern ^gopher:                        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?)               0       0%      0
refresh_pattern (Release|Packages(.gz)*)$       0       20%     2880
refresh_pattern .                               0       20%     4320
EOF

# restart squid
sudo systemctl restart squid