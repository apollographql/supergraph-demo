#!/bin/bash

node index.js local &
sleep 2
ACT=`.scripts/query.sh`
EXP='{"data":{"bestSellers":[{"title":"Hello World"},{"title":"Hello World"}]}}'
echo $ACT
kill -9 `lsof -i:4000 -t`
if [ "$ACT" = "$EXP" ]; then
    echo "Success!"
else
    echo "Error: query failed"
    echo " - got:$ACT"
    echo " - expecting:$EXP"
    exit 1
fi
