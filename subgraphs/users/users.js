const { readFileSync } = require('fs');
const { resolve } = require('path');
const { ApolloServer, gql } = require('apollo-server');
const { buildFederatedSchema } = require('@apollo/federation');

const port = process.env.APOLLO_PORT || 4000;

const users = [
    { email: 'support@apollographql.com', name: "Apollo Studio Support", totalProductsCreated: 4 }
]

const typeDefs = gql(readFileSync('./users.graphql', { encoding: 'utf-8' }));
const resolvers = {
    User: {
        __resolveReference: (reference) => {
            return users.find(u => u.email == reference.email);
        }
    }
}
const server = new ApolloServer({ schema: buildFederatedSchema({ typeDefs, resolvers }) });
server.listen( {port: port} ).then(({ url }) => {
  console.log(`🚀 Users subgraph ready at ${url}`);
}).catch(err => {console.error(err)});
