#!/bin/bash 
 
source "$(dirname $0)/subgraphs.sh"

echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then copy your Graph ID and enter it at the prompt below."
read -p "> " graph
if [[ -z "$graph" ]]; then
    >&2 echo "Error: no graph ID specified."
    exit 1
fi

echo "subgraphs:"
for subgraph in ${subgraphs[@]}; do
  url="url_$subgraph"
  echo "rover subgraph publish ${graph} --routing-url ${!url} --schema subgraphs/${subgraph}.graphql --name ${subgraph}"
  rover subgraph publish ${graph} --routing-url ${!url} --schema subgraphs/${subgraph}.graphql --name ${subgraph}
done