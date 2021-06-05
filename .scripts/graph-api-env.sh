#!/bin/bash

echo -------------------------------------------------------------------------------------------
echo Enter your Graph API Key
echo -------------------------------------------------------------------------------------------
echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then create a Graph API Key with Contributor permissions"
echo "(for metrics reporting) and enter it at the prompt below."
read -s -p "> " key
echo
if [[ -z "$key" ]]; then
    >&2 echo "Error: no key specified."
    exit 1
fi

echo "APOLLO_KEY=${key}" > graph-api.env
