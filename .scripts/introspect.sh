#!/bin/bash

source "$(dirname $0)/services.sh"

echo "subgraphs:"
for service in ${services[@]}; do
  url="url_$service"
  echo "rover subgraph introspect ${!url} > subgraphs/${service}.graphql"
  rover subgraph introspect ${!url} > subgraphs/${service}.graphql
done