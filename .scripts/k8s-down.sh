#!/bin/bash

kubectl delete -f k8s/router.yaml
kind delete cluster
