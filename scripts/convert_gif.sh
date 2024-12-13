#!/bin/bash

# Define the directory to search for GIFs
directory="./"  

# Find all .gif files and convert them to .jpg in the same directory
find "$directory" -type f -name "*.gif" | while read -r gif_file; do
    # Extract the directory and base filename without the extension
    dir_name=$(dirname "$gif_file")
    base_name=$(basename "$gif_file" .gif)
    
    # Convert GIF to JPG, saving it in the same directory
    magick "$gif_file"[0] "${dir_name}/${base_name}.jpeg"
    
    echo "Converted: $gif_file to ${dir_name}/${base_name}.jpeg"
done

