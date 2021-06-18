#!/bin/bash 

source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

graph=$1
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-ref.sh"
fi

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  url="url_$subgraph"
  (set -x; rover subgraph publish ${graph} --routing-url "${!url}" --schema subgraphs/${subgraph}/${subgraph}.graphql --name ${subgraph} --convert)
done
