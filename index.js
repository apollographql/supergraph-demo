const { ApolloServer } = require('apollo-server');
const { ApolloGateway } = require('@apollo/gateway');
const { readFileSync } = require('fs');

// Pass the ApolloGateway to the ApolloServer constructor
console.log("start the server... {process.env.THISIP}");

const gateway = new ApolloGateway(
  {supergraphSdl: readFileSync("./supergraph.graphql").toString(),}
);

const server = new ApolloServer({
  gateway,
  debug: true,
  // Subscriptions are unsupported but planned for a future Gateway version.
  subscriptions: false
});

server.listen().then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
}).catch(err => {console.error(err)});