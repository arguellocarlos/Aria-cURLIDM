#!/bin/bash

# URL of the file to download
URL="" # Change URL to the download path on the remote server

# Get the file name from the URL
FILENAME=$(basename "$URL")

# Download the file with aria2 using specified options
aria2c -k 2M -s 16 -x 16 -o "$FILENAME" "$URL"

echo "Download completed: $FILENAME"