#!/bin/bash
# Ookla Speedtest Server Installation Script
# Tested on Ubuntu 20.04/22.04

set -e

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y wget nano systemctl

echo "Downloading Ookla Speedtest Server installer..."
wget https://install.speedtest.net/ooklaserver/ooklaserver.sh -O /root/ooklaserver.sh

echo "Setting permissions..."
chmod a+x /root/ooklaserver.sh

echo "Installing Ookla Speedtest Server daemon..."
/root/ooklaserver.sh install

echo "Configuring Ookla Speedtest Server..."
cat <<EOF | sudo tee /root/OoklaServer.properties
OoklaServer.useIPv6 = true
OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net
OoklaServer.enableAutoUpdate = true
OoklaServer.ssl.useLetsEncrypt = true
EOF

echo "Restarting Ookla Speedtest Server..."
sudo /root/ooklaserver.sh restart

echo "Creating rc.local service for auto-start..."
sudo tee /etc/systemd/system/rc-local.service > /dev/null <<EOL
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOL

echo "Creating /etc/rc.local file..."
sudo tee /etc/rc.local > /dev/null <<EOL
#!/bin/bash
su root -c '/root/OoklaServer --daemon'
exit 0
EOL

echo "Setting execute permissions..."
sudo chmod +x /etc/rc.local

echo "Enabling rc.local service..."
sudo systemctl enable rc-local
sudo systemctl start rc-local.service

echo "Installation complete!"
echo "Check server status at: http://<your-server-ip>:8080"
