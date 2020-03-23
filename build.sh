#!/usr/bin/env bash
set -eo pipefail

mkdir -p logs

word1=$(grep -E -e '^[a-z]{4,4}$' /usr/share/dict/words | sort --random-sort | sed -e '$!d')
word2=$(grep -E -e '^[a-z]{4,4}$' /usr/share/dict/words | sort --random-sort | sed -e '$!d')
tag="${word1}_${word2}"

outputFileName="./logs/${tag}_build.log"
timestamp="$(date +"%Y-%m-%d-T-%H-%M-%S")"
echo "Timestamp: $timestamp" | tee $outputFileName

read -p "Rebuild from scratch (--no-cache)? (y/n)" PERENNIAL_NO_CACHE
if [[ "$PERENNIAL_NO_CACHE" = "y" || "$PERENNIAL_NO_CACHE" = "Y" || "$PERENNIAL_NO_CACHE" = "yes" ]]; then
    docker build --no-cache -t perennial:latest -t perennial:$tag . | tee $outputFileName
else 
    docker build -t perennial:latest -t perennial:$tag . | tee $outputFileName
fi