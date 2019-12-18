#!/usr/bin/env bash
set -eo pipefail

word1=$(grep -E -e '^[a-z]{4,4}$' /usr/share/dict/words | sort --random-sort | sed -e '$!d')
word2=$(grep -E -e '^[a-z]{4,4}$' /usr/share/dict/words | sort --random-sort | sed -e '$!d')
tag="${word1}_${word2}"

outputFileName="${tag}_build.log"
timestamp="$(date +"%Y-%m-%d-T-%H-%M-%S")"
echo "Timestamp: $timestamp" | tee $outputFileName

docker build --no-cache -t perennial:latest -t perennial:$tag . | tee $outputFileName
