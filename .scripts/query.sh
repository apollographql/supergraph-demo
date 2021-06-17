#!/bin/bash

PORT="${1:-4000}"

echo -------------------------------------------------------------------------------------------
(set -x; curl -X POST -H 'Content-Type: application/json' --data '{ "query": "{ bestSellers { title } } " }' http://localhost:$PORT/)
echo -------------------------------------------------------------------------------------------
