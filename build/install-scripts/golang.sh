#!/usr/bin/env bash
set -e

echo "Install golang"
add-apt-repository ppa:longsleep/golang-backports
apt-get update
apt-get install -y golang-go