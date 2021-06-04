# Supergraph Demo

![smoke test](https://github.com/apollographql/supergraph-demo/actions/workflows/main.yaml/badge.svg)
![dependencies](https://badgen.net/github/dependabot/apollographql/supergraph-demo)

Moving from dynamic composition to static composition with supergraphs.

## Welcome

Apollo Federation and Managed Federation have delivered significant
improvements over schema stitching and alternate approaches. Static
composition introduces another big step forward as we move composition out of
the Gateway and into the CI pipeline where federated graph changes can be
validated sooner and built into static artifacts that define how a Gateway
should route requests across the subgraphs in a federation.

Most contemporary federated GraphQL implementations dynamically compose a
list of implementing services (subgraphs) into a GraphQL Gateway at runtime.
There is no static artifact that can be versioned, validated, or reasoned
about across a fleet of Gateway instances that are common in scale-out
federated graph deployments. Gateways often rely on hard-coded behavior for
directives like `join` or accept additional non-GraphQL configuration.

With static composition, you can compose subgraphs into a supergraph at
build-time resulting in a static artifact (supergraph schema) that describes
the machinery to power a graph router at runtime. The supergraph schema
includes directives like `join` that instruct a graph router how federate
multiple subgraphs into a single graph for consumers to use.

![Apollo Federation with Supergraphs](docs/media/supergraph.png)

See also: [New Federation UX - Docs](https://www.apollographql.com/docs/federation/quickstart/)

## Prerequisites

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

You'll also need `rover` [our new CLI](https://www.apollographql.com/docs/rover/getting-started) for managing and maintaining data graphs.

```sh
curl -sSL https://rover.apollo.dev/nix/latest | sh
```

## Local Supergraph Composition

You can federate multiple subgraphs into a supergraph using:

```sh
make local
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

which shows:

```
node index.js local
Starting Apollo Gateway in local mode ...
Using local: ./supergraph.graphql
🚀 Server ready at http://localhost:4000/
```

Then issue a GraphQL Query in a separate terminal session:

```sh
make query
```

which issues the following query:

```ts
{
  query: {
    bestSellers: { title }
  }
}
```

and returns this result:

```ts
{
  data: {
    bestSellers:[
      { title: "adidas Yeezy 700 V3 Kyanite" },
      { title: "Jordan 5 Retro Change The World" }
    ]
  }
}
```

## Managed Federation

Managed Federation enables teams to independently publish subgraphs to the Apollo Registry, so they can be automatically composed into a supergraph for apps to use.

To get started with Managed Federation, create your Apollo account:

* Signup for a free Team trial: https://studio.apollographql.com/signup
* Create an organization
* **Important:** use the `Team` trial which gives you access Apollo features like `Schema Checks`.

Create a `Graph` of type `Deployed` with the `Federation` option.

Configure `rover` to connect to your account:

```sh
rover config auth
```

If you don't already have the subgraph schemas:

```sh
# pull subgraph schemas with federation enrichments
make introspect
```

Then publish your subgraphs to your new `Federated` graph in the Apollo Registry:

```sh
# publish subgraph schemas to a federated graph in the registry, for composition into a managed supergraph
make publish
```

Interim composition errors may surface as each subgraph is published:

```
rover subgraph publish supergraph-demo --routing-url https://nem23xx1vd.execute-api.us-east-1.amazonaws.com/Prod/graphql --schema subgraphs/orders.graphql --name orders

Publishing SDL to supergraph-demo:current (subgraph: orders) using credentials from the default profile.
error: We are unable to run composition for your graph because a subgraph contains an extend declaration for the type 'Product' which does not exist in any subgraph.
```

However once all subgraphs are published the supergraph will be updated, for example: 

```
rover subgraph publish supergraph-demo --routing-url https://1kmwbtxfr4.execute-api.us-east-1.amazonaws.com/Prod/graphql --schema subgraphs/locations.graphql --name locations

Publishing SDL to supergraph-demo:current (subgraph: locations) using credentials from the default profile.
A new subgraph called 'locations' for the 'supergraph-demo' graph was created

The gateway for the 'supergraph-demo' graph was updated with a new schema, composed from the updated 'locations' subgraph
```

Viewing the `Federated` graph in Apollo Studio we can see the supergraph and the subgraphs it's composed from:
![Federated Graph in Apollo Studio](docs/media/studio.png)

Now we can run an Apollo Gateway using Managed Federation:

```sh
# install apollo-server and @apollo/gateway
make install

# run the Apollo Gateway with to pull a managed supergraph from an Uplink to the Apollo Registry
make run-managed
```

which shows:

```
Go to your graph settings in https://studio.apollographql.com/
then create a Graph API Key and enter it at the prompt below.
> 
APOLLO_KEY=<REDACTED>
APOLLO_SCHEMA_CONFIG_DELIVERY_ENDPOINT=https://uplink.api.apollographql.com/
node index.js managed
Starting Apollo Gateway in managed mode ...
No graph variant provided. Defaulting to `current`.
Apollo usage reporting starting! See your graph at https://studio.apollographql.com/graph/supergraph-demo/?variant=current
🚀 Server ready at http://localhost:4000/
```

Make a query in a separate terminal session:

```sh
make query
```

## Ship Faster Without Breaking Changes

Apollo Schema Checks help ensure subgraph changes don't break the federated graph, reducing downtime and enabling teams to ship faster.

To simulate a breaking change, add a `Color` `enum` to `.subgraphs/products.graphql`:

```ts
enum Color {
  BLUE
  GREEN
}
```

Then `publish` the changes to the registry:

```sh
make publish
```

Then remove the `Color` `enum` from `.subgraphs/products.graphql`:

```ts
enum Color {
  BLUE
  GREEN
}
```

and do a schema `check` against the published version in the registry:

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

Then `publish` the changes and `check` again:

```sh
make publish

make check-products
```

which shows:

```
Checked the proposed subgraph against supergraph-demo@current
There were no changes detected in the composed schema.
```

## Learn More

Apollo tools and services help you develop, maintain, operate, and scale your data graph.

Learn more about schema checks and how Apollo can help your teams ship faster here: https://www.apollographql.com/docs/studio/.
