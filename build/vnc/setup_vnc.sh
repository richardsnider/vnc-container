#!/usr/bin/env bash
set -e

find $BUILD_DIRECTORY/vnc -name '*.sh' -exec chmod a+x {} +

echo "Create /etc/profile.d/vnc-environment-variables.sh"
cp $BUILD_DIRECTORY/vnc/vnc-environment-variables.sh /etc/profile.d/vnc-environment-variables.sh
source /etc/profile.d/vnc-environment-variables.sh

echo "Install nss-wrapper to be able to execute image as non-root user"
apt-get install -y libnss-wrapper gettext

echo "Install TigerVNC server"
wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /

echo "Install noVNC - HTML5 based VNC viewer"
mkdir -p $NO_VNC_HOME/utils/websockify
wget -qO- https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME
# use older version of websockify to prevent hanging connections on offline containers
wget -qO- https://github.com/novnc/websockify/archive/v0.6.1.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify
chmod +x -v $NO_VNC_HOME/utils/*.sh
# create index.html to forward automatically to `vnc_lite.html`
ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html

echo "Create startup directory and move wm_startup and vnc_startup scripts"
mkdir $STARTUP_DIRECTORY
cp $BUILD_DIRECTORY/vnc/wm_startup.sh $HOME/wm_startup.sh
cp $BUILD_DIRECTORY/vnc/vnc_startup.sh $STARTUP_DIRECTORY/vnc_startup.sh

echo "Fix startup and home directory permissions"
$BUILD_DIRECTORY/vnc/set_user_permission.sh $STARTUP_DIRECTORY $HOME
chown -R user:user $HOME