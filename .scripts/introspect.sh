#!/bin/bash

export GATEWAY_ENV="${GATEWAY_ENV:-Prod}"

source "$(dirname $0)/subgraphs.sh"

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  url="url_$subgraph"
  url=$(echo ${!url} | sed "s/%GATEWAY_ENV%/$GATEWAY_ENV/g")
  echo "rover subgraph introspect ${url} > subgraphs/${subgraph}.graphql"
  rover subgraph introspect ${url} > subgraphs/${subgraph}.graphql
done
