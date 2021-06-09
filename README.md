# Supergraph Demo

![smoke test](https://github.com/apollographql/supergraph-demo/actions/workflows/main.yml/badge.svg)
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

You'll need:

* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)
* `rover` [our new CLI](https://www.apollographql.com/docs/rover/getting-started) for managing and maintaining data graphs.

To install `rover`:

```sh
curl -sSL https://rover.apollo.dev/nix/latest | sh
```

## Local Supergraph Composition

You can federate multiple subgraphs into a supergraph using:

```sh
make demo
```

Which will do the the following:

```sh
# pull subgraph schemas with federation enrichments
make introspect
```

which gets the subgraph schemas from all subgraph servers:

```
rover subgraph introspect https://nem23xx1vd.execute-api.us-east-1.amazonaws.com/Prod/graphql > subgraphs/orders.graphql
rover subgraph introspect https://7bssbnldib.execute-api.us-east-1.amazonaws.com/Prod/graphql > subgraphs/products.graphql
rover subgraph introspect https://w0jtezo2pa.execute-api.us-east-1.amazonaws.com/Prod/graphql > subgraphs/reviews.graphql
rover subgraph introspect https://eg3jdhe3zl.execute-api.us-east-1.amazonaws.com/Prod/graphql > subgraphs/customers.graphql
rover subgraph introspect https://2lc1ekf3dd.execute-api.us-east-1.amazonaws.com/Prod/graphql > subgraphs/inventory.graphql
rover subgraph introspect https://1kmwbtxfr4.execute-api.us-east-1.amazonaws.com/Prod/graphql > subgraphs/locations.graphql
```

```sh
# build a supergraph config file
make config
```

which creates a supergraph.yaml config:

```
.scripts/config.sh > supergraph.yaml
```

```sh
# locally compose a supergraph
make compose
```

which composes a supergraph schema:

```
rover supergraph compose --config ./supergraph.yaml > supergraph.graphql
```

and the graph-router container is started:

```
make docker-up
```

which shows:

```
docker-compose up -d
Creating network "supergraph-demo_default" with the default driver
Creating graph-router ... done

Starting Apollo Gateway in local mode ...
Using local: supergraph.graphql
🚀 Server ready at http://localhost:4000/
```

`make demo` then issues a curl request to the graph router

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

and finally `make demo` shuts down graph-router, with:

```sh
make docker-down
```

## Managed Federation

Managed Federation enables teams to independently publish subgraphs to the Apollo Registry, so they can be automatically composed into a supergraph for apps to use.

To get started with Managed Federation, create your Apollo account:

* Signup for a free Team trial: https://studio.apollographql.com/signup
* Create an organization
* **Important:** use the `Team` trial which gives you access Apollo features like `Schema Checks`.

Create a `Graph` of type `Deployed` with the `Federation` option.

Create the `graph-api.env` file with `APOLLO_KEY` using:

```sh
make graph-api-env
```

for use in `docker-compose.managed.yml`:
```yaml
version: '3'
 services:
   web:
     container_name: graph-router
     build: .
     entrypoint: ["node", "index.js", "managed"]
     environment:
       - APOLLO_SCHEMA_CONFIG_DELIVERY_ENDPOINT=https://uplink.api.apollographql.com/
     env_file: # create with make graph-api-env
       - graph-api.env
     ports:
       - "4000:4000"
```

`graph-api.env`:
```
APOLLO_KEY=<redacted>
```

Then run the Managed Federation demo:

```sh
make demo-managed
```

Which does the following:

```sh
# pull subgraph schemas with federation enrichments
make introspect
```

Publish your subgraphs to your new `Federated` graph in the Apollo Registry:

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

and finally the graph-router container is started:

```sh
make docker-up-managed
```

which shows:

```
docker-compose -f docker-compose.managed.yml up -d
Creating network "supergraph-demo_default" with the default driver
Creating graph-router ... done

Starting Apollo Gateway in managed mode ...
Apollo usage reporting starting! See your graph at https://studio.apollographql.com/graph/supergraph-preview@current/
🚀 Server ready at http://localhost:4000/
```

`make demo-managed` then issues a curl request to the graph router:

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

and finally `make demo-managed` shuts down the graph router, with:

```sh
make docker-down
```

With Managed Federation you can leave graph-router running and it will
update automatically when subgraph changes are published and they successfully
compose and pass all schema checks in Apollo Studio:

```sh
make docker-up-managed
```

```
Starting Apollo Gateway in managed mode ...
Apollo usage reporting starting! See your graph at https://studio.apollographql.com/graph/supergraph-preview@current/
🚀 Server ready at http://localhost:4000/
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

## Deploying a Graph Router to Kubernetes

You'll need:
* [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

This uses a container image built from the [Dockerfile](Dockerfile):

```dockerfile
from node:14

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

COPY index.js .
COPY supergraph.graphql .

CMD [ "node", "index.js", "supergraph.graphql"]
```

Create a local k8s cluster with the Ambassador Ingress Controller and create a
graph-router `Deployment` with 3 replicas, a `Service`, and an `Ingress`:

```sh
make k8s-up
```

which uses the following config from [k8s/router.yaml](k8s/router.yaml):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: graph-router
  labels:
    app: graphql
spec:
  replicas: 3
  selector:
    matchLabels:
      app: graphql
  template:
    metadata:
      labels:
        app: graphql
    spec:
      containers:
      - name: gateway
        image: prasek/supergraph-demo:latest
        env:
        - name: GATEWAY_PORT
          value: "3999"
        ports:
        - containerPort: 3999
---
apiVersion: v1
kind: Service
metadata:
  name: graphql-service
spec:
  selector:
    app: graphql
  ports:
    - protocol: TCP
      port: 4001
      targetPort: 3999
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: graphql-ingress
  annotations:
    kubernetes.io/ingress.class: ambassador
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: graphql-service
            port:
              number: 4001
```

To see everything running run `kubectl get all`:

```
NAME                              READY   STATUS    RESTARTS   AGE
pod/graph-router-c7577547-9vkl4   1/1     Running   0          2m
pod/graph-router-c7577547-hpzrb   1/1     Running   0          2m
pod/graph-router-c7577547-nbfcp   1/1     Running   0          2m

NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/graphql-service   ClusterIP   10.96.115.47   <none>        4001/TCP   2m
service/kubernetes        ClusterIP   10.96.0.1      <none>        443/TCP    8m

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/graph-router   3/3     3            3           2m

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/graph-router-c7577547   3         3         3       2m
```

Issue a query against the graph router:

```sh
make k8s-query
```

If the services are still starting you may get one of the following:
* `upstream request timeout`
* `upstream connect error or disconnect/reset before headers. reset reason: connection failure`

but after the services have started you'll see:

```
.scripts/query.sh 80
-------------------------------------------------------------------------------------------
curl -X POST -H "Content-Type: application/json" --data '{ "query": "{ bestSellers { title } } " }' http://localhost:80/
{"data":{"bestSellers":[{"title":"Hello World"},{"title":"Hello World"}]}}
-------------------------------------------------------------------------------------------
```

Tear down the cluster:

```sh
make k8s-down
```

## Learn More

Apollo tools and services help you develop, maintain, operate, and scale your data graph.

Learn more about schema checks and how Apollo can help your teams ship faster here: https://www.apollographql.com/docs/studio/.
