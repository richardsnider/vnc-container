FROM ubuntu:19.10

RUN useradd -ms /bin/bash -u 1000 user

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
      io.k8s.display-name="Perennial"

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

ENV HOME=/home/user \
    TERM=xterm \
    STARTUP_DIRECTORY=/dockerstartup \
    INSTALL_SCRIPTS=/home/user/build/install \
    NODE_SCRIPTS=/home/user/build/node_scripts \
    NO_VNC_HOME=/home/user/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

# Do some preliminary package installations
RUN apt-get -q update
RUN apt-get install -y apt-utils
RUN apt-get install -y software-properties-common
RUN apt-get -q update
RUN apt-get upgrade -y
RUN apt-get autoremove -y

RUN apt-get install -y wget
RUN apt-get install -y net-tools
RUN apt-get install -y locales
RUN apt-get install -y build-essential
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y file
RUN apt-get install -y gnupg
RUN apt-get install -y bzip2
RUN apt-get install -y python-numpy
RUN apt-get install -y unzip
RUN apt-get install -y jq

# Generate locales for en_US.UTF-8 and set language to english from generated locale
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' FONTCONFIG_PATH='/etc/fonts/'

# Copy install scripts into the container and make them executable
ADD ./build/install-scripts/ $INSTALL_SCRIPTS/
RUN find $INSTALL_SCRIPTS -name '*.sh' -exec chmod a+x {} +

RUN $INSTALL_SCRIPTS/git.sh
RUN $INSTALL_SCRIPTS/python.sh
RUN $INSTALL_SCRIPTS/nodejs.sh
RUN $INSTALL_SCRIPTS/kubectl.sh
RUN $INSTALL_SCRIPTS/kops.sh
RUN $INSTALL_SCRIPTS/vs_code.sh
RUN $INSTALL_SCRIPTS/copyq.sh
RUN $INSTALL_SCRIPTS/tigervnc.sh
RUN $INSTALL_SCRIPTS/no_vnc.sh
RUN $INSTALL_SCRIPTS/firefox.sh
RUN $INSTALL_SCRIPTS/chrome.sh
RUN $INSTALL_SCRIPTS/xfce_ui.sh
RUN $INSTALL_SCRIPTS/edex-ui.sh

# Copy xfce configuration to container
ADD --chown=1000 ./build/xfce_v14/ $HOME/

# Configure startup
RUN $INSTALL_SCRIPTS/libnss_wrapper.sh
ADD ./build/startup-scripts $STARTUP_DIRECTORY
RUN $INSTALL_SCRIPTS/set_user_permission.sh $STARTUP_DIRECTORY $HOME

# Root user (UID 0) is no longer needed. Change user to the first normal non-root user (UID 1000)
USER 1000

ADD ./build/.bashrc $HOME/.bashrc

ADD --chown=1000 ./build/node $NODE_SCRIPTS/
RUN npm install --prefix $NODE_SCRIPTS
RUN node $NODE_SCRIPTS/generateBackground.js

# Change default entrypoint from `/bin/sh -c` to `/dockerstartup/vnc_startup.sh` and add --wait option by default
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
