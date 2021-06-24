const { readFileSync } = require('fs');
const { resolve } = require('path');
const { ApolloServer, gql, ApolloError } = require('apollo-server');
const { buildFederatedSchema } = require('@apollo/federation');

const port = process.env.APOLLO_PORT || 4000;

const delivery = [
    { id: 'apollo-federation', estimatedDelivery: '6/25/2021', fastestDelivery: '6/24/2021' },
    { id: 'apollo-studio', estimatedDelivery: '6/25/2021', fastestDelivery: '6/24/2021' },
]

const typeDefs = gql(readFileSync('inventory.graphql', { encoding: 'utf-8' }));
const resolvers = {
    Product: {
        delivery: (product, args, context) => {
            return delivery.find(p => p.id == product.id);
        }
    }
}
const server = new ApolloServer({ schema: buildFederatedSchema({ typeDefs, resolvers }) });
server.listen( {port: port} ).then(({ url }) => {
  console.log(`🚀 Inventory subgraph ready at ${url}`);
}).catch(err => {console.error(err)});
