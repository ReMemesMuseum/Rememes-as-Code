#!/bin/bash

# Define the directory to search for pngs
directory="./"  # Change this to your target directory if needed

# Find all .png files and convert them to .jpg in the same directory
find "$directory" -type f -name "*.png" | while read -r png_file; do
    # Extract the directory and base filename without the extension
    dir_name=$(dirname "$png_file")
    base_name=$(basename "$png_file" .png)
    
    # Convert png to JPG, saving it in the same directory
    magick "$png_file"[0] "${dir_name}/${base_name}.jpeg"
    
    echo "Converted: $png_file to ${dir_name}/${base_name}.jpeg"
done