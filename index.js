const { ApolloServer } = require('apollo-server');
const { ApolloGateway } = require('@apollo/gateway');
const { readFileSync } = require('fs');

const { GATEWAY_PORT } = process.env;

const args = process.argv.slice(2);
const supergraph = args[0];
const mode = supergraph ? "local" : "managed";
const port = GATEWAY_PORT ? GATEWAY_PORT : 4000;

console.log(`Starting Apollo Gateway in ${mode} mode ...`);

const config = {};
if (mode === "local"){
  console.log(`Using local: ${supergraph}`)
  config['supergraphSdl'] = readFileSync(supergraph).toString();
}

const gateway = new ApolloGateway(config);

const server = new ApolloServer({
  gateway,
  debug: true,
  // Subscriptions are unsupported but planned for a future Gateway version.
  subscriptions: false
});

server.listen( {port: port} ).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
}).catch(err => {console.error(err)});
