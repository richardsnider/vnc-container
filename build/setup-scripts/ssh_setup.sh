#!/usr/bin/env bash
set -e

mkdir $HOME/.ssh
ssh-keygen -t rsa -b 4096 -q -N "" -C $GIT_EMAIL -f $HOME/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo "Host github.com" >> ~/.ssh/config
echo "User git" >> ~/.ssh/config
echo "Hostname github.com" >> ~/.ssh/config
echo "PreferredAuthentications publickey" >> ~/.ssh/config
echo "IdentityFile $HOME/.ssh/id_rsa" >> ~/.ssh/config

chmod 400 ~/.ssh

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# so this works . . . . .
# ssh -i ~/.ssh/id_rsa -Tv git@github.com