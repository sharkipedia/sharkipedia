#!/usr/bin/env bash
# Base setup for the Sharkipedia server (Ubuntu 26.04, Hetzner Cloud).
# Safe to re-run. Usage: ssh root@HOST 'bash -s' < config/server/setup.sh
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# SSH: keys only. Root stays allowed (Kamal deploys as root) but without passwords.
cat > /etc/ssh/sshd_config.d/10-hardening.conf <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin prohibit-password
EOF
# cloud-init's drop-in turns passwords back on; it sorts after ours, so remove it.
rm -f /etc/ssh/sshd_config.d/50-cloud-init.conf
sshd -t
systemctl reload ssh

# Packages
apt-get update -q
apt-get -y -q full-upgrade
apt-get -y -q install docker.io docker-buildx unattended-upgrades ufw curl
apt-get -y -q autoremove

# Automatic security updates, reboot at 04:00 when a kernel update needs it.
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
cat > /etc/apt/apt.conf.d/52sharkipedia-upgrades <<'EOF'
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
EOF

# Swap (2 GB) as a cushion for memory spikes.
if [ ! -f /swapfile ]; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi
swapon -a
echo "vm.swappiness=10" > /etc/sysctl.d/90-swappiness.conf
sysctl -q --system

# Docker: cap container logs so they can't fill the disk.
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<'EOF'
{
  "log-driver": "json-file",
  "log-opts": {"max-size": "20m", "max-file": "5"}
}
EOF
systemctl enable docker
systemctl restart docker

# Firewall: only SSH in. Web traffic arrives through the Cloudflare Tunnel
# (outbound), so nothing else needs to be open. Docker-published ports bypass
# ufw, so containers must not publish ports to the host.
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw --force enable

timedatectl set-timezone UTC

echo "Setup done."
