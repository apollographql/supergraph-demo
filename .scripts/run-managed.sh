#!/bin/bash

echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then create a Graph API Key and enter it at the prompt below."
read -s -p "> " key
echo
if [[ -z "$key" ]]; then
    >&2 echo "Error: no key specified."
    exit 1
fi

echo "APOLLO_KEY=<REDACTED>"
echo "APOLLO_SCHEMA_CONFIG_DELIVERY_ENDPOINT=https://uplink.api.apollographql.com/"
echo "node index.js managed"

APOLLO_KEY=service:${key} \
APOLLO_SCHEMA_CONFIG_DELIVERY_ENDPOINT=https://uplink.api.apollographql.com/ \
node index.js managed