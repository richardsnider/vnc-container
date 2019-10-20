#!/usr/bin/env bash
set -e

add-apt-repository ppa:hluk/copyq
apt-get update
apt-get install copyq -y