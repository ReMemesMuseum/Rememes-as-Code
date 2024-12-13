#!/bin/bash

# Range of tokens
START=$1
END=${2:-$START}  # If $2 is not provided, set it to $1

year=$(date +%Y)
# Loop through all token IDs
for (( token_id=START; token_id<=END; token_id++ )); do
    # Path to the token directory
    TOKEN_DIR="./$token_id"
    TEXT_FILE="$TOKEN_DIR/text.txt"
    DESCRIPTION_FILE="$TOKEN_DIR/description.txt"

    # Check if the text.txt file exists
    if [[ -f "$TEXT_FILE" ]]; then
        # Extract values from the text.txt file
        name=$(jq -r '.name' "$TEXT_FILE")
        created_by=$(jq -r '.attributes[] | select(.trait_type == "Artist") | .value' "$TEXT_FILE")

        # Create the output string using the template
        OUTPUT="Rememe of \"$name\" by $created_by from \"The Memes by 6529\""

        # Write the result to title.txt
        echo "$OUTPUT" > "$DESCRIPTION_FILE"

        echo "Written to $DESCRIPTION_FILE: $OUTPUT"
    else
        echo "File $DESCRIPTION_FILE not found for token $token_id."
    fi

    cat description_sample.txt >> "$DESCRIPTION_FILE"
    bash get_resolution.sh $token_id >> "$DESCRIPTION_FILE"
    echo -e "\nMuseum of Rememes, $year" >> "$DESCRIPTION_FILE"

done
