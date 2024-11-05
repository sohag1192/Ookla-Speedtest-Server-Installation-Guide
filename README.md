# Ookla-Speedtest-Server-Installation-Guide
Ookla Speedtest Server Installation Guide


Important points to keep in mind before installation of Ookla Speedtest Server –
Minimum Recommended Server Configuration – Quad Core Processor, 8GB RAM, 256 GB SSD, 1GIG NIC. If you have a large network, invest in a good hardware with 10G NICs.
Bandwidth Availability should be high enough else server shall be rejected during review. Recommended is 500 mbps +
Server should be dual stacked. IPv6 is mandatory for Ookla Speedtest Server.
A domain name should be mapped with the IP address of the Speedtest Server for both A & AAAA Record. Example- speedtest-[location-short-code].[your-organisation-name].com
Before submitting the server for review, double check your IP Addresses are correctly marked in Maxmind Database for their Geo Location. I will write a seperate post on it.
For monitoring of the Speedtest server you can use PRTG.
A. How to prepare Ubuntu Server for Ookla Speedtest Server ?
Download the latest stable version of Ubuntu Server from https://ubuntu.com/download/server. For this guide I will use Ubuntu Server 22.04.03 LTS
Using the installation media boot the system, configure IPv4 & IPv6 Address, partitions and reboot the server.
B. How to install Ookla Speedtest Server ?
Download the install script
wget https://install.speedtest.net/ooklaserver/ooklaserver.sh
Update script permissions to allow installation
chmod a+x ooklaserver.sh
Install the server daemon

./ooklaserver.sh install
Now, check if the Speedtest Server Daemon has automatically started by opening http://Ookla-Speedtest-Server-IP:8080
C. How to edit Ookla Speedtest Server configuration files and test?
Open the Speedtest Server configuration file
sudo nano OoklaServer.properties
Edit the following values. To save a file in Nano text editor, press Ctrl+O, then press Enter to confirm. To exit the file, Press Ctrl+X
OoklaServer.useIPv6 = true
OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net
OoklaServer.enableAutoUpdate = true
OoklaServer.ssl.useLetsEncrypt = true
Note: The above process (SSL) only begins after the server has been registered and reviewed by Ookla

Restart the Speedtest Server service
sudo ./ooklaserver.sh restart
Now, test the server using Speedtest Server Tester – https://www.speedtest.net/host-tester
Enter the IP Address of your server or domain name followed by port 8080. Example: speedtest.domain.com:8080 or 100.64.100.1:8080. Click on Submit.
If your configuration is correct, west will pass and your server is ready for submission to Ookla. You may see errors on HTTPS part as this is enabled after server is accepted by Ookla.
D. How to submit Ookla Speedtest Server for review?
Create an account at https://account.ookla.com/login
Then  from https://account.ookla.com/servers Click Add Server
Enter server domain name, processor, memory, bandwidth (Recommended >1Gbps), Organization Name, Organization Website, Server City, Server State/Region, Server Country. Then click Create.
A new ticket will be created and once the server is reviewed by Ookla team, it will be listed online.
E. How to enable auto-start of Ookla Speedtest Server ?
It is very essential for the Speedtest Server Daemon to start automatically after the server is rebooted for any reason either power issue or maintainance. For older versions of Ubuntu we could easily do it by the rc.local file but for new versions like Ubuntu Server 22.04 we need to manually create the service first and then configure auto start of Speedtest Server. Follow the instructions below and complete the process smoothly:

Create the rc.local service file-
sudo nano /etc/systemd/system/rc-local.service
Then add the following content to it & Save and close the file. To save a file in Nano text editor, press Ctrl+O, then press Enter to confirm. To exit the file, Press Ctrl+X.
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
Next, we have to create the /etc/rc.local file as newer versions of Ubuntu doesn’t come with it
printf '%s\n' '#!/bin/bash' 'exit 0' | sudo tee -a /etc/rc.local
Then add execute permission to /etc/rc.local file.
sudo chmod +x /etc/rc.local
After that, enable the service on system boot:
sudo systemctl enable rc-local
Now start the service and check its status:
sudo systemctl start rc-local.service
sudo systemctl status rc-local.service
Next, we have to edit the rc.local file
sudo nano /etc/rc.local
Then add the Ookla Speedtest Server Script for auto start. To save a file in Nano text editor, press Ctrl+O, then press Enter to confirm. To exit the file, Press Ctrl+X
su srijit -c '/home/srijit/OoklaServer --daemon'
Note: change the username and directory path based on your actual instalalation details

Now, reboot the server and check if the Speedtest Server Daemon has automatically started by opening http://Ookla-Speedtest-Server-IP:8080. 
YouTube Video Link – https://youtu.be/s7PEGZ7uEQ0

Reference Links:
1) https://support.ookla.com/hc/en-us/articles/234578528-OoklaServer-Installation-Linux-Unix

2) https://support.ookla.com/hc/en-us/articles/360001087752-How-do-I-enable-HTTPS-TLS-support-

3) https://www.linuxbabe.com/linux-server/how-to-enable-etcrc-local-with-systemd
