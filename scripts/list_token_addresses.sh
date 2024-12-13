#!/bin/bash

# Path to the main directory where token folders are located
base_dir="."

# Output file
output_file="allowedAddresses.txt"

# Clear the output file if it exists
> "$output_file"

# Loop through all subdirectories (token folders)
for dir in "$base_dir"/*/; do
  # Extract the directory name (this is the token number)
  token_number=$(basename "$dir")

  # Check if there is a file named hexkey_selected* in the folder
  file=$(find "$dir" -name "hexkey_selected*")

  # If the file is found
  if [[ -f "$file" ]]; then
    # Read the contents of the file and output the address and token number
    while IFS=, read -r address key; do
      # Append the result to the output file
      echo "$address,$token_number" >> "$output_file"
    done < "$file"
  fi
done

# Sort the output file by token number and overwrite the file with the sorted result
sort -t',' -k2,2n "$output_file" -o "$output_file"

