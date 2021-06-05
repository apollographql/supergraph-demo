#!/bin/bash 
 
eval "$(cat graph-api.env)"
if [[ -z "${APOLLO_KEY}" ]]; then
  source "$(dirname $0)/graph-api-env.sh"
  eval "$(cat graph-api.env)"

  if [[ -z "${APOLLO_KEY}" ]]; then
    echo -------------------------------------------------------------------------------------------
    echo environment keyfile required, run: make graph-api-key
    echo -------------------------------------------------------------------------------------------
    exit 1
  fi
fi

export APOLLO_KEY=$APOLLO_KEY
