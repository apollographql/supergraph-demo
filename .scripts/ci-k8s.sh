#!/bin/bash

kind --version

if [ $(kind get clusters | grep -E 'kind') ]
then
	kind delete cluster --name kind
fi
kind create cluster --image kindest/node:v1.19.7 --config=k8s/cluster.yaml --wait 5m
kubectl apply -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-crds.yaml
kubectl apply -n ambassador -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-kind.yaml
kubectl wait --timeout=180s -n ambassador --for=condition=deployed ambassadorinstallations/ambassador
kubectl apply -f k8s/router.yaml

retry=60
code=1
until [ $retry -le 0 ] || [ $code -eq 0 ]
do
  kubectl get all
  .scripts/smoke.sh 80
  code=$?
  ((retry--))
  sleep 2
done

kubectl delete -f k8s/router.yaml
kind delete cluster
exit $code
