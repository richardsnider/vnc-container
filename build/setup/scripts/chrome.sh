#!/usr/bin/env bash
set -e

apt-get install -y fonts-liberation xdg-utils
curl --silent https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output chrome.deb
dpkg -i chrome.deb
rm chrome.deb

# apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
# ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
# echo "CHROMIUM_FLAGS='--start-maximized --user-data-dir'" > $HOME/.chromium-browser.init
