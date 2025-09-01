#!/bin/bash

# Debian 8GB/1Core/512MB - (999-template) setup script - pve-macro  {999}

#> systemctl mask ssh.socket && systemctl mask sshd.socket && systemctl disable sshd && systemctl enable ssh && sed -i '15i\Port 4792\n' /etc/ssh/sshd_config
#> apt-get update -y && apt-get install git curl gnupg -y && apt-get full-upgrade -y && apt-get autoremove -y && reboot
#> cd /opt && cd /opt && git clone https://github.com/cityplug/macro-pve && cd macro-pve && mv /opt/macro-pve/### /appdata/###
#> chmod +x /appdata/###/* && cd /appdata/### && ./run.sh

# --- Install Docker Official GPG key to Apt sources:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

# --- Addons (MOTD)
rm -rf /etc/update-motd.d/* && rm -rf /etc/motd
wget https://raw.githubusercontent.com/cityplug/macro-pve/refs/heads/main/10-uname -O /etc/update-motd.d/10-uname
chmod +x /etc/update-motd.d/10-uname

#--
systemctl enable docker
docker --version && docker-compose --version

# App deployment (adjust path if needed)
cd /appdata/### && docker-compose up -d && docker ps
docker-compose logs --tail=50

#--------------------------------------------------------------------------------
sleep 10
reboot
