FROM ubuntu:19.10

ENV HOME=/home/user
ENV BUILD_DIRECTORY=/home/user/build
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR $HOME

ADD ./build/install-base-packages.sh $BUILD_DIRECTORY/install-base-packages.sh
RUN chmod +x $BUILD_DIRECTORY/install-base-packages.sh && $BUILD_DIRECTORY/install-base-packages.sh

ADD ./build/install $BUILD_DIRECTORY/install
ADD ./build/content $BUILD_DIRECTORY/content
ADD ./build/build.sh $BUILD_DIRECTORY/build.sh
RUN chmod +x $BUILD_DIRECTORY/build.sh && $BUILD_DIRECTORY/build.sh

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
      io.k8s.display-name="Perennial"

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

# Install nss-wrapper to be able to execute image as non-root user
RUN apt-get install -y libnss-wrapper gettext

ADD ./build/vnc $BUILD_DIRECTORY/vnc
RUN find $BUILD_DIRECTORY/vnc -name '*.sh' -exec chmod a+x {} +
RUN $BUILD_DIRECTORY/vnc/tigervnc.sh
RUN $BUILD_DIRECTORY/vnc/no_vnc.sh

RUN mkdir $STARTUP_DIRECTORY
RUN cp $BUILD_DIRECTORY/vnc/wm_startup.sh $HOME/wm_startup.sh && chmod +x $HOME/wm_startup.sh
RUN cp $BUILD_DIRECTORY/vnc/vnc_startup.sh $STARTUP_DIRECTORY/vnc_startup.sh
RUN $BUILD_DIRECTORY/vnc/set_user_permission.sh $STARTUP_DIRECTORY $HOME

RUN chown -R user:user $HOME

# Root user (UID 0) is no longer needed. Change user to the first normal non-root user (UID 1000)
USER 1000

# Change default entrypoint from `/bin/sh -c` to `/startup/vnc_startup.sh` and add --wait option by default
ENTRYPOINT ["/startup/vnc_startup.sh"]
CMD ["--wait"]
