#!/bin/bash

# Directory where token data is stored
BASE_DIR="."

# Loop from 1 to 280 to extract the raw link
for TOKEN_ID in $(seq $1 $2); do
    # Path to the uri.txt file for the current token
    URI_FILE="$BASE_DIR/$TOKEN_ID/uri.txt"

    # Check if the file exists
    if [[ -f "$URI_FILE" ]]; then
        # Extract the raw link from the file
        raw_link=$(jq -r '.tokenUri.raw' "$URI_FILE")

        # Check if the link is not null
        if [[ "$raw_link" != "null" ]]; then
            echo "Token ID: $TOKEN_ID, Raw Link: $raw_link"

            # Use wget to download the content from the link and save it to text.txt
            wget -q -O "$BASE_DIR/$TOKEN_ID/text.txt" "$raw_link"

            # Check if wget executed successfully
            if [[ $? -eq 0 ]]; then
                echo "Content for token $TOKEN_ID successfully downloaded and saved to text.txt."
            else
                echo "Error during download for token $TOKEN_ID."
            fi
        else
            echo "Token ID: $TOKEN_ID, Raw Link not found."
        fi
    else
        echo "File $URI_FILE not found."
    fi
done
