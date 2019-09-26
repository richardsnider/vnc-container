#!/usr/bin/env bash
set -e

echo "Install some common tools for further installation"
apt-get update
apt-get install -y software-properties-common
apt-get update

apt-get install -y vim wget net-tools locales curl gnupg bzip2 \
    python-numpy #used for websockify/novnc
apt-get clean -y

echo "Generate locales for en_US.UTF-8"
locale-gen en_US.UTF-8

echo "Install nodejs"
# https://github.com/nodesource/distributions/blob/master/README.md#debinstall

curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs

npm install
npm start
