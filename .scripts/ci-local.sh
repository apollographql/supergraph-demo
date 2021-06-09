#!/bin/bash

export GATEWAY_PORT="${GATEWAY_PORT:-4000}"

node index.js supergraph.graphql &
.scripts/smoke.sh $GATEWAY_PORT
EXIT=$?
kill -9 `lsof -i:$GATEWAY_PORT -t`
exit $EXIT
