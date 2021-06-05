#!/bin/bash 
 
source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"
source "$(dirname $0)/get-graph-id.sh"

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  url="url_$subgraph"
  echo "rover subgraph publish ${graph} --routing-url ${!url} --schema subgraphs/${subgraph}.graphql --name ${subgraph}"
  rover subgraph publish ${graph} --routing-url ${!url} --schema subgraphs/${subgraph}.graphql --name ${subgraph}
done
