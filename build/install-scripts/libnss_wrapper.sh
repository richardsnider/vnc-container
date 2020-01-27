#!/usr/bin/env bash
set -e

echo "Install nss-wrapper to be able to execute image as non-root user"
apt-get install -y libnss-wrapper gettext