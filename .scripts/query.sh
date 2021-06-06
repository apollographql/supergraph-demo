#!/bin/bash

PORT="${1:-4000}"

CURL="curl -X POST -H \"Content-Type: application/json\" --data '{ \"query\": \"{ bestSellers { title } } \" }' http://localhost:$PORT/"

echo -------------------------------------------------------------------------------------------
echo $CURL
bash -c "$CURL"
echo -------------------------------------------------------------------------------------------
