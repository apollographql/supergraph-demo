const { ApolloServer, gql } = require("apollo-server-lambda");
const { readFileSync } = require('fs');
const { resolve } = require('path');

const pandas = [
    { name: 'Basi', favoriteFood: "bamboo leaves" },
    { name: 'Yun', favoriteFood: "apple" }
]

const typeDefs = gql(readFileSync(resolve(__dirname, './pandas.graphql'), { encoding: 'utf-8' }));
const resolvers = {
    Query: {
        allPandas: (_, args, context) => {
            return pandas;
        },
        panda: (_, args, context) => {
            return pandas.find(p => p.id == args.id);
        }
    },
}
const server = new ApolloServer({ typeDefs, resolvers });
exports.handler = server.createHandler();
