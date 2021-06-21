#!/bin/bash

GITHUB_SHA="${GITHUB_SHA:-HEAD}"

if [[ "$1" != "local" ]]; then
  GITHUB_EVENT_BEFORE=${GITHUB_EVENT_BEFORE:-HEAD^}
fi

if [[ -n "$GITHUB_EVENT_BEFORE" ]]; then
  # only fetch in CI if not present
  if [[ "$(git cat-file -t $GITHUB_EVENT_BEFORE)" != "commit" ]]; then
    >&2 echo "fetching GITHUB_EVENT_BEFORE: $GITHUB_EVENT_BEFORE"
    git fetch origin $GITHUB_EVENT_BEFORE --depth=1
  fi
fi

>&2 echo "found GITHUB_EVENT_BEFORE: $GITHUB_EVENT_BEFORE"
>&2 echo "found GITHUB_SHA: $GITHUB_SHA"

# for dynamic build matrix in GitHub actions, see:
# https://github.community/t/check-pushed-file-changes-with-git-diff-tree-in-github-actions/17220/10

WORKDIR=$(pwd)
TMPFILE=$(mktemp)

cat >$TMPFILE <<EOF
{
  "include": [
EOF

PACKAGES=$(find . -name 'package.json')
for i in $PACKAGES; do
  DIR=$(dirname $i | sed 's|^./||')
  NAME=$(grep '"name":' $DIR/package.json | cut -d\" -f4)
  OLD_VERSION=$(grep '"version":' $DIR/package.json | cut -d\" -f4)
  DIFF=$( git diff --name-only $GITHUB_EVENT_BEFORE $GITHUB_SHA "./$DIR")
  if [[ -n "$DIFF" ]];  then
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
