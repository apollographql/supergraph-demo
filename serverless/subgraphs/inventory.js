const { ApolloServer, gql } = require("apollo-server-lambda");
const { buildSubgraphSchema } = require('@apollo/subgraph');
const { readFileSync } = require('fs');
const { resolve } = require('path');

const delivery = [
    { id: 'apollo-federation', estimatedDelivery: '6/25/2021', fastestDelivery: '6/24/2021' },
    { id: 'apollo-studio', estimatedDelivery: '6/25/2021', fastestDelivery: '6/24/2021' },
]

const typeDefs = gql(readFileSync(resolve(__dirname, './inventory.graphql'), { encoding: 'utf-8' }));
const resolvers = {
    Product: {
        delivery: (product, args, context) => {
            return delivery.find(p => p.id == product.id);
        }
    }
}
const server = new ApolloServer({ schema: buildSubgraphSchema({ typeDefs, resolvers }) });
exports.handler = server.createHandler();
