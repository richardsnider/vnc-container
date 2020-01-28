FROM ubuntu:19.10

ENV HOME=/home/user
ENV BUILD_DIRECTORY=$HOME/build
WORKDIR $HOME

ADD ./build/install-base-packages.sh $BUILD_DIRECTORY/install-base-packages.sh
RUN chmod +x $BUILD_DIRECTORY/install-base-packages.sh && $BUILD_DIRECTORY/install-base-packages.sh

ADD ./build/setup $BUILD_DIRECTORY/setup
RUN chmod +x $BUILD_DIRECTORY/setup/setup.sh && $BUILD_DIRECTORY/setup/setup.sh

ENV STARTUP_DIRECTORY=/startup
ENV NO_VNC_HOME=/home/user/noVNC
ENV VNC_COL_DEPTH=24
ENV VNC_RESOLUTION=1920x1080
ENV VNC_PW=vncpassword
ENV VNC_VIEW_ONLY=false
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NO_VNC_PORT=6901

EXPOSE $VNC_PORT $NO_VNC_PORT

ADD ./build/vnc $BUILD_DIRECTORY/vnc
RUN find $BUILD_DIRECTORY/vnc -name '*.sh' -exec chmod a+x {} +
RUN $BUILD_DIRECTORY/vnc/setup_vnc.sh

# Root user (UID 0) is no longer needed. Change user to the first normal non-root user (UID 1000)
USER 1000

# Change default entrypoint from `/bin/sh -c` to `/startup/vnc_startup.sh` and add --wait option by default
ENTRYPOINT ["/startup/vnc_startup.sh"]
CMD ["--wait"]

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
      io.k8s.display-name="Perennial"
