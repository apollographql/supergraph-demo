#!/bin/bash

PORT="${1:-4000}"

sleep 2
echo Smoke test
ACT=`.scripts/query.sh $PORT`
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
