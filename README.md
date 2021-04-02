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

# install apollo-server and @apollo/gateway
make install

# run the Apollo Gateway with local supergraph
make run
```

Make a query in a separate terminal session:

```sh
make query
```

## Managed Federation

[Signup for a free Team trial](https://studio.apollographql.com/signup).

* Create an organization
* **Important:** use the `Team` trial which gives you access Apollo features like `Schema Checks`.

Create a `Graph` of type `Deployed` with the `Federation` option.

Configure `rover` to use connect to your account:

```sh
rover config auth
```

If you don't already have the subgraph schemas:

```sh
# pull subgraph schemas with federation enrichments
make introspect
```

```sh
# publish subgraph schemas to a federated graph in the registry
make publish

# run the Apollo Gateway with Managed Federation
make run-managed
```

Make a query in a separate terminal session:

```sh
make query
```
