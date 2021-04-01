# Supergraph Demo

## Local Supergraph Composition
```sh
make default
```

Which will do the the following:
```sh
# pull subgraph schemas with federation enrichments
make introspect

# build a supergraph config file
make config

# locally compose a supergraph
make compose
```

## Managed Federation

```sh
# pull subgraph schemas with federation enrichments
make introspect

# publish subgraph schemas to a federated graph in the registry
make publish
```

