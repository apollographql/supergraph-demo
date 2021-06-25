#!/bin/bash

PORT="${1:-4000}"
TESTS=(1 2)

# --------------------------------------------------------------------
# QUERY 1
# --------------------------------------------------------------------
read -r -d '' QUERY_1 <<"EOF"
{
  allProducts {
    delivery {
      estimatedDelivery,
      fastestDelivery
    },
    createdBy {
      name,
      email
    }
  }
}
EOF

read -r -d '' EXP_1 <<"EOF"
{"data":{"allProducts":[{"delivery":{"estimatedDelivery":"6/25/2021","fastestDelivery":"6/24/2021"},"createdBy":{"name":"Apollo Studio Support","email":"support@apollographql.com"}},{"delivery":{"estimatedDelivery":"6/25/2021","fastestDelivery":"6/24/2021"},"createdBy":{"name":"Apollo Studio Support","email":"support@apollographql.com"}}]}}
EOF

# --------------------------------------------------------------------
# QUERY 2
# --------------------------------------------------------------------
read -r -d '' QUERY_2 <<"EOF"
{
  allProducts {
    id,
    sku,
    createdBy {
      email,
      totalProductsCreated
    }
  }
}
EOF

read -r -d '' EXP_2 <<"EOF"
{"data":{"allProducts":[{"id":"apollo-federation","sku":"federation","createdBy":{"email":"support@apollographql.com","totalProductsCreated":1337}},{"id":"apollo-studio","sku":"studio","createdBy":{"email":"support@apollographql.com","totalProductsCreated":1337}}]}}
EOF

set -e

echo Running smoke tests ...
sleep 2

for test in ${TESTS[@]}; do
  echo ""
  echo -------------------------------------------------------------------------------------------
  echo TEST $test
  echo -------------------------------------------------------------------------------------------
  query_var="QUERY_$test"
  exp_var="EXP_$test"
  QUERY=$(echo "${!query_var}" | awk -v ORS= -v OFS= '{$1=$1}1')
  EXP="${!exp_var}"
  ACT=$(set -x; curl -X POST -H 'Content-Type: application/json' --data '{ "query": "'"${QUERY}"'" }' http://localhost:$PORT/)
  if [ "$ACT" = "$EXP" ]; then
      echo ""
      echo "Result:"
      echo "$ACT"
      echo ""
      echo "Success!"
  else
      echo -------------------------------------------------------------------------------------------
      echo "Error: query failed"
      echo -------------------------------------------------------------------------------------------
      echo "[Expected]"
      echo "$EXP"
      echo -------------------------------------------------------------------------------------------
      echo "$ACT"
      echo "[Actual]"
      echo -------------------------------------------------------------------------------------------
      echo "Error: query failed"
      echo -------------------------------------------------------------------------------------------
      exit 1
  fi
done
echo -------------------------------------------------------------------------------------------
echo Done!
