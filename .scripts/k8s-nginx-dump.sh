#!/bin/bash

echo ===============================================================
echo "$1"
echo ===============================================================
kubectl get -n ingress-nginx all

echo ---------------------------------------------------------------
kubectl describe -n ingress-nginx deployment.apps/ingress-nginx-controller

echo ---------------------------------------------------------------
kubectl describe -n ingress-nginx pod

echo ---------------------------------------------------------------
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

echo ===============================================================
echo "$1"
echo ===============================================================

exit $code
