//test release pipeline
const { readFileSync } = require('fs');
const { resolve } = require('path');
const { ApolloServer, gql, ApolloError } = require('apollo-server');
const { buildFederatedSchema } = require('@apollo/federation');

const port = process.env.APOLLO_PORT || 4000;

class DeliveryEstimates {
    constructor() {
        this.estimatedDelivery = "5/1/2019";
        this.fastestDelivery = "5/1/2019";
    }
}

const typeDefs = gql(readFileSync('inventory.graphql', { encoding: 'utf-8' }));
const resolvers = {
    Product: {
        delivery: (product, args, context) => {
            //Validate Product has external information as per @requires
            if (product.id != 'federation') throw new ApolloError("product.id was not 'federation'");
            if (product.dimensions.size != '1') throw new ApolloError("product.dimensions.size was not '1'");
            if (product.dimensions.weight != 1) throw new ApolloError("product.dimensions.weight was not '1'");
            if (args.zip != '94111') throw new ApolloError("Prodct.delivery input zip was not '94111'");

            return new DeliveryEstimates();
        }
    }
}
const server = new ApolloServer({ schema: buildFederatedSchema({ typeDefs, resolvers }) });
server.listen( {port: port} ).then(({ url }) => {
  console.log(`🚀 Inventory subgraph ready at ${url}`);
}).catch(err => {console.error(err)});
