#!/bin/bash

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

graph=$1
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-ref.sh"
fi

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  (set -x; rover subgraph delete ${graph} --name ${subgraph})
done
