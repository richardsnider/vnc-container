FROM registry.hub.docker.com/library/ubuntu:19.10

ENV HOME=/home/user
ENV BUILD_DIRECTORY=$HOME/build
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR $HOME

ADD ./build/install-base-packages.sh $BUILD_DIRECTORY/install-base-packages.sh
RUN chmod +x $BUILD_DIRECTORY/install-base-packages.sh && $BUILD_DIRECTORY/install-base-packages.sh

ADD ./build/setup $BUILD_DIRECTORY/setup
RUN chmod +x $BUILD_DIRECTORY/setup/setup.sh && $BUILD_DIRECTORY/setup/setup.sh

ADD ./build/vnc $BUILD_DIRECTORY/vnc
RUN chmod +x $BUILD_DIRECTORY/vnc/setup_vnc.sh && $BUILD_DIRECTORY/vnc/setup_vnc.sh

# Root user (UID 0) is no longer needed. Change user to the first normal non-root user (UID 1000)
USER 1000

# Change default entrypoint from `/bin/sh -c` to `/startup/vnc_startup.sh` and add --wait option by default
ENTRYPOINT ["/startup/vnc_startup.sh"]
CMD ["--wait"]

EXPOSE 5901 6901

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
      io.k8s.display-name="Perennial"

