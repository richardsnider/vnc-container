#!/usr/bin/env bash
set -eo pipefail

GIT_BRANCH=$1

if [ -z $GIT_BRANCH ] ; then
    echo "ERROR: GIT_BRANCH not set."
    exit -1
else
    echo "branch=$GIT_BRANCH"
fi

DOCKER_TAG="${GIT_BRANCH/origin\//refs\/tags\/}"
# TODO: Obtain proper docker registry trigger ID for URL:
URL="https://registry.hub.docker.com/u/vorprog/ubuntu-xfce-vnc/trigger/???????????????????????/"
PAYLOAD='{"source_type": "Tag", "source_name": "'$DOCKER_TAG'"}'

echo "URL: $URL"
echo "PAYLOAD: $PAYLOAD"
curl -H "Content-Type: application/json" --data "$PAYLOAD" -X POST "$URL"
echo " Completed."
