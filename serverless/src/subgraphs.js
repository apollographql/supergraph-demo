const { ApolloServer } = require("apollo-server-lambda");
const { buildFederatedSchema } = require("@apollo/federation");

const {
  typeDefs: inventoryTypeDefs,
  resolvers: inventoryResolvers,
} = require("../../subgraphs/inventory/inventory");

const {
  typeDefs: productsTypeDefs,
  resolvers: productsResolvers,
} = require("../../subgraphs/products/products");

const {
  typeDefs: usersTypeDefs,
  resolvers: usersResolvers,
} = require("../../subgraphs/users/users");

const createSubgraphHandler = ({ typeDefs, resolvers }) => {
  const schema = buildFederatedSchema({
    typeDefs,
    resolvers,
  });
  const server = new ApolloServer({
    schema,
  });
  return server.createHandler();
};

exports.inventoryHandler = createSubgraphHandler({
  typeDefs: inventoryTypeDefs,
  resolvers: inventoryResolvers,
});

exports.productsHandler = createSubgraphHandler({
  typeDefs: productsTypeDefs,
  resolvers: productsResolvers,
});

exports.usersHandler = createSubgraphHandler({
  typeDefs: usersTypeDefs,
  resolvers: usersResolvers,
});
