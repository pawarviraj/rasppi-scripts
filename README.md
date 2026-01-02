# Raspberry Pi Zero 2 W 64‑bit Setup Script

Lightweight first‑boot script for **Raspberry Pi Zero 2 W** (64‑bit Raspberry Pi OS Lite). Installs **zram** (RAM swap), **Docker**, and **Portainer Agent** to join your RP5 Portainer cluster. Optimized for 512 MB RAM, ready for AdGuard Home/DNS node.

[![GitHub stars](https://img.shields.io/github/stars/pawarviraj/rasppi-scripts)](https://github.com/pawarviraj/rasppi-scripts)

## Features
- ✅ **zram‑swap**: 256 MB compressed swap (lz4, ~128 MB RAM use)
- ✅ **Docker Engine**: Latest 28.x (64‑bit compatible)
- ✅ **Portainer Agent**: Edge mode, 64 MB RAM cap
- ✅ **Static IP**: systemd‑networkd (customizable)
- ✅ **SSH ready**: Minimal bloat (~150 MB idle RAM)

## Prerequisites
- **64‑bit Raspberry Pi OS Lite** (flash with Raspberry Pi Imager, enable SSH)
- SD card ≥16 GB
- Ethernet cable or Wi‑Fi (script sets eth0; adapt for wlan0)

## One‑command install (from fresh boot)

```bash
curl -fsSL https://raw.githubusercontent.com/pawarviraj/rasppi-scripts/main/zero2w_setup.sh | sudo bash
