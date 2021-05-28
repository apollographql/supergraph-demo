#!/bin/bash 
 
source "$(dirname $0)/subgraphs.sh"

echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then copy your Graph ID and enter it at the prompt below."
read -p "> " graph
if [[ -z "$graph" ]]; then
    >&2 echo "Error: no graph ID specified."
    exit 1
fi

echo "rover subgraph check ${graph} --schema subgraphs/products.graphql --name products"
rover subgraph check ${graph} --schema subgraphs/products.graphql --name products