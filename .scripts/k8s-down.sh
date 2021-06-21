#!/bin/bash

# just delete the cluster
#kubectl delete -k k8s/router/base
#kubectl delete -k k8s/subgraphs/base
#kubectl delete -k k8s/infra/base
kind delete cluster
