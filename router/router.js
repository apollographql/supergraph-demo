const { ApolloServer } = require('apollo-server');
const { ApolloGateway } = require('@apollo/gateway');
const { readFileSync } = require('fs');

const port = process.env.APOLLO_PORT || 4000;
const embeddedSchema = process.env.APOLLO_SCHEMA_CONFIG_EMBEDDED == "true" ? true : false;

const config = {};

if (embeddedSchema){
  const supergraph = "supergraph.graphql"
  config['supergraphSdl'] = readFileSync(supergraph).toString();
  console.log('Starting Apollo Gateway in local mode ...');
  console.log(`Using local: ${supergraph}`)
} else {
  console.log('Starting Apollo Gateway in managed mode ...');
}

const gateway = new ApolloGateway(config);

const server = new ApolloServer({
  gateway,
  debug: true,
  // Subscriptions are unsupported but planned for a future Gateway version.
  subscriptions: false
});

server.listen( {port: port} ).then(({ url }) => {
  console.log(`🚀 Graph Router ready at ${url}`);
}).catch(err => {console.error(err)});
