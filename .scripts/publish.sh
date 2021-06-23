#!/bin/bash 

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

if [[ "$1" == "default" ]]; then
  if [[ -n $APOLLO_GRAPH_REF ]]; then
    graph=$APOLLO_GRAPH_REF
    echo -------------------------------------------------------------------------------------------
    echo "using: ${graph}"
    echo -------------------------------------------------------------------------------------------
  fi
fi

if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-ref.sh"
fi

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  url="url_$subgraph"
  (set -x; ${ROVER_BIN:-'rover'} subgraph publish ${graph} --routing-url "${!url}" --schema subgraphs/${subgraph}/${subgraph}.graphql --name ${subgraph} --convert)
done
