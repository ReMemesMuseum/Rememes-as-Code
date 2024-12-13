#!/bin/bash

# Check if a token number is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <token_number>"
    exit 1
fi

# Get the token number from input arguments
TOKEN_ID=$1

# Define the directory for the token
TOKEN_DIR="./$TOKEN_ID/$TOKEN_ID"

# Check if the directory exists
if [ ! -d "$TOKEN_DIR" ]; then
    echo "Directory '$TOKEN_DIR' does not exist."
    exit 1
fi

# Find the GIF file in the token directory
gif_file=$(find "$TOKEN_DIR" -name "*.gif" -print -quit)

# Check if a GIF file was found
if [ -z "$gif_file" ]; then
    echo "No GIF file found in directory '$TOKEN_DIR'."
    exit 1
fi

# Get the resolution of the GIF file
resolution=$(identify -format "%wx%h" "$gif_file"[0])

# Check if resolution was obtained
if [ -z "$resolution" ]; then
    echo "Could not determine the resolution of '$gif_file'."
    exit 1
fi

# Output the resolution
echo -e "\nResolution: $resolution"
