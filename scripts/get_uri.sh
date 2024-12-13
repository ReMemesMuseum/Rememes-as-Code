#!/bin/bash

# Your Alchemy API key
ALCHEMY_API_KEY="key"
CONTRACT_ADDRESS="0x33fd426905f149f8376e227d0c9d3340aad17af1"

# Loop from 1 to 280 to get token URIs
for TOKEN_ID in $(seq $1 $2); do
    # URL for the request
    URL="https://eth-mainnet.alchemyapi.io/v2/$ALCHEMY_API_KEY/getNFTMetadata"

    # Execute the request and get the response
    response=$(curl -s -X GET "$URL?contractAddress=$CONTRACT_ADDRESS&tokenId=$TOKEN_ID")

    # Create a directory for the current token
    mkdir -p "$TOKEN_ID"

    # Write the full response to the file uri.txt
    echo "$response" > "$TOKEN_ID/uri.txt"

    # Output the response for diagnostics
    echo "Raw Response for Token ID $TOKEN_ID: $response"
    sleep 2
done

echo "Recording completed."
