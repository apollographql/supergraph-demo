#!/bin/bash

export GATEWAY_PORT="${GATEWAY_PORT:-4000}"

docker run --rm -d --name=gateway -p $GATEWAY_PORT:4000 my/supergraph-demo
sleep 2
docker logs gateway
.scripts/smoke.sh $GATEWAY_PORT
EXIT=$?
docker kill gateway
exit $EXIT
