#!/bin/bash

retry=60
code=1
until [[ $retry -le 0 || $code -eq 0 ]]
do
  kubectl get all
  .scripts/smoke.sh 80

  code=$?

  if [[ $code -eq 0 ]]
  then
    exit $code
  fi

  ((retry--))
  sleep 2
done

.scripts/k8s-nginx-dump.sh "smoke test failed"

.scripts/k8s-graph-dump.sh "smoke test failed"

exit $code
