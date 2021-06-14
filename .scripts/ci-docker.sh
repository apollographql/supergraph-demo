#!/bin/bash

export GATEWAY_PORT="${GATEWAY_PORT:-4000}"
export GATEWAY_ENV="${GATEWAY_ENV:-Prod}"
export GATEWAY_SUPERGRAPH_SDL="${GATEWAY_SUPERGRAPH_SDL:-supergraph.graphql}"

docker run --rm -d --name=gateway -p $GATEWAY_PORT:4000 --env GATEWAY_ENV --env GATEWAY_SUPERGRAPH_SDL my/supergraph-demo
sleep 2
docker logs gateway
.scripts/smoke.sh $GATEWAY_PORT
EXIT=$?
docker kill gateway
exit $EXIT
