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
