#!/bin/bash

set -e

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

graph=$1
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-id.sh"
fi

echo "checking all subgraphs:"
for subgraph in ${subgraphs[@]}; do
  echo "rover subgraph check ${graph} --schema subgraphs/$subgraph.graphql --name $subgraph"
  rover subgraph check ${graph} --schema subgraphs/$subgraph.graphql --name $subgraph
done
