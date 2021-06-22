#!/bin/bash

KUSTOMIZE_ENV="${1:-base}"

echo "Using ${KUSTOMIZE_ENV}/kustomization.yaml"

kind --version

if [ $(kind get clusters | grep -E 'kind') ]
then
  kind delete cluster --name kind
fi
kind create cluster --image kindest/node:v1.21.1 --config=k8s/clusters/kind-cluster.yaml --wait 5m

# important: use a newer kubectl version that supports extended kustomize resources
kubectl apply -k k8s/infra/$KUSTOMIZE_ENV

kubectl apply -k k8s/subgraphs/$KUSTOMIZE_ENV

echo waiting for nginx controller to start ...

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

retry=60
code=1
last=""
until [[ $retry -le 0 || $code -eq 0 ]]
do
  result=$(kubectl apply -k k8s/router/$KUSTOMIZE_ENV 2>/dev/null)
  code=$?

  if [[ "$result" != "$last" ]]
  then
    echo "$result"
  fi
  last=$result

  if [[ $code -eq 0 ]]
  then 
    exit $code
  fi

  ((retry--))
  echo waiting for nginx admission controller to start ...
  sleep 2
done

.scripts/k8s-nginx-dump.sh "timeout waiting for nginx admission controller to start"

.scripts/k8s-graph-dump.sh "timeout waiting for nginx admission controller to start"

exit $code
