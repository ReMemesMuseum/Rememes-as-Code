#!/bin/bash

# Set the starting and ending token IDs
START_TOKEN=$1
END_TOKEN=$2

# Directory where token data is stored
BASE_DIR="."

# Loop from START_TOKEN to END_TOKEN to extract the image_url link
for TOKEN_ID in $(seq "$START_TOKEN" "$END_TOKEN"); do
    # Path to the file containing the Raw Response for the current token
    RESPONSE_FILE="$BASE_DIR/$TOKEN_ID/uri.txt"

    # Check if the file exists
    if [[ -f "$RESPONSE_FILE" ]]; then
        # Extract the image_url link from the file
        image_url=$(jq -r '.metadata.image_url' "$RESPONSE_FILE")

        # Check if the link is not null
        if [[ "$image_url" != "null" ]]; then
            echo "Token ID: $TOKEN_ID, Image URL: $image_url"

            # Download the file temporarily to check its type
            TEMP_FILE="$BASE_DIR/$TOKEN_ID/temp_image"
            wget -q -O "$TEMP_FILE" "$image_url"

            # Check the file type
            if [[ -f "$TEMP_FILE" ]]; then
                FILE_TYPE=$(file --mime-type -b "$TEMP_FILE")
                
                if [[ "$FILE_TYPE" == "image/jpeg" ]]; then
                    EXT="jpeg"  # Set extension to jpeg
                elif [[ "$FILE_TYPE" == "image/gif" ]]; then
                    EXT="gif"   # Set extension to gif
                elif [[ "$FILE_TYPE" == "image/png" ]]; then
                    EXT="png"   # Set extension to png
                else
                    echo "Unsupported format for token $TOKEN_ID: $FILE_TYPE"
                    rm "$TEMP_FILE"  # Remove the temporary file
                    continue
                fi

                # Save the file with the correct extension
                FINAL_FILE="$BASE_DIR/$TOKEN_ID/$TOKEN_ID.$EXT"
                mv "$TEMP_FILE" "$FINAL_FILE"
                echo "Content for token $TOKEN_ID successfully downloaded and saved as $FINAL_FILE."
            else
                echo "Error during download for token $TOKEN_ID."
            fi
        else
            echo "Token ID: $TOKEN_ID, Image URL not found."
        fi
    else
        echo "File $RESPONSE_FILE not found."
    fi
done
