#!/bin/bash

# URL of the file to download
URL="" #Change URL to download path on the remote server

# Number of concurrent connections
CONCURRENT=4

# Get the file name from the URL or response headers
FILENAME=$(basename "$URL")

# Get the file size
FILE_SIZE=$(curl -sI "$URL" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')

# Calculate chunk size
CHUNK_SIZE=$((FILE_SIZE / CONCURRENT))

# Download in the background using curl
for ((i=0; i<CONCURRENT; i++)); do
    START=$((i * CHUNK_SIZE))
    END=$(( (i + 1) * CHUNK_SIZE - 1 ))

    # Adjust the last chunk to cover the entire file
    if [ $i -eq $((CONCURRENT - 1)) ]; then
        END=$((FILE_SIZE - 1))
    fi

    RANGE="${START}-${END}"
    curl -# --range "$RANGE" "$URL" -o "$FILENAME.part$i" &
done

# Wait for all background jobs to finish
wait

# Combine the parts into a single file
cat "$FILENAME.part"* > "$FILENAME"
rm "$FILENAME.part"*

echo "Download completed: $FILENAME"