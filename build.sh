#!/usr/bin/env bash
set -eo pipefail

timestamp="$(date +"%Y-%m-%d-T-%H-%M-%S")"
outputFileName="build-{$timestamp}.log"

docker build -t ubuntu-xfce-vnc . >> outputFileName