# Home Lab Setup Guide

Complete step-by-step instructions for deploying and configuring all services.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Network Configuration](#network-configuration)
3. [Raspberry Pi 5 Setup](#raspberry-pi-5-setup)
4. [Raspberry Pi Zero W Setup](#raspberry-pi-zero-w-setup)
5. [Service Configuration](#service-configuration)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software
- Raspberry Pi OS 64-bit (or Ubuntu Server) on both devices
- Docker Engine 20.10+
- Docker Compose v2.0+

### Install Docker on Both Devices

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin -y

# Verify installation
docker --version
docker compose version
```

### Network Planning
### Before starting, assign static IP addresses:
- Raspberry Pi 5: 192.168.1.X (choose a fixed IP)
- Raspberry Pi Zero W: 192.168.1.Y (choose a fixed IP)
- TP-Link Router: Configure in router settings

### Network Configuration
##### ``` Note: Some ISP routers don't allow DHCP modifications. If you have similar issue follow the Step 1 and 2 other wise just go with Setp 2 considering your Primary router ```
#### Step 1: Configure Airtel Router
1. Login to Airtel router admin panel
2. Disable WiFi radio
3. Set to bridge/passthrough mode (if available)

#### Step 2: Configure TP-Link Router
1. Connect TP-Link router to Airtel router WAN port
2. Login to TP-Link admin panel (192.168.1.1 or similar)
3. Navigate to DHCP settings
4. Reserve static IPs for both Raspberry Pis
5. After AdGuard setup: Set primary DNS to Pi Zero W IP
6. Save and reboot router

### Raspberry Pi 5 Setup
#### Step 1: RAID 6 Configuration
```
# Install mdadm
sudo apt install mdadm -y

# Identify drives
lsblk

### Step 1: RAID 6 Configuration
# Create RAID 6 array (replace sdX with your drives)
sudo mdadm --create --verbose /dev/md0 --level=6 --raid-devices=4 \
  /dev/sda /dev/sdb /dev/sdc /dev/sdd

# Format the array
sudo mkfs.ext4 /dev/md0

# Create mount point
sudo mkdir -p /mnt/raid6

# Mount the array
sudo mount /dev/md0 /mnt/raid6

# Auto-mount on boot
echo '/dev/md0 /mnt/raid6 ext4 defaults 0 0' | sudo tee -a /etc/fstab

# Save RAID configuration
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

#### Step 2: OS Drive Mirroring (Optional - Future)
```
# To be configured later
# Will use mdadm RAID 1 for two 256GB SSDs
```

#### Step 3: Deploy Services
```
# Create directory structure
mkdir -p ~/homelab/docker-compose
cd ~/homelab

# Clone your repository
git clone https://github.com/[your-username]/homelab.git
cd homelab/docker-compose
```
##### Deploy Portainer
```
docker compose -f pi5-portainer.yml up -d
```

- Access: http://<pi5-ip>:9000
- Create admin account on first login
- Set strong password





