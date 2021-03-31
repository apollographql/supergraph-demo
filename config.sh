#!/bin/bash

echo "subgraphs:"
for f in ./*.graphql; do \
  filename="$(basename -- "$f")"; \
  filename="${filename%.*}"; \
  echo "  ${filename}:"
  echo "    routing_url: https://${filename}.acme.com"
  echo "    schema:"
  echo "      file: ./${filename}.graphql"
done
