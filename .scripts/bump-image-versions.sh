#!/bin/bash

# inputs from .scripts/build-matrix.sh
MATRIX=$1
ROOT_DIR=${2:-"./k8s/"}

echo "IMAGE_BUMP_PR_MSG<<EOF"
echo "Bump docker image versions:"

for k in $(jq -c ' .include | .[] | values ' <<< "$MATRIX" ); do
  DIR=$(echo "$k" | jq -r '.dir')
  NAME=$(echo "$k" | jq -r '.name')
  OLD_VERSION=$(echo "$k" | jq -r '.versionOld')
  NEW_VERSION=$(echo "$k" | jq -r '.versionNew')
  CHANGES=$(echo "$k" | jq -r '.changes')

  # edit kustomization.yaml
  if [[ "$CHANGES" == "1" ]]; then
    echo "* Bump ${NAME} docker image from ${OLD_VERSION} -> ${NEW_VERSION} 🚀"
    if [[ "$NAME" == "supergraph-router" ]]; then
      (set -x; cd ${ROOT_DIR}router/dev; kustomize edit set image prasek/$NAME:latest=prasek/$NAME:$NEW_VERSION)
    else
      (set -x; cd ${ROOT_DIR}subgraphs/dev; kustomize edit set image prasek/$NAME:latest=prasek/$NAME:$NEW_VERSION)
    fi
  fi
done

echo "EOF"

