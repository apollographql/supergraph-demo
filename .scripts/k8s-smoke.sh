#!/bin/bash

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
exit $code
