#!/bin/bash 
 
source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

graph=$1
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-id.sh"
fi

echo "rover subgraph check ${graph} --schema subgraphs/products.graphql --name products"
rover subgraph check ${graph} --schema subgraphs/products.graphql --name products
