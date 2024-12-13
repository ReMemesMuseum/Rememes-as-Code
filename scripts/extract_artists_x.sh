#!/bin/bash

# Input files
ARTISTS_FILE="artists_x.txt"  # File with token-author mappings
IMAGE_FILE=$1  # Image file with numbers in the name

# Extract numbers from the image file name
numbers=$(echo "$IMAGE_FILE" | grep -oP '\d+')

# Check if the artists file exists
if [[ ! -f "$ARTISTS_FILE" ]]; then
    echo "Error: File $ARTISTS_FILE not found!"
    exit 1
fi

# Loop through extracted numbers
for number in $numbers; do
    # Find the author corresponding to the number in the artists file
    author=$(grep -E "^$number " "$ARTISTS_FILE" | awk '{print $2}')

    # Check if an author was found
    if [[ -n "$author" ]]; then
        echo "Token $number: $author"
    else
        echo "Token $number: Not found"
    fi
done

