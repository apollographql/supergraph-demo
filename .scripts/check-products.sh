#!/bin/bash 
 
echo "======================================="
echo "SUBGRAPH CHECK"
echo "======================================="

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/graph-api-env.sh"

echo "---------------------------------------"
echo "subgraph: products"
echo "---------------------------------------"
( set -x; ${ROVER_BIN:-'rover'} subgraph check ${APOLLO_GRAPH_REF} --schema subgraphs/products/products.graphql --name products )
