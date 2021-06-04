#!/bin/bash

PORT="${1:-4000}"

node index.js local $PORT &
sleep 2
ACT=`.scripts/query.sh $PORT`
EXP='{"data":{"bestSellers":[{"title":"Hello World"},{"title":"Hello World"}]}}'
echo $ACT
kill -9 `lsof -i:$PORT -t`
if [ "$ACT" = "$EXP" ]; then
    echo "Success!"
else
    echo "Error: query failed"
    echo " - got:$ACT"
    echo " - expecting:$EXP"
    exit 1
fi
