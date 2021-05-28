#!/bin/bash

source "$(dirname $0)/subgraphs.sh"

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  url="url_$subgraph"
  echo "rover subgraph introspect ${!url} > subgraphs/${subgraph}.graphql"
  rover subgraph introspect ${!url} > subgraphs/${subgraph}.graphql
done