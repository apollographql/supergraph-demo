#!/bin/bash

GITHUB_SHA="${GITHUB_SHA:-HEAD}"

if [[ "$1" != "local" ]]; then
  GITHUB_EVENT_BEFORE=${GITHUB_EVENT_BEFORE:-HEAD^}
fi

FORCE_VERSION_BUMP=$2

# for dynamic build matrix in GitHub actions, see:
# https://github.community/t/check-pushed-file-changes-with-git-diff-tree-in-github-actions/17220/10

if [[ -n "$GITHUB_BASE_REF" ]]; then
  # Pull Request
  >&2 echo "fetching GITHUB_BASE_REF: $GITHUB_BASE_REF"
  git fetch origin $GITHUB_BASE_REF --depth=1
else
  # Push
  if [[ -n "$GITHUB_EVENT_BEFORE" ]]; then
    # only fetch in CI if not present
    if [[ "$(git cat-file -t $GITHUB_EVENT_BEFORE)" != "commit" ]]; then
      >&2 echo "fetching GITHUB_EVENT_BEFORE: $GITHUB_EVENT_BEFORE"
      git fetch origin $GITHUB_EVENT_BEFORE --depth=1
    fi
  fi

  >&2 echo "found GITHUB_EVENT_BEFORE: $GITHUB_EVENT_BEFORE"
  >&2 echo "found GITHUB_SHA: $GITHUB_SHA"
fi

function diff_name_only() {
  if [[ -n "$GITHUB_BASE_REF" ]]; then
    # Pull Request
    git diff --name-only origin/$GITHUB_BASE_REF $GITHUB_SHA $1
  else
    # Push
    git diff --name-only $GITHUB_EVENT_BEFORE $GITHUB_SHA $1
  fi
}

WORKDIR=$(pwd)
TMPFILE=$(mktemp)

cat >$TMPFILE <<EOF
{
  "include": [
EOF

PACKAGES=$(find . -name 'package.json')
for package in $PACKAGES; do
  DIR=$(dirname $package | sed 's|^./||')
  NAME=$(grep '"name":' $DIR/package.json | cut -d\" -f4)
  OLD_VERSION=$(grep '"version":' $DIR/package.json | cut -d\" -f4)
  DIFF=$( diff_name_only "./$DIR")

  >&2 echo "------------------------------"
  >&2 echo "$DIR changes"
  >&2 echo "------------------------------"
  if [[ -n "$DIFF" || "$FORCE_VERSION_BUMP" == "force-version-bump" ]];  then
    >&2 echo "$DIFF"
    (cd $DIR; cp package.json package.json.bak)
    NEW_VERSION=$(cd $DIR; npm version --git-tag-version=false patch | sed 's|^v||')
    (cd $DIR; rm package.json; mv package.json.bak package.json)
    CHANGES=1
  else
    NEW_VERSION=$OLD_VERSION
    CHANGES=0
  fi

cat >>$TMPFILE <<EOF
  {
    "name": "$NAME",
    "dir": "$DIR",
    "versionOld": "$OLD_VERSION",
    "versionNew": "$NEW_VERSION",
    "changes": "$CHANGES"
  },
EOF

done

JSON="$(cat $TMPFILE)"

# remove trailing ','
if [[ $JSON == *, ]]; then
  JSON="${JSON%?}]}"
else
  JSON="${JSON}]}"
fi

echo $JSON

rm $TMPFILE
