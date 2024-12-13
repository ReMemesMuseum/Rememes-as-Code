#!/bin/bash

# Base directory where token data is stored
BASE_DIR="."

for TOKEN_ID in $(seq $1 $2); do
    # Default value of n
    n=145
    # Path to the tmp/tt.txt file
    tmp_file="$BASE_DIR/$TOKEN_ID/tmp/tt.txt"

    # Path to the token's tt.txt file
    token_file="$BASE_DIR/$TOKEN_ID/tt.txt"

    # Check if both files exist
    if [ ! -f "$tmp_file" ]; then
        echo "Error: File '$tmp_file' does not exist."
        exit 1
    fi

    if [ ! -f "$token_file" ]; then
        echo "Error: File '$token_file' does not exist for token $TOKEN_ID."
        continue
    fi

    # Count the number of characters in tmp/tt.txt
    tmp_chars=$(wc -l < "$tmp_file")

    # Count the number of characters in $BASE_DIR/$TOKEN_ID/tt.txt
    token_chars=$(wc -l < "$token_file")

    # Calculate the difference
    diff=$((token_chars - tmp_chars))

    
    while [ $diff -gt 1 ]; do
        n=$((n - $3))  # Decrease n by 10
        bash generate_insert.sh $TOKEN_ID $TOKEN_ID $n
        token_chars=$(wc -l < "$token_file")
        echo $token_chars
        echo $tmp_chars
        if [ $n -le 0 ]; then
            echo "Error: Value of n has reached or passed 0, stopping."
            exit 1
        fi
        diff=$((token_chars - tmp_chars))  # Recalculate diff
        echo "Reducing n to $n. Difference is $diff."

        if [ "$diff" -ge -800 ] && [ "$diff" -le 0 ]; then
            echo "Warning: Difference is less than 0"
            ndiff=$(( -diff ))
            random_string=$(tr -dc 'a-zA-Z' </dev/urandom | head -c $ndiff)
            echo "$random_string" | sed 's/./&\n/g' | sed '/^$/s//#/g' >> "$BASE_DIR/$TOKEN_ID/tt.txt"
            token_chars=$(wc -l < "$token_file")
            diff=$((token_chars - tmp_chars)) 
            echo "Add random_string for $TOKEN_ID. Difference is $diff."

        fi

        # If diff becomes negative, increase n by $3+2
        if [ $diff -lt -800 ]; then
            echo "Warning: Difference is less than 0. Increasing n by $3+2."
            n=$((n + $3+2))
            bash generate_insert.sh $TOKEN_ID $TOKEN_ID $n
            token_chars=$(wc -l < "$token_file")
            diff=$((token_chars - tmp_chars)) 
            echo "Reducing n to $n. Difference is $diff."

        fi

        if [ "$diff" -ge -800 ] && [ "$diff" -le 0 ]; then
            echo "Warning: Difference is less than 0"
            ndiff=$(( -diff ))
            random_string=$(tr -dc 'a-zA-Z' </dev/urandom | head -c $ndiff)
            echo "$random_string" | sed 's/./&\n/g' | sed '/^$/s//#/g' >> "$BASE_DIR/$TOKEN_ID/tt.txt"
            token_chars=$(wc -l < "$token_file")
            diff=$((token_chars - tmp_chars)) 
            echo "Add random_string for $TOKEN_ID. Difference is $diff."

        fi

    done

    echo "For token $TOKEN_ID: Final n is $n."

done
