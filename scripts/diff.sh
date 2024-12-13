#!/bin/bash

# Base directory where token data is stored
BASE_DIR="."

for TOKEN_ID in $(seq $1 $2); do

	# Path to the tmp/tt.txt file
	tmp_file="$BASE_DIR/$TOKEN_ID/tmp/tt.txt"

	# Path to the token's tt.txt file
	token_file="$BASE_DIR/$TOKEN_ID/tt.txt"

	# Count the number of characters in tmp/tt.txt
	tmp_chars=$(wc -l < "$tmp_file")

	# Count the number of characters in $BASE_DIR/$TOKEN_ID/tt.txt
	token_chars=$(wc -l < "$token_file")

	# Calculate the difference
	diff=$((token_chars - tmp_chars))

	echo "For $TOKEN_ID difference is $diff"

done