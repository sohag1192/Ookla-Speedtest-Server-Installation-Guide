
# 🚀 Ookla Speedtest Server Installation Guide

[![Hits](https://hits.sh/github.com/sohag1192/Ookla-Speedtest-Server-Installation-Guide.svg?view=today-total)](https://hits.sh/github.com/sohag1192/Ookla-Speedtest-Server-Installation-Guide/)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20Linux-orange.svg)](https://ubuntu.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, step-by-step guide to preparing, installing, configuring, and maintaining an official Ookla Speedtest Server on an Ubuntu machine. 

---

## 📑 Table of Contents
- [Important Prerequisites](#important-prerequisites)
- [A. Prepare Ubuntu Server](#a-prepare-ubuntu-server)
- [B. Install Ookla Speedtest Server](#b-install-ookla-speedtest-server)
- [C. Configure & Test](#c-configure--test)
- [D. Submit for Review](#d-submit-for-review)
- [E. Enable Auto-Start on Boot](#e-enable-auto-start-on-boot)
- [References](#-references)

---

## ⚠️ Important Prerequisites
Before beginning the installation, ensure your setup meets the following criteria:

1. **Hardware Requirements**: Minimum Recommended Configuration is a Quad Core Processor, 8GB RAM, 256GB SSD, and a 1Gbps NIC. *(For large networks, invest in good hardware with 10G NICs).*
2. **Bandwidth**: Availability should be at least **500 Mbps+**. Anything lower might be rejected during Ookla's review process.
3. **Network Configuration**: The server **must** be dual-stacked. IPv6 is absolutely mandatory for an Ookla Speedtest Server.
4. **Domain Name**: Map a domain name with the IP address of the Speedtest Server for both **A** and **AAAA** records. 
   * *Example: `speedtest-[location-short-code].[your-organisation-name].com`*
5. **Geo-Location**: Before submitting the server for review, double-check that your IP addresses are correctly marked in the Maxmind Database for their precise Geo Location.

---

## A. Prepare Ubuntu Server

1. **Download Ubuntu**: Get the latest stable version of Ubuntu Server from [ubuntu.com/download/server](https://ubuntu.com/download/server). 
2. **Basic Setup**: Boot the system using the installation media, configure your IPv4 & IPv6 addresses, set up your partitions, and reboot the server.

---

## B. Install Ookla Speedtest Server

**1. Download the installation script:**
```bash
wget [https://install.speedtest.net/ooklaserver/ooklaserver.sh](https://install.speedtest.net/ooklaserver/ooklaserver.sh)

```

**2. Update script permissions:**

```bash
chmod a+x ooklaserver.sh

```

**3. Install the server daemon:**

```bash
./ooklaserver.sh install

```

**4. Verify the installation:**
Check if the Speedtest Server Daemon has automatically started by opening your browser and navigating to:

```text
http://<Your-Ookla-Speedtest-Server-IP>:8080

```

---

## C. Configure & Test

**1. Open the configuration file:**

```bash
sudo nano OoklaServer.properties

```

**2. Edit the necessary values:** Modify the file to include the following lines. *(To save in Nano: Press `Ctrl+O`, hit `Enter`, then exit with `Ctrl+X`)*

```properties
OoklaServer.useIPv6 = true
OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net
OoklaServer.enableAutoUpdate = true
OoklaServer.ssl.useLetsEncrypt = true

```

> **Note:** The SSL process (Let's Encrypt) will only successfully begin *after* the server has been registered and reviewed by Ookla.

**3. Restart the server service:**

```bash
sudo ./ooklaserver.sh restart

```

**4. Test your server:**
Go to the [Speedtest Host Tester](https://www.speedtest.net/host-tester). Enter your server's IP address or domain name followed by port `8080` (e.g., `speedtest.domain.com:8080` or `100.64.100.1:8080`) and click **Submit**.

> *If your configuration is correct, the test will pass, indicating your server is ready for submission. You may see HTTPS errors at this stage; this is normal until Ookla accepts the server.*

---

## D. Submit for Review

1. Create an account at [Ookla Account Login](https://account.ookla.com/login).
2. Navigate to [Ookla Servers](https://account.ookla.com/servers) and click **Add Server**.
3. Fill in the required details: Server domain name, processor, memory, bandwidth, Organization Name, Organization Website, Server City, State/Region, and Country. Click **Create**.
4. A new ticket will be generated. Once the Ookla team reviews and approves your server, it will be listed online!

---

## E. Enable Auto-Start on Boot

It is essential that the Speedtest Server Daemon automatically starts after a server reboot (e.g., power failure or maintenance). Since newer Ubuntu versions (like 22.04) do not come with `rc.local` enabled by default, follow these steps:

**1. Create the `rc.local` service file:**

```bash
sudo nano /etc/systemd/system/rc-local.service

```

**2. Add the following configuration:**

```ini
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

```

*(Save and exit Nano)*

**3. Create the `/etc/rc.local` file:**

```bash
printf '%s\n' '#!/bin/bash' 'exit 0' | sudo tee -a /etc/rc.local

```

**4. Add execute permissions:**

```bash
sudo chmod +x /etc/rc.local

```

**5. Enable the service on system boot:**

```bash
sudo systemctl enable rc-local

```

**6. Start the service and verify its status:**

```bash
sudo systemctl start rc-local.service
sudo systemctl status rc-local.service

```

**7. Edit the `/etc/rc.local` file:**

```bash
sudo nano /etc/rc.local

```

**8. Add the start command before `exit 0`:**

```bash
su root -c '/root/OoklaServer --daemon'

```

> **Note:** Change the username (`root`) and directory path (`/root/OoklaServer`) to match your actual installation details if you did not install it in the root directory.

**9. Final Verification:**
Reboot your server. Once it is back online, open a browser and go to `http://<Your-Ookla-Speedtest-Server-IP>:8080` to verify the daemon started automatically.

---

## 🔗 References

* [OoklaServer Installation for Linux/Unix](https://support.ookla.com/hc/en-us/articles/234578528-OoklaServer-Installation-Linux-Unix)
* [How to Enable HTTPS/TLS Support](https://support.ookla.com/hc/en-us/articles/360001087752-How-do-I-enable-HTTPS-TLS-support-)
* [Enable /etc/rc.local with Systemd](https://www.linuxbabe.com/linux-server/how-to-enable-etcrc-local-with-systemd)

---

*If you found this guide helpful, don't forget to ⭐ this repository!*

