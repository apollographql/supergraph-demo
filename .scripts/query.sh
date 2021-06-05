#!/bin/bash

PORT="${1:-4000}"

curl -X POST \
-H "Content-Type: application/json" \
--data '{ "query": "{ bestSellers { title } } " }' \
http://localhost:$PORT/
