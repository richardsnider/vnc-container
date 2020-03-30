#!/usr/bin/env bash
set -e

echo "Install Xfce4 UI components"
apt-get install -y supervisor xfce4 xfce4-terminal xterm wmctrl
apt-get purge -y pm-utils xscreensaver*

mv $BUILD_DIRECTORY/setup/content/dark-theme /usr/share/themes/dark-theme

# run window in the background
# wmctrl -r :ACTIVE: -b remove,fullscreen
# wmctrl -r :ACTIVE: -b add,skip_taskbar
