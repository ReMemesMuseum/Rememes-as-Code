#!/bin/bash

# Range of tokens
START=$1
END=${2:-$START}  # If $2 is not provided, set it to $1

# Loop through all token IDs
for (( token_id=START; token_id<=END; token_id++ )); do
    # Path to the token directory
    TOKEN_DIR="./$token_id"
    TEXT_FILE="$TOKEN_DIR/text.txt"
    TITLE_FILE="$TOKEN_DIR/title.txt"

    # Check if the text.txt file exists
    if [[ -f "$TEXT_FILE" ]]; then
        # Extract values from the text.txt file
        name=$(jq -r '.name' "$TEXT_FILE")
        season=$(jq -r '.attributes[] | select(.trait_type == "Type - Season") | .value' "$TEXT_FILE")
        card=$(jq -r '.attributes[] | select(.trait_type == "Type - Card") | .value' "$TEXT_FILE")
        artist=$(jq -r '.attributes[] | select(.trait_type == "Artist") | .value' "$TEXT_FILE")
        created_by=$(jq -r '.created_by' "$TEXT_FILE")

        # Form the OUTPUT string and replace spaces with #
        OUTPUT="${name}#${created_by}#Season#$season#Meme#$card#by#$artist"
        OUTPUT=${OUTPUT// /#}

        # Remove newlines from OUTPUT
        OUTPUT=$(echo "$OUTPUT" | tr -d '\n')

        # Write the result to title.txt
        echo "$OUTPUT" > "$TITLE_FILE"

        echo "Written to $TITLE_FILE: $OUTPUT"
    else
        echo "File $TEXT_FILE not found for token $token_id."
    fi
done
