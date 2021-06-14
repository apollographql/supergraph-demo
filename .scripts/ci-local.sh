#!/bin/bash

export GATEWAY_PORT="${GATEWAY_PORT:-4000}"
export GATEWAY_ENV="${GATEWAY_ENV:-Prod}"
export GATEWAY_SUPERGRAPH_SDL="${GATEWAY_SUPERGRAPH_SDL:-supergraph.graphql}"

node index.js &
.scripts/smoke.sh $GATEWAY_PORT
EXIT=$?
kill -9 `lsof -i:$GATEWAY_PORT -t`
exit $EXIT
