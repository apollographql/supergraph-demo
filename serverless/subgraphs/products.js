const { ApolloServer, gql } = require("apollo-server-lambda");
const { buildSubgraphSchema } = require('@apollo/subgraph');
const { readFileSync } = require('fs');
const { resolve } = require('path');

const products = [
    { id: 'apollo-federation', sku: 'federation', package: '@apollo/federation', variation: "OSS" },
    { id: 'apollo-studio', sku: 'studio', package: '', variation: "platform" },
]
const ql = readFileSync(resolve(__dirname, './products.graphql'), { encoding: 'utf-8' });
const typeDefs = gql(ql) ;
const resolvers = {
    Query: {
        allProducts: (_, args, context) => {
            return products;
        },
        product: (_, args, context) => {
            return products.find(p => p.id == args.id);
        }
    },
    Product: {
        variation: (reference) => {
            if (reference.variation) return { id: reference.variation };
            return { id: products.find(p => p.id == reference.id).variation }
        },
        dimensions: () => {
            return { size: "1", weight: 1 }
        },
        createdBy: (reference) => {
            return { email: 'support@apollographql.com', totalProductsCreated: 1337 }
        },
        __resolveReference: (reference) => {
            if (reference.id) return products.find(p => p.id == reference.id);
            else if (reference.sku && reference.package) return products.find(p => p.sku == reference.sku && p.package == reference.package);
            else return { id: 'rover', package: '@apollo/rover', ...reference };
        }
    }
}

const server = new ApolloServer({ schema: buildSubgraphSchema({ typeDefs, resolvers }) });
exports.handler = server.createHandler();
