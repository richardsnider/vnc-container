#!/usr/bin/env bash
set -eo pipefail

timestamp="$(date +"%Y-%m-%d-T-%H-%M-%S")"
outputFileName="build-$timestamp.log"

docker build --build-arg GIT_EMAIL_ARG=${1:-"email@example.com"} -t ubuntu-xfce-vnc . | tee $outputFileName
