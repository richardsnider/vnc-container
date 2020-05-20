FROM registry.hub.docker.com/library/ubuntu:20.04

ENV HOME=/home/user
ENV BUILD_DIRECTORY=$HOME/build
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR $HOME

RUN apt-get -q update
RUN apt-get install -y apt-utils
RUN apt-get install -y software-properties-common
RUN apt-get -q update
RUN apt-get upgrade -y
RUN apt-get autoremove -y

RUN apt-get install -y sudo
RUN apt-get install -y locales
RUN apt-get install -y build-essential
RUN apt-get install -y net-tools
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y apt-transport-https
RUN apt-get install -y ca-certificates
RUN apt-get install -y openssh-server
RUN apt-get install -y sshfs
RUN apt-get install -y openssh-server

RUN apt-get install -y vim
RUN apt-get install -y file
RUN apt-get install -y gnupg
RUN apt-get install -y bzip2
RUN apt-get install -y python-numpy
RUN apt-get install -y unzip
RUN apt-get install -y jq
RUN apt-get install -y git

ADD ./build $BUILD_DIRECTORY
RUN chmod +x $BUILD_DIRECTORY/setup.sh && $BUILD_DIRECTORY/setup.sh

EXPOSE 22 25 53 80 8000-8100
CMD    ["/usr/sbin/sshd", "-D"]