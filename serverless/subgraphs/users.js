const { ApolloServer, gql } = require("apollo-server-lambda");
const { buildSubgraphSchema } = require('@apollo/subgraph');
const { readFileSync } = require('fs');
const { resolve } = require('path');

const users = [
    { email: 'support@apollographql.com', name: "Apollo Studio Support", totalProductsCreated: 4 }
]

const typeDefs = gql(readFileSync(resolve(__dirname, './users.graphql'), { encoding: 'utf-8' }));
const resolvers = {
    User: {
        __resolveReference: (reference) => {
            return users.find(u => u.email == reference.email);
        }
    }
}

const server = new ApolloServer({ schema: buildSubgraphSchema({ typeDefs, resolvers }) });
exports.handler = server.createHandler();
