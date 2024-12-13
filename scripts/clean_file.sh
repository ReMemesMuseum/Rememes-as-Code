#!/bin/bash

# Set the base directory where token folders are located
BASE_DIR="."

# Get the current date in YYYY-MM-DD format
CURRENT_DATE=$(date +"%Y-%m-%d")

# Loop through token directories from 1 to n
for TOKEN_ID in $(seq $1 $2); do
    # Define the path to the text.txt file for the current token
    file="$BASE_DIR/$TOKEN_ID/text.txt"

    # Check if the text.txt file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist for Token ID $TOKEN_ID."
        continue
    fi

    # Create the path for the temporary cleaned file
    temp_file="$BASE_DIR/$TOKEN_ID/cleaned_file.txt"

    # Clean the contents of the text.txt file by removing special characters and spaces
    sed 's/[^a-zA-Zа-яА-Я0-9 \n]/ /g' "$file" | tr -s '[:space:]' '\n' | sed 's/\<value\>\|\<trait\>\|\<type\>//gI' > "$temp_file"

    # Create or clear the hexkey file with the current date in the file name
    hexkey_file="$BASE_DIR/$TOKEN_ID/hexkey_$CURRENT_DATE.txt"
    > "$hexkey_file"

    python generate_wallet.py >> "$hexkey_file"
    cat "$hexkey_file" | cut -d "," -f2 >> "$temp_file"

    # Shuffle the contents of the cleaned_file.txt and store the result in cleaned.tmp
    shuf "$temp_file" -o "$BASE_DIR/$TOKEN_ID/cleaned.tmp"

    # Format the shuffled contents into a single line and save it back to cleaned_file.txt
    awk '{ printf "%s ", $1 } END { printf "\n" }' "$BASE_DIR/$TOKEN_ID/cleaned.tmp" | tr -s ' ' > "$temp_file"

    # Randomly select 5 lines from hexkey_file and store in hexkey_selected_$CURRENT_DATE.csv
    hexkey_selected_file="$BASE_DIR/$TOKEN_ID/hexkey_selected_$CURRENT_DATE.csv"
    shuf -n 5 "$hexkey_file" > "$hexkey_selected_file"

    # Output the selected hex keys for verification
    echo "Selected 5 hex keys for Token ID $TOKEN_ID (stored in hexkey_selected_$CURRENT_DATE.csv):"
done

echo "Processing complete for all tokens."
