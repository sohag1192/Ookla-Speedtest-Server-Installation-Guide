#!/bin/bash
# Full Ookla Speedtest Server Setup Script
# Author: Md. Sohag Rana (adapted for automation)
# Tested on Ubuntu 20.04/22.04

set -e

# === Variables (edit these before running) ===
DOMAIN="speedtest.yourdomain.com"   # Replace with your domain
SERVER_IP="203.0.113.45"            # Replace with your public IPv4
EMAIL="admin@yourdomain.com"        # For Let's Encrypt SSL

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y wget curl nano systemctl ufw certbot

echo "Downloading Ookla Speedtest Server installer..."
wget https://install.speedtest.net/ooklaserver/ooklaserver.sh -O /root/ooklaserver.sh

echo "Setting permissions..."
chmod a+x /root/ooklaserver.sh

echo "Installing Ookla Speedtest Server daemon..."
/root/ooklaserver.sh install

echo "Configuring Ookla Speedtest Server..."
cat <<EOF | sudo tee /root/OoklaServer.properties
# === Ookla Speedtest Server Configuration ===
OoklaServer.domain = $DOMAIN
OoklaServer.ip = $SERVER_IP
OoklaServer.useIPv6 = true
OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net
OoklaServer.enableAutoUpdate = true
OoklaServer.ssl.useLetsEncrypt = true
OoklaServer.ssl.email = $EMAIL
EOF

echo "Restarting Ookla Speedtest Server..."
sudo /root/ooklaserver.sh restart

echo "Creating systemd service for auto-start..."
sudo tee /etc/systemd/system/ooklaserver.service > /dev/null <<EOL
[Unit]
Description=Ookla Speedtest Server
After=network.target

[Service]
ExecStart=/root/OoklaServer --daemon
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

echo "Enabling Ookla Speedtest Server service..."
sudo systemctl daemon-reload
sudo systemctl enable ooklaserver
sudo systemctl start ooklaserver

echo "Configuring firewall..."
sudo ufw allow 8080/tcp
sudo ufw allow 5060/tcp
sudo ufw allow 5060/udp
sudo ufw reload

echo "Installation complete!"
echo "Your Speedtest Server is running at: http://$DOMAIN:8080"
echo "Verify with: sudo /root/ooklaserver.sh status"
