#!/bin/bash

# Function to randomize the case of a string
randomize_case() {
    local input="$1"
    local output=""

    for (( i=0; i<${#input}; i++ )); do
        char="${input:i:1}"
        if (( RANDOM % 2 )); then
            output+="${char^^}"  # Uppercase
        else
            output+="${char,,}"  # Lowercase
        fi
    done

    echo "$output"
}

# Range of tokens
START=$1
END=$2

# Loop through all token IDs
for (( token_id=START; token_id<=END; token_id++ )); do
    # Path to the token directory
    TOKEN_DIR="./$token_id"
    TEXT_FILE="$TOKEN_DIR/uri.txt"
    NAME_FILE="$TOKEN_DIR/name.txt"

    # Check if the text.txt file exists
    if [[ -f "$TEXT_FILE" ]]; then
        # Extract the title from the text.txt file
        title=$(jq -r '.title' "$TEXT_FILE")

        # Randomize the case of the title
        randomized_title=$(randomize_case "$title")

        # Write the randomized title to name.txt in the token directory
        echo "$randomized_title" > "$NAME_FILE"

        echo "Written to $NAME_FILE: $randomized_title"
    else
        echo "File $TEXT_FILE not found for token $token_id."
    fi
done
