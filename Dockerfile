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
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

# Copy install scripts into the container and make them executable
ADD ./build/install-scripts/ $INSTALL_SCRIPTS/
RUN find $INSTALL_SCRIPTS -name '*.sh' -exec chmod a+x {} +

# apt-get install basic tools and generate an english locale
RUN $INSTALL_SCRIPTS/tools.sh

# Set language to english from tool.sh's generated locale
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Install software
RUN $INSTALL_SCRIPTS/git.sh
RUN $INSTALL_SCRIPTS/golang.sh
RUN $INSTALL_SCRIPTS/nodejs.sh
RUN $INSTALL_SCRIPTS/kubectl.sh
RUN $INSTALL_SCRIPTS/python.sh
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

# Scripts are complete, root user (UID 0) is no longer needed. Change user the first normal non-root user (UID 1000)
USER 1000

# Change default entrypoint from `/bin/sh -c` to `/dockerstartup/vnc_startup.sh` and add --wait option by default
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
