# 📡 Ookla Speedtest Server Installation Guide ![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fsohag1192%2FOokla-Speedtest-Server-Installation-Guide%2F&label=Hit&icon=github&color=%23198754&message=&style=flat&tz=UTC)

A complete step‑by‑step guide to installing and configuring an **Ookla Speedtest Server** on Ubuntu.

---

## ⚙️ Prerequisites

1. **Minimum Recommended Server Configuration**
   - Quad Core Processor  
   - 8 GB RAM  
   - 256 GB SSD  
   - 1 Gbps NIC (10G NICs recommended for large networks)

2. **Bandwidth Availability**
   - Minimum: 500 Mbps+ (else server may be rejected during review)

3. **IPv6 Requirement**
   - Server must be dual‑stacked (IPv4 + IPv6)

4. **Domain Setup**
   - Map domain name with both A & AAAA records  
   - Example: `speedtest-[location].[org].com`

5. **Geo Location**
   - Ensure IP addresses are correctly marked in MaxMind Database

---

## 🖥️ A. Preparing Ubuntu Server

1. Download the latest stable Ubuntu Server: [ubuntu.com/download/server](https://ubuntu.com/download/server)  
2. Install and configure IPv4 & IPv6 addresses, partitions, then reboot.

---

## 🚀 B. Installing Ookla Speedtest Server

```bash
wget https://install.speedtest.net/ooklaserver/ooklaserver.sh
chmod a+x ooklaserver.sh
./ooklaserver.sh install
```

- Verify daemon startup:  
  `http://<server-ip>:8080`

---

## 🛠️ C. Configuring the Server

Edit configuration file:

```bash
sudo nano OoklaServer.properties
```

Recommended values:

```
OoklaServer.useIPv6 = true
OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net
OoklaServer.enableAutoUpdate = true
OoklaServer.ssl.useLetsEncrypt = true
```

Restart service:

```bash
sudo ./ooklaserver.sh restart
```

Test using [Speedtest Host Tester](https://www.speedtest.net/host-tester).

---

## 📤 D. Submitting Server for Review

1. Create account: [account.ookla.com/login](https://account.ookla.com/login)  
2. Add server details (domain, specs, bandwidth, organization info).  
3. Submit → Ticket created → Reviewed by Ookla → Listed online.

---

## 🔄 E. Enabling Auto‑Start

For Ubuntu 22.04+:

1. Create service file: `/etc/systemd/system/rc-local.service`  
2. Add rc.local script with daemon start command:  

```bash
su root -c '/root/OoklaServer --daemon'
```

3. Enable and start service:

```bash
sudo systemctl enable rc-local
sudo systemctl start rc-local.service
```

4. Reboot and verify daemon auto‑starts:  
   `http://<server-ip>:8080`

---

## 📚 References

- [Ookla Server Installation (Linux/Unix)](https://support.ookla.com/hc/en-us/articles/234578528-OoklaServer-Installation-Linux-Unix)  
- [Enable HTTPS/TLS Support](https://support.ookla.com/hc/en-us/articles/360001087752-How-do-I-enable-HTTPS-TLS-support-)  
- [Enable rc.local with systemd](https://www.linuxbabe.com/linux-server/how-to-enable-etcrc-local-with-systemd)  


