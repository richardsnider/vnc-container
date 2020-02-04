#!/usr/bin/env bash
set -e

# Add default user
useradd -ms /bin/bash -u 1000 user

# Generate locales for en_US.UTF-8 and set language to english from generated locale
locale-gen en_US.UTF-8
LANG='en_US.UTF-8'
LANGUAGE='en_US:en'
LC_ALL='en_US.UTF-8'
FONTCONFIG_PATH='/etc/fonts/'

ls $BUILD_DIRECTORY

find $BUILD_DIRECTORY/setup/scripts -name '*.sh' -exec chmod a+x {} +

$BUILD_DIRECTORY/setup/scripts/python.sh
$BUILD_DIRECTORY/setup/scripts/nodejs.sh
$BUILD_DIRECTORY/setup/scripts/kubectl.sh
$BUILD_DIRECTORY/setup/scripts/kops.sh
$BUILD_DIRECTORY/setup/scripts/vs_code.sh
$BUILD_DIRECTORY/setup/scripts/copyq.sh
$BUILD_DIRECTORY/setup/scripts/firefox.sh
$BUILD_DIRECTORY/setup/scripts/chrome.sh
$BUILD_DIRECTORY/setup/scripts/xfce_ui.sh
$BUILD_DIRECTORY/setup/scripts/edex-ui.sh

cp -r $BUILD_DIRECTORY/setup/content/.config $HOME/.config
cp $BUILD_DIRECTORY/setup/content/.bashrc $HOME/.bashrc
chown -R user:user $HOME

sudo -u user npm install --prefix $BUILD_DIRECTORY/setup/scripts/node
sudo -u user node $BUILD_DIRECTORY/setup/scripts/node/generateBackground.js
