#!/bin/bash

PORT="${1:-4000}"

echo -------------------------------------------------------------------------------------------
(set -x; curl -X POST -H 'Content-Type: application/json' --data '{ "query": "{ allProducts { id, sku, createdBy { email, totalProductsCreated } } }" }' http://localhost:$PORT/)
echo -------------------------------------------------------------------------------------------
