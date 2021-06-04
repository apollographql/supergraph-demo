const { ApolloServer } = require('apollo-server');
const { ApolloGateway } = require('@apollo/gateway');
const { readFileSync } = require('fs');

const args = process.argv.slice(2);
const mode = args[0]
const port = args[1] ? args[1] : 4000

console.log(`Starting Apollo Gateway in ${mode} mode ...`);

const config = {};
if (mode === "local"){
  const supergraph= "./supergraph.graphql"
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
