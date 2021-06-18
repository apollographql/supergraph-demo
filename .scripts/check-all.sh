#!/bin/bash

set -e

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

graph=$1
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-ref.sh"
fi

echo "checking all subgraphs:"
for subgraph in ${subgraphs[@]}; do
  (set -x; rover subgraph check ${graph} --schema subgraphs/${subgraph}/${subgraph}.graphql --name $subgraph)
done
