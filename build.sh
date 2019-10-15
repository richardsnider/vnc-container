#!/usr/bin/env bash
set -eo pipefail

timestamp="$(date +"%Y-%m-%d-T-%H-%M-%S")"
outputFileName="build-$timestamp.log"

GIT_EMAIL_ARG=${1:-"email@example.com"}
echo "git email: $GIT_EMAIL_ARG"
GIT_USERNAME_ARG=${2:-"Default User"}
echo "git username: $GIT_USERNAME_ARG"

docker build \
--build-arg GIT_EMAIL_ARG=$GIT_EMAIL_ARG \
--build-arg GIT_USERNAME_ARG="$GIT_USERNAME_ARG" \
-t ubuntu-xfce-vnc . | tee $outputFileName
