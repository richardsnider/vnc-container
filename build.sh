#!/usr/bin/env bash
set -eo pipefail

mkdir -p logs

word1=$(grep -E -e '^[a-z]{4,4}$' /usr/share/dict/words | sort --random-sort | sed -e '$!d')
word2=$(grep -E -e '^[a-z]{4,4}$' /usr/share/dict/words | sort --random-sort | sed -e '$!d')
tag="${word1}_${word2}"

outputFileName="./logs/${tag}_build.log"
timestamp="$(date +"%Y-%m-%d-T-%H-%M-%S")"
echo "Timestamp: $timestamp" | tee $outputFileName

echo "Rebuild from scratch (--no-cache)? (y/n)"
read $REBUILD_PERENNIAL_FROM_SCRATCH
if [ "$REBUILD_PERENNIAL_FROM_SCRATCH" = "y" || "$REBUILD_PERENNIAL_FROM_SCRATCH" = "yes" || "$REBUILD_PERENNIAL_FROM_SCRATCH" = "Y"]
then docker build --no-cache -t perennial:latest -t perennial:$tag . | tee $outputFileName
else docker build -t perennial:latest -t perennial:$tag . | tee $outputFileName
fi
