#!/bin/bash

# Range of tokens
START=$1
END=${2:-$START}  # If $2 is not provided, set it to $1 (single token mode)

# Name of the output file
OUTPUT_FILE="artists.txt"

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Loop through all token IDs
for (( token_id=START; token_id<=END; token_id++ )); do
    # Path to the token directory
    TOKEN_DIR="./$token_id"
    TEXT_FILE="$TOKEN_DIR/text.txt"

    # Check if the text.txt file exists
    if [[ -f "$TEXT_FILE" ]]; then
        # Extract the value of 'artist' from the text.txt file
        artist=$(jq -r '.attributes[] | select(.trait_type == "Artist") | .value' "$TEXT_FILE")

        # If the 'artist' value was found, write it to the output file
        if [[ -n "$artist" ]]; then
            echo "$token_id $artist" >> "$OUTPUT_FILE"
            echo "Recorded: token $token_id, artist: $artist"
        else
            # If 'artist' is not found, log a message
            echo "Artist not found in $TEXT_FILE for token $token_id."
        fi
    else
        # If the text.txt file does not exist, log a message
        echo "File $TEXT_FILE not found for token $token_id."
    fi
done

# Notify that the data has been written to the output file
echo "All data recorded in $OUTPUT_FILE."

