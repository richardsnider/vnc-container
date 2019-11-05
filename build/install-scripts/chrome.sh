#!/usr/bin/env bash
set -e

apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
apt-get clean -y
ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
echo "CHROMIUM_FLAGS='--start-maximized --user-data-dir'" > $HOME/.chromium-browser.init
