#!/bin/bash
set -x;
kubectl kustomize ./ > ./k8s/router.yaml
