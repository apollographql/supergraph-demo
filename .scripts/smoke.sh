#!/bin/bash

PORT="${1:-4000}"

echo Smoke test

sleep 2

CURL="curl -X POST -H \"Content-Type: application/json\" --data '{ \"query\": \"{ bestSellers { title } } \" }' http://localhost:$PORT/"

echo -------------------------------------------------------------------------------------------
echo $CURL
ACT=$(bash -c "$CURL")


EXP='{"data":{"bestSellers":[{"title":"Hello World"},{"title":"Hello World"}]}}'
echo $ACT
if [ "$ACT" = "$EXP" ]; then
    echo "Success!"
else
    echo "Error: query failed"
    echo " - got:$ACT"
    echo " - expecting:$EXP"
    echo -------------------------------------------------------------------------------------------
    exit 1
fi
echo -------------------------------------------------------------------------------------------
