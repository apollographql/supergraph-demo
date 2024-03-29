#!/bin/bash 

echo "======================================="
echo "PUBLISH SUBGRAPHS TO APOLLO REGISTRY"
echo "======================================="

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/graph-api-env.sh"

# note: use --allow-invalid-routing-url to allow localhost without confirmation prompt

for subgraph in ${subgraphs[@]}; do
  echo "---------------------------------------"
  echo "subgraph: ${subgraph}"
  echo "---------------------------------------"
  url="url_$subgraph"
  schema="subgraphs/$subgraph/$subgraph.graphql"
  (set -x; ${ROVER_BIN:-'rover'} subgraph publish ${APOLLO_GRAPH_REF} \
    --routing-url "${!url}" \
    --schema "${schema}" \
    --name ${subgraph} \
    --allow-invalid-routing-url \
    --convert)
  echo ""
done
