# Home Lab Documentation

> Self-hosted infrastructure running on Raspberry Pi devices

## 🏗️ Overview

Personal home lab setup focused on photo backup, home automation, network-level ad blocking, and self-hosting services.

**Last Updated:** January 5, 2026

---

## 🖥️ Hardware Inventory

### Primary Server - Raspberry Pi 5
- **Model:** Raspberry Pi 5
- **OS:** [Specify your OS - e.g., Raspberry Pi OS 64-bit / Ubuntu Server]
- **Storage HAT:** Radxa Penta SATA HAT
- **System Drives:** 2x 256GB SSD
  - SSD 1: Active OS drive
  - SSD 2: Planned for RAID 1 mirroring
- **Data Storage Array:**
  - 1x 1TB HDD
  - 2x 500GB HDD
  - 1x 1TB SSD
  - **Configuration:** RAID 6 (~1.5TB usable capacity)
  - **Protection:** Dual drive failure tolerance

### Secondary Server - Raspberry Pi Zero W
- **Model:** Raspberry Pi Zero W (Single-core 1GHz, 512MB RAM)
- **OS:** [Specify your OS]
- **Purpose:** DNS and ad-blocking server
- **Network:** WiFi only

---

## 🌐 Network Architecture
Internet
↓
Airtel Router (WiFi OFF, passthrough mode)
↓
TP-Link Router (DHCP/DNS management)
↓
├─→ Raspberry Pi 5 (Main services)
├─→ Raspberry Pi Zero W (DNS/AdGuard)
└─→ Client Devices (3-4 regular devices)


### Network Details
- **ISP:** Airtel Broadband
- **Primary Router:** Airtel ISP Router (WiFi disabled, limited functionality)
- **Secondary Router:** TP-Link Router
  - Manages DHCP settings
  - Points DNS to Pi Zero W for ad-blocking
  - Handles all WiFi connections

---

## 📦 Services & Applications

### Raspberry Pi 5 Services

| Service | Purpose | Access | Port(s) |
|---------|---------|--------|---------|
| **Docker** | Container runtime | CLI | - |
| **Portainer** | Docker management UI | Web | 9000, 9443 |
| **Nginx Reverse Proxy** | SSL termination & routing | Web | 80, 443 |
| **Immich** | Photo/video backup | Web via Nginx | [Port] |
| **Home Assistant** | Home automation hub | Web | 8123 |

#### Home Assistant Integrations (Planned)
- Amazon Echo Dot
- Smart TV
- Air Conditioner
- LED Smart Bulbs

### Raspberry Pi Zero W Services

| Service | Purpose | Access | Port(s) |
|---------|---------|--------|---------|
| **Docker** | Container runtime | CLI | - |
| **Portainer Agent** | Remote management | Agent | 9001 |
| **AdGuard Home** | DNS + Ad blocking | Web | 53, 3000, 80 |

---

## 🚀 Setup Notes

### RAID 6 Configuration
- Minimum 4 drives required
- Provides fault tolerance for 2 simultaneous drive failures
- Usable capacity: ~1.5TB from 3TB total raw storage

### Portainer Multi-Instance Setup
- **Main Instance:** Running on Raspberry Pi 5
- **Agent:** Installed on Raspberry Pi Zero W
- **Management:** Single UI controls both environments

### DNS Flow
1. Devices connect to TP-Link router
2. Router DHCP assigns Pi Zero W as DNS server
3. AdGuard Home filters queries and blocks ads
4. Clean DNS responses return to devices

---
