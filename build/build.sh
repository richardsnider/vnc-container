#!/usr/bin/env bash
set -e

# Add default user
useradd -ms /bin/bash -u 1000 user

# Set environment variables
HOME=/home/user
BUILD_DIRECTORY=/home/user/build
TERM=xterm
DEBIAN_FRONTEND=noninteractive

# Generate locales for en_US.UTF-8 and set language to english from generated locale
locale-gen en_US.UTF-8
LANG='en_US.UTF-8'
LANGUAGE='en_US:en'
LC_ALL='en_US.UTF-8'
FONTCONFIG_PATH='/etc/fonts/'

find $BUILD_DIRECTORY/install -name '*.sh' -exec chmod a+x {} +

$BUILD_DIRECTORY/install/python.sh
$BUILD_DIRECTORY/install/nodejs.sh
$BUILD_DIRECTORY/install/kubectl.sh
$BUILD_DIRECTORY/install/kops.sh
$BUILD_DIRECTORY/install/vs_code.sh
$BUILD_DIRECTORY/install/copyq.sh
$BUILD_DIRECTORY/install/firefox.sh
$BUILD_DIRECTORY/install/chrome.sh
$BUILD_DIRECTORY/install/xfce_ui.sh
# $BUILD_DIRECTORY/install/edex-ui.sh

cp -r $BUILD_DIRECTORY/content/.config $HOME/.config
cp $BUILD_DIRECTORY/content/.bashrc $HOME/.bashrc
chown -R user:user $HOME

sudo -u user npm install --prefix $BUILD_DIRECTORY/install/node
sudo -u user node $BUILD_DIRECTORY/install/node/generateBackground.js



