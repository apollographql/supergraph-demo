#!/bin/bash

# inputs from .scripts/build-matrix.sh
MATRIX=$1

echo "PACKAGE_BUMP_PR_MSG<<EOF"
echo "Bump package versions:"

for k in $(jq -c ' .include | .[] | values ' <<< "$MATRIX" ); do
  DIR=$(echo "$k" | jq -r '.dir')
  NAME=$(echo "$k" | jq -r '.name')
  OLD_VERSION=$(echo "$k" | jq -r '.versionOld')
  NEW_VERSION=$(echo "$k" | jq -r '.versionNew')
  CHANGES=$(echo "$k" | jq -r '.changes')

  # bump package.json
  if [[ "$CHANGES" == "1" ]]; then
    echo "* Bump ${NAME} package from ${OLD_VERSION} -> ${NEW_VERSION} 🚀"
    ( set -x; cd $DIR; >&2 npm version --git-tag-version=false v${NEW_VERSION} )
  fi
done

echo "EOF"
