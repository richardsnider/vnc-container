#!/bin/bash

BACKGROUND_URL="https://images.fineartamerica.com/images/artworkimages/mediumlarge/2/world-map-in-black-and-white-dots-jan-fidler.jpg"

while true
do
    curl --silent $BACKGROUND_URL --output ~/.config/background.jpg
    sleep 5
done
