#!/usr/bin/env bash
set -e

echo "Install python"

# Install python and pip
apt-get install -y python3 python3-pip

# Install virtualenv
pip3 install virtualenv

# Setup virtualenv
virtualenv $HOME/venv
source $HOME/venv/bin/activate

#Install AWS tools
pip install awscli
pip install aws-mfa
