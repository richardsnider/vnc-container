#!/usr/bin/env bash
set -e

add-apt-repository ppa:hluk/copyq
apt-get -q update
apt-get install copyq -y