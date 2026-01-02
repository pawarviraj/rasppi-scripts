#!/bin/bash

# Customize these vars
STATIC_IP="192.168.1.100/24"     # e.g., Zero 2 W IP
GATEWAY="192.168.1.1"           # Router/gateway
EDGE_ID="zero2w"                # Unique Portainer Edge ID
ZR_SIZE="256M"                  # zram size (uncompressed)

set -e  # Exit on error

echo "=== Zero 2 W 64‑bit Setup: zram + Docker + Portainer Agent ==="

# 1. System update + essentials
apt update && apt upgrade -y
apt install -y ca-certificates curl gnupg lsb-release git htop

# 2. Static IP (eth0; adjust for wlan0)
cat > /etc/systemd/network/20-wired.network << EOF
[Match]
Name=eth0

[Network]
Address=$STATIC_IP
Gateway=$GATEWAY
DNS=127.0.0.1  # Local resolver prep
EOF
systemctl enable --now systemd-networkd systemd-resolved
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# 3. zram‑swap (lz4, fixed size)
git clone https://github.com/foundObjects/zram-swap.git /tmp/zram-swap
cd /tmp/zram-swap
sed -i "s/_zram_fixedsize=.*/_zram_fixedsize=\"$ZR_SIZE\"/" /etc/default/zram-swap
./install.sh
cd / && rm -rf /tmp/zram-swap
echo "zram: $(zramctl)"  # Verify

# 4. Docker (64‑bit repo, latest 28.x)
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
usermod -aG docker pi

# 5. Portainer Agent (Edge mode, low‑RAM)
docker volume create portainer_agent
docker run -d \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes/portainer_agent/_data \
  -v /:/host \
  --memory=64m \
  -e EDGE=1 -e EDGE_ID=$EDGE_ID \
  portainer/agent:latest

# 6. Reboot prompt + summary
cat << EOF

SUCCESS! Rebooting in 10s...

After reboot:
- IP: $STATIC_IP
- Docker: docker run hello-world
- zram: zramctl + free -h
- Connect in Portainer (RP5): Environments > Add > Agent > IP:zero2w

EOF

sleep 10 && reboot
