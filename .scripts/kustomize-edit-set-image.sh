#!/bin/bash

PACKAGES=$(find . -name 'package.json')
for i in $PACKAGES; do
  DIR=$(dirname $i | sed 's|^./||')
  NAME=$(grep '"name":' $DIR/package.json | cut -d\" -f4)
  VERSION=$(grep '"version":' $DIR/package.json | cut -d\" -f4)

  # edit kustomization.yaml
  if [[ "$NAME" == "supergraph-router" ]]; then
    (cd k8s/router/dev; kustomize edit set image prasek/$NAME:latest=prasek/$NAME:$VERSION)
  else
    (cd k8s/subgraphs/dev; kustomize edit set image prasek/$NAME:latest=prasek/$NAME:$VERSION)
  fi

done
