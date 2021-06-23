#!/bin/bash 

if ls graph-api.env > /dev/null 2>&1; then
  eval "$(cat graph-api.env)"
fi

if [[ -z "${APOLLO_KEY}" || -z "${APOLLO_GRAPH_REF}" ]]; then
  source "$(dirname $0)/graph-api-env.sh"
  eval "$(cat graph-api.env)"

  if [[ -z "${APOLLO_KEY}" ]]; then
    echo -------------------------------------------------------------------------------------------
    echo APOLLO_KEY not found, run: make graph-api-env
    echo -------------------------------------------------------------------------------------------
    exit 1
  fi

  if [[ -z "${APOLLO_GRAPH_REF}" ]]; then
    echo -------------------------------------------------------------------------------------------
    echo APOLLO_GRAPH_REF not found, run: make graph-api-env
    echo -------------------------------------------------------------------------------------------
    exit 1
  fi
fi

export APOLLO_KEY=$APOLLO_KEY
export APOLLO_GRAPH_REF=$APOLLO_GRAPH_REF
