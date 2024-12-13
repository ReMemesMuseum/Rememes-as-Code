#!/bin/bash

cd ./crop

# List all files in the current directory matching the pattern
files=(output-*.jpg)

# Check if there are enough files to create groups
if [ "${#files[@]}" -lt 4 ]; then
    echo "Error: Not enough files to create groups."
    exit 1
fi

# Create the output directory if it doesn't exist
output_dir="2x2"
mkdir -p "$output_dir"

# Shuffle files to randomize grouping
shuf_files=($(shuf -e "${files[@]}"))

# Define the group size
group_size=4
# Calculate the number of groups (round up if necessary)
num_groups=$(((${#shuf_files[@]} + group_size - 1) / group_size))

for ((i=0; i<num_groups; i++)); do
    # Extract the current group of files
    group=("${shuf_files[@]:$((i * group_size)):group_size}")
    
    # Extract numbers from file names to create the output file name
    group_numbers=$(printf "%s\n" "${group[@]}" | grep -oP '\d+' | tr '\n' '-' | sed 's/-$//')
    
    # Define the output file path
    output_file="${output_dir}/group-${group_numbers}.jpg"
    
    # Combine the files in the group into a collage
    montage "${group[@]}" -tile 2x2 -geometry +0+0 "$output_file"
    echo "Created file $output_file"
done
