#!/bin/bash 

set -e

( set -x; ${ROVER_BIN:-'rover'} supergraph compose --config ./supergraph.yaml > ./supergraph.graphql)
cp supergraph.graphql k8s/router/base
cp supergraph.graphql k8s/router/dev
