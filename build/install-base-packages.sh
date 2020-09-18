#!/usr/bin/env bash
set -e

apt-get -q update
apt-get install -y apt-utils
apt-get install -y software-properties-common
apt-get -q update
apt-get upgrade -y
apt-get autoremove -y

apt-get install -y sudo
apt-get install -y locales
apt-get install -y build-essential
apt-get install -y net-tools
apt-get install -y wget
apt-get install -y curl
apt-get install -y apt-transport-https
apt-get install -y vim
apt-get install -y file
apt-get install -y gnupg
apt-get install -y bzip2
apt-get install -y python-numpy
apt-get install -y unzip
apt-get install -y jq
apt-get install -y git
