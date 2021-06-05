#!/bin/bash

PORT="${1:-4000}"

docker run --rm -d --name=gateway -p $PORT:4000 my/supergraph-demo
sleep 2
docker logs gateway
.scripts/smoke.sh $PORT
EXIT=$?
docker kill gateway
exit $EXIT
