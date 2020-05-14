#!/usr/bin/env bash

docker rm -f workspace
docker build -t workspace .
docker run --detach --publish 666:22 --name workspace workspace

sed -i ".bak" '/localhost/d' ~/.ssh/known_hosts
# ssh root@localhost -p 666
