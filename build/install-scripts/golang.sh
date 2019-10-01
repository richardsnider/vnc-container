#!/usr/bin/env bash
set -e

add-apt-repository ppa:longsleep/golang-backports
apt-get -q update
apt-get install -y golang-go