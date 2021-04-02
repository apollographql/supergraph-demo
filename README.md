# Supergraph Demo

You'll need to [download and
install](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
`node` and `npm`, using a node version manager like
[nvm](https://github.com/nvm-sh/nvm#about):

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
```

Then install `node` 14:
```sh
nvm install 14.16.0
```

## Local Supergraph Composition

You can federate multiple subgraphs into a supergraph using:

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

Then issue a GraphQL Query in a separate terminal session:

```sh
make query
```

which issues the following query:
```js
{ "query": "{ bestSellers { title } } " }
```

and returns this result:
```js
{"data":{"bestSellers":[{"title":"Hello World"},{"title":"Hello World"}]}}
```

## Managed Federation

Apollo tools and services help you develop, maintain, operate, and scale your data graph.

Managed Federation enables teams to independently publish subgraphs to the Apollo Registry, so they can be automatically composed into a supergraph for apps to use.

To get started with Managed Federation, create your Apollo account:

* Signup for a free Team trial: https://studio.apollographql.com/signup
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
# publish subgraph schemas to a federated graph in the registry, for composition into a managed supergraph
make publish

# run the Apollo Gateway with a managed supergraph pulled from an Uplink to the Apollo Registry
make run-managed
```

Make a query in a separate terminal session:

```sh
make query
```

## Help teams ship faster without breaking changes

Apollo Schema Checks help ensure subgraph changes don't break the federated graph, reducing downtime and enabling teams to ship faster.

To simulate a breaking change, add an `enum` to `.subgraphs/products.graphql`:
```ts
enum Color {
  BLUE
  GREEN
}
```

then publish it, so it's in the registry as the current schema:

```sh
make publish
```

Then to simulate a potentially breaking change, remove the `enum` from `.subgraphs/products.graphql`.

but do a schema `check` before you `publish` it:

```sh
make check-products
```

This detects the schema changes, but compares them against the known graph `operations` and determines there is no impact and the changes can be published:

```sh
Checked the proposed subgraph against supergraph-demo@current
Compared 3 schema changes against 2 operations
┌────────┬─────────────────────────┬──────────────────────────────────────────┐
│ Change │          Code           │               Description                │
├────────┼─────────────────────────┼──────────────────────────────────────────┤
│ PASS   │ TYPE_REMOVED            │ type `Color`: removed                    │
├────────┼─────────────────────────┼──────────────────────────────────────────┤
│ PASS   │ VALUE_REMOVED_FROM_ENUM │ enum type `Color`: value `BLUE` removed  │
├────────┼─────────────────────────┼──────────────────────────────────────────┤
│ PASS   │ VALUE_REMOVED_FROM_ENUM │ enum type `Color`: value `GREEN` removed │
└────────┴─────────────────────────┴──────────────────────────────────────────┘
```

If you publish the changes, and rerun the check:

```sh
make publish

make check-products
```

you'll get the following:

```sh
Checked the proposed subgraph against supergraph-demo@current
There were no changes detected in the composed schema.
```

Learn more about schema checks and how Apollo can help your teams ship faster here:

https://www.apollographql.com/docs/studio/