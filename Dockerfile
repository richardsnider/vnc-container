FROM ubuntu:18.04

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
      io.k8s.display-name="Headless Ubuntu VNC Container"

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

ENV HOME=/headless \
    TERM=xterm \
    STARTUP_DIRECTORY=/dockerstartup \
    INSTALL_SCRIPTS=/headless/install \
    SETUP_SCRIPTS=/headless/setup \
    NODE_SCRIPTS=/headless/node_scripts \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

# Copy install scripts into the container and make them executable
ADD ./build/install-scripts/ $INSTALL_SCRIPTS/
RUN find $INSTALL_SCRIPTS -name '*.sh' -exec chmod a+x {} +

# Do some preliminary package installations
RUN apt-get -q update
RUN apt-get install -y apt-utils
RUN apt-get install -y software-properties-common
RUN apt-get -q update
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y net-tools
RUN apt-get install -y locales
RUN apt-get install -y build-essential
RUN apt-get install -y curl
RUN apt-get install -y file
RUN apt-get install -y gnupg
RUN apt-get install -y bzip2
RUN apt-get install -y python-numpy
RUN apt-get clean -y

# Generate locales for en_US.UTF-8 and set language to english from generated locale
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' FONTCONFIG_PATH='/etc/fonts/'

RUN apt-get upgrade -y
RUN apt-get autoremove -y

RUN $INSTALL_SCRIPTS/git.sh
RUN $INSTALL_SCRIPTS/brew.sh
RUN $INSTALL_SCRIPTS/python.sh
RUN $INSTALL_SCRIPTS/golang.sh
RUN $INSTALL_SCRIPTS/nodejs.sh
RUN $INSTALL_SCRIPTS/kubectl.sh
RUN $INSTALL_SCRIPTS/kops.sh
RUN $INSTALL_SCRIPTS/vs_code.sh
RUN $INSTALL_SCRIPTS/tigervnc.sh
RUN $INSTALL_SCRIPTS/no_vnc.sh
RUN $INSTALL_SCRIPTS/firefox.sh
RUN $INSTALL_SCRIPTS/chrome.sh
RUN $INSTALL_SCRIPTS/xfce_ui.sh

# Copy xfce configuration to container
ADD ./build/xfce/ $HOME/

# Configure startup
RUN $INSTALL_SCRIPTS/libnss_wrapper.sh
ADD ./build/startup-scripts $STARTUP_DIRECTORY
RUN $INSTALL_SCRIPTS/set_user_permission.sh $STARTUP_DIRECTORY $HOME

ADD ./build/node $NODE_SCRIPTS/
RUN chown -R 1000 $NODE_SCRIPTS

ADD ./build/setup-scripts $SETUP_SCRIPTS/
RUN find $SETUP_SCRIPTS -name '*.sh' -exec chmod a+x {} +

RUN useradd -ms /bin/bash -u 1000 user

# Root user (UID 0) is no longer needed. Change user to the first normal non-root user (UID 1000)
USER 1000

WORKDIR $NODE_SCRIPTS

RUN npm install
RUN node generateBackground.js

WORKDIR $HOME

RUN mkdir $HOME/git
ARG GIT_EMAIL_ARG
ENV GIT_EMAIL=$GIT_EMAIL_ARG
ARG GIT_USERNAME_ARG
ENV GIT_USERNAME=$GIT_USERNAME_ARG

RUN git config --global user.email $GIT_EMAIL
RUN git config --global user.name "$GIT_USERNAME"
RUN $SETUP_SCRIPTS/ssh_setup.sh

# Change default entrypoint from `/bin/sh -c` to `/dockerstartup/vnc_startup.sh` and add --wait option by default
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
