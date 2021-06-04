#!/bin/bash

PORT="${1:-4000}"

node index.js local $PORT &
.scripts/smoke.sh $PORT
EXIT=$?
kill -9 `lsof -i:$PORT -t`
exit $EXIT
