#!/bin/bash

source "$(dirname $0)/services.sh"

echo "subgraphs:"
for service in ${services[@]}; do
  url="url_$service"
  echo "rover subgraph publish supergraph-demo --routing-url ${!url} --schema subgraphs/${service}.graphql --name ${service}"
  rover subgraph publish supergraph-demo --routing-url ${!url} --schema subgraphs/${service}.graphql --name ${service}
done