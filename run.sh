#!/usr/bin/env bash
set -eo pipefail

RANDOM_PASSWORD=$(openssl rand -hex 10)
echo "Generated password is: $RANDOM_PASSWORD"

docker run \
--privileged \
--name perennial \
--detach \
--shm-size=256m \
-p 5901:5901 -p 6901:6901 \
-e VNC_PW=$RANDOM_PASSWORD \
perennial:latest

sleep 2
docker ps