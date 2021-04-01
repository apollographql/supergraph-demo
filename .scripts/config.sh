#!/bin/bash

source "$(dirname $0)/services.sh"

echo "subgraphs:"
for service in ${services[@]}; do
  url="url_$service"
  echo "  ${service}:"
  echo "    routing_url: ${!url}"
  echo "    schema:"
  echo "      file: ./subgraphs/${service}.graphql"
done