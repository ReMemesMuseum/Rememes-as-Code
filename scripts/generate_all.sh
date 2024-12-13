#!/bin/bash

if [ -z "$2" ]; then
    set -- "$1" "$1"  # Set $2 to be equal to $1
fi

# Loop from $1 to $2
for (( i=$1; i<=$2; i++ )); do
    ./j2s "$i"
    echo "Processing complete for $i"
done
