#!/bin/bash

# Range of tokens
START=$1
END=${2:-$START}  # If $2 is not provided, set it to $1

# Create or clear keys.txt
echo "" > keys.txt

# Loop through all token IDs
for (( token_id=START; token_id<=END; token_id++ )); do
    # Path to the token directory
    TOKEN_DIR="./$token_id"

    # Find the file starting with 'hexkey_selected' in the directory
    HEXKEY_FILE=$(find "$TOKEN_DIR" -type f -name 'hexkey_selected*' -print -quit)

    # Check if the file was found
    if [[ -f "$HEXKEY_FILE" ]]; then
        # Append the content of the found file to keys.txt
        cat "$HEXKEY_FILE" >> keys.txt

        echo "Appended $HEXKEY_FILE content to keys.txt"
    else
        echo "No hexkey_selected file found in $TOKEN_DIR"
    fi
done

