#!/bin/bash

PORT="${1:-4000}"

echo Smoke test

sleep 2

ACT=`curl -X POST \
-H "Content-Type: application/json" \
--data '{ "query": "{ bestSellers { title } } " }' \
http://localhost:$PORT/`

EXP='{"data":{"bestSellers":[{"title":"Hello World"},{"title":"Hello World"}]}}'
echo $ACT
if [ "$ACT" = "$EXP" ]; then
    echo "Success!"
else
    echo "Error: query failed"
    echo " - got:$ACT"
    echo " - expecting:$EXP"
    exit 1
fi
