#!/bin/bash

curl \
-X POST \
-H "Content-Type: application/json" \
--data '{ "query": "{ bestSellers { title } } " }' \
http://$(node -p "require('ip').address()"):4000/ 