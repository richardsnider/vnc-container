#!/usr/bin/env bash
set -e

echo "Install VS Code"
# https://code.visualstudio.com/docs/setup/linux

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

apt-get install -y apt-transport-https
apt-get update -y
apt-get install -y code

rm ~/microsoft.gpg
