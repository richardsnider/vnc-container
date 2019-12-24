#!/usr/bin/env bash
set -e

echo "Installing nodejs as directed by https://github.com/nodesource/distributions/blob/master/README.md#debinstall"
curl --silent https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
