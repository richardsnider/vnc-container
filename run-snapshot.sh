#!/usr/bin/env bash
set -eo pipefail

docker run \
--privileged \
--name perennial-snapshot \
--detach \
--shm-size=256m \
-p 5901:5901 -p 6901:6901 \
perennial:snapshot