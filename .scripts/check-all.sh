#!/bin/bash

set -e

echo "======================================="
echo "SUBGRAPH CHECK"
echo "======================================="

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/graph-api-env.sh"

echo "checking all subgraphs:"
for subgraph in ${subgraphs[@]}; do
  echo "---------------------------------------"
  echo "subgraph: ${subgraph}"
  echo "---------------------------------------"
  (set -x; ${ROVER_BIN:-'rover'} subgraph check ${APOLLO_GRAPH_REF} --schema subgraphs/${subgraph}/${subgraph}.graphql --name $subgraph)
done
