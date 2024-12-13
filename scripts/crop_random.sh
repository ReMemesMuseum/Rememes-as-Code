#!/bin/bash

# Check if a token number is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <token_number>"
    exit 1
fi

# Get the token number from input arguments
TOKEN_ID=$1

# Define the directory for the token
TOKEN_DIR="./$TOKEN_ID"

# Search for the file with the pattern *-2.png
input_image=$(find "$TOKEN_DIR" -name "*-2.png" -print -quit)

# Check if the file was found
if [ -z "$input_image" ]; then
    echo "No file matching '*-2.png' found in directory $TOKEN_DIR."
    exit 1
fi

# Input and output images
output_directory=$(dirname "$input_image")
output_image="$output_directory/output-$TOKEN_ID.jpg"

# Get image dimensions (width and height)
dimensions=$(identify -format "%w %h" "$input_image")
width=$(echo $dimensions | cut -d' ' -f1)
height=$(echo $dimensions | cut -d' ' -f2)

# Crop area size
crop_size=1200

# Check if the image is large enough for a crop
if [ "$width" -lt "$crop_size" ] || [ "$height" -lt "$crop_size" ]; then
    echo "Image is too small for a crop."
    exit 1
fi

# Generate random coordinates for cropping
max_x=$((width - crop_size))
max_y=$((height - crop_size))

# Random coordinates (from 0 to max_x and max_y)
x=$((RANDOM % (max_x + 1)))
y=$((RANDOM % (max_y + 1)))

# Perform the crop
convert "$input_image" -crop ${crop_size}x${crop_size}+${x}+${y} "$output_image" 2>/dev/null

echo "Cropping for $TOKEN_ID done"
