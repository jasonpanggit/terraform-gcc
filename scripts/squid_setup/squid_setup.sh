sudo apt-get update -y
sudo apt-get install squid iptables -y
sudo systemctl enable squid
# config iptables to redirect incoming tcp traffic at port 80 to proxy port 3128
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128
# config iptables to redirect incoming tcp traffic at port 443 to proxy port 3128
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 3128
sudo systemctl restart squid