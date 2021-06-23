#!/bin/bash

if ls graph-api.env > /dev/null 2>&1; then
  eval "$(cat graph-api.env)"
fi

echo -------------------------------------------------------------------------------------------
echo Enter your Graph API Key
echo -------------------------------------------------------------------------------------------
echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then create a Graph API Key with Contributor permissions"
echo "(for metrics reporting) and enter it at the prompt below."

if [[ -n "$APOLLO_KEY" ]]; then
  echo ""
  echo "press <enter> to use existing key: *************** (from ./graph-api.env)"
fi

read -s -p "> " key
echo
if [[ -z "$key" ]]; then
  if [[ -n "$APOLLO_KEY" ]]; then
    key=$APOLLO_KEY
  else
    >&2 echo "Error: no key specified."
    exit 1
  fi
fi

echo "APOLLO_KEY=${key}" > graph-api.env

# --------------------------------------------------------------------------
# APOLLO_GRAPH_REF
# --------------------------------------------------------------------------
echo ""
if [[ -z "${graph}" ]]; then
  source "$(dirname $0)/get-graph-ref.sh"
fi

echo "APOLLO_GRAPH_REF=${graph}" >> graph-api.env
