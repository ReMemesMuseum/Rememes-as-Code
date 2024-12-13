#!/bin/bash

# Base directory where token data is stored
BASE_DIR="."

# Loop through each token directory from 1 to 280
for TOKEN_ID in $(seq $1 $2); do

    # Path to the text file for the current token
    text_file="$BASE_DIR/$TOKEN_ID/cleaned_file.txt"
    n=$3 # default 100

    # Check if the cleaned_file.txt exists for the current token
    if [ ! -f "$text_file" ]; then
        echo "Error: File '$text_file' does not exist for token $TOKEN_ID."
        continue
    fi

    # Create a new result file in the current token's directory
    output_file="$BASE_DIR/$TOKEN_ID/result.txt"

    # Clear the contents of output_file if it exists
    > "$output_file"

    # Get the total number of words in the cleaned_file.txt
    num_words=$(wc -w < "$text_file")

    # Initialize the current word counter
    current_word=1

    # Loop through all the words in the cleaned_file.txt
    while [ $current_word -le $num_words ]; do
        # Generate a random number between n and 2n
        random_number=$(shuf -i $n-$((2 * n)) -n 1)
        
        # Generate a random string using pwgen based on the random number
        random_text=$(pwgen -N 1 -c -n -B -s -r -s -1 "$random_number")
        
        # Append the random string to the output_file
        echo "$random_text" >> "$output_file"
        
        # Get the current word from the cleaned_file.txt
        word=$(awk -v var="$current_word" '{print $var}' "$text_file")
        
        # Append the current word to the output_file
        echo "$word" >> "$output_file"
        
        # Increment the current word counter
        ((current_word++))
    done
    # Generate a random number between n and 2n
    random_number=$(shuf -i $n-$((2 * n)) -n 1)
    
    # Generate a random string using pwgen based on the random number
    random_text=$(pwgen -N 1 -c -n -B -s -r -s -1 "$random_number")
    echo "$random_text" >> "$output_file"

    # Notify that the result has been written to the output_file
    echo "Result written to: $output_file for token $TOKEN_ID"

    # Output the number of characters in the result file
    echo "Number of characters in the result file for token $TOKEN_ID:" `wc -m < "$output_file"`

    # Modify the output file by removing spaces and replacing empty lines with '#'
    cat "$output_file" | tr -d ' ' | sed 's/./&\n/g' | sed '/^$/s//#/g' > "$BASE_DIR/$TOKEN_ID/tt.txt"

done

echo "Processing completed for all tokens from $1 to $2"
