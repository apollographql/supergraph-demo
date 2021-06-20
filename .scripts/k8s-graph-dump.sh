#!/bin/bash

echo ===============================================================
echo "$1"
echo ===============================================================
kubectl get all
kubectl get ingress

echo ---------------------------------------------------------------
kubectl describe deployment.apps/router-deployment
echo ---------------------------------------------------------------
kubectl describe deployment.apps/inventory
echo ---------------------------------------------------------------
kubectl describe deployment.apps/products
echo ---------------------------------------------------------------
kubectl describe deployment.apps/users

echo ---------------------------------------------------------------
kubectl describe pod

echo ---------------------------------------------------------------
kubectl logs -l app=subgraph-users
echo ---------------------------------------------------------------
kubectl logs -l app=subgraph-inventory
echo ---------------------------------------------------------------
kubectl logs -l app=subgraph-products
echo ---------------------------------------------------------------
kubectl logs -l app=router

echo ===============================================================
echo "$1"
echo ===============================================================

exit $code
