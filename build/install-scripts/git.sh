#!/usr/bin/env bash
set -e

echo "Install git"
apt-get -y install git

mkdir $HOME/.ssh
# generate an rsa 4k key silently, wiht no ("") password and save as id_rsa in .ssh directory
ssh-keygen -t rsa -b 4096 -q -N "" -f $HOME/.ssh/id_rsa
