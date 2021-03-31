#!/bin/bash

for f in ./*.graphql; do \
  filename="$(basename -- "$f")"; \
  name="${filename%.*}"; \
  rover subgraph publish supergraph-demo --routing-url https://${name}.acme.com --schema ${name}.graphql --name ${name}
done
