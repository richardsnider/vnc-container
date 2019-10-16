#!/usr/bin/env bash
set -e

mkdir $HOME/.ssh
ssh-keygen -t rsa -b 4096 -q -N "" -C $GIT_EMAIL -f $HOME/.ssh/id_rsa
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

echo "Host github.com" >> $HOME/.ssh/config
echo "User git" >> $HOME/.ssh/config
echo "Hostname github.com" >> $HOME/.ssh/config
echo "PreferredAuthentications publickey" >> $HOME/.ssh/config
echo "IdentityFile $HOME/.ssh/id_rsa" >> $HOME/.ssh/config

eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_rsa

chmod 700 $HOME/.ssh