#!/bin/bash 
 
source "$(dirname $0)/subgraphs.sh"
source "$(dirname $0)/get-env.sh"

graph=$1
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-ref.sh"
fi

( set -x; rover subgraph check ${graph} --schema subgraphs/products/products.graphql --name products )
