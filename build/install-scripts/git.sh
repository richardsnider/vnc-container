#!/usr/bin/env bash
set -e

apt-get -y install git

# Silently generate an rsa 4k key with no password and save as id_rsa in .ssh directory
mkdir $HOME/.ssh
ssh-keygen -t rsa -b 4096 -q -N "" -f $HOME/.ssh/id_rsa
