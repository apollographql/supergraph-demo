const { ApolloServer } = require("apollo-server-lambda");
const { ApolloGateway } = require("@apollo/gateway");
const { readFileSync } = require("fs");
const { resolve } = require("path");

const supergraphPath = resolve(__dirname, "../supergraph.graphql");

const supergraphSdl = readFileSync(supergraphPath).toString();

const gateway = new ApolloGateway({
  supergraphSdl,
});

const server = new ApolloServer({
  gateway,
});

exports.routerHandler = server.createHandler();
