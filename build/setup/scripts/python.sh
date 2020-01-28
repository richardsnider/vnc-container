#!/usr/bin/env bash
set -e

# Install python and pip
apt-get install -y python3 python3-pip

#Install AWS tools
pip3 install awscli
pip3 install aws-mfa

# Install virtualenv
pip3 install virtualenv

# Setup virtualenv
virtualenv $HOME/venv
