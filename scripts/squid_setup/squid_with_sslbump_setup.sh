#!/bin/bash

# Reference: https://docs.diladele.com/howtos/build_squid_on_ubuntu_20/update.html

# add diladele apt key
sudo wget -qO - https://packages.diladele.com/diladele_pub.asc | sudo apt-key add -

# add new repo
sudo echo "deb https://squid57.diladele.com/ubuntu/ focal main" \
    > /etc/apt/sources.list.d/squid57.diladele.com.list

# and install
sudo apt-get update && apt-get install -y \
    squid-common \
    squid-openssl \
    squidclient \
    libecap3 libecap3-dev

# change the number of default file descriptors
OVERRIDE_DIR=/etc/systemd/system/squid.service.d
OVERRIDE_CNF=$OVERRIDE_DIR/override.conf

sudo mkdir -p $OVERRIDE_DIR

# generate the override file
sudo rm $OVERRIDE_CNF
echo "[Service]"         >> $OVERRIDE_CNF
echo "LimitNOFILE=65535" >> $OVERRIDE_CNF

# and reload the systemd
sudo systemctl daemon-reload