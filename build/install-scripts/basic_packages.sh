#!/usr/bin/env bash
set -e

apt-get install -y vim wget net-tools locales build-essential curl file gnupg bzip2 \
    python-numpy #used for websockify/novnc
apt-get clean -y

echo "Generate locales for en_US.UTF-8"
locale-gen en_US.UTF-8