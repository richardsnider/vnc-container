#!/usr/bin/env bash
set -e

mkdir $HOME/.ssh
ssh-keygen -t rsa -b 4096 -q -N "" -C $GIT_EMAIL -f $HOME/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa