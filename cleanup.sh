#!/usr/bin/env bash
set -eo pipefail

docker exec vnc rm -rf Pictures
docker exec vnc rm -rf Music
docker exec vnc rm -rf Videos
docker exec vnc rm -rf Templates
docker exec vnc rm -rf Documents