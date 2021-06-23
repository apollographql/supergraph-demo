#!/bin/bash 
 
echo -------------------------------------------------------------------------------------------
echo "Graph Ref"
echo -------------------------------------------------------------------------------------------
echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then copy your Graph NAME and optionally @<VARIANT> and enter it at the prompt below."
echo "@<VARIANT> will default to @current, if omitted."
echo ""
echo "Enter the <NAME>@<VARIANT> of a federated graph in Apollo Studio:"
if [[ -n "$APOLLO_GRAPH_REF" ]]; then
  echo ""
  echo "press <enter> for default: $APOLLO_GRAPH_REF"
fi
read -p "> " graph
if [[ -z "$graph" ]]; then
  if [[ -n "$APOLLO_GRAPH_REF" ]]; then
    graph=$APOLLO_GRAPH_REF
  else
    >&2 echo "Error: no graph ref specified."
    exit 1
  fi
fi

export graph=$graph
