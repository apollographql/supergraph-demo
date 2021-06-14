const { ApolloServer } = require('apollo-server');
const { ApolloGateway } = require('@apollo/gateway');
const { readFileSync } = require('fs');

const { GATEWAY_PORT,
        GATEWAY_ENV,
        GATEWAY_SUPERGRAPH_SDL} = process.env;

const args = process.argv.slice(2);
const supergraph = GATEWAY_SUPERGRAPH_SDL;
const mode = supergraph ? "local" : "managed";
const port = GATEWAY_PORT ? GATEWAY_PORT : 4000;
const env_display = GATEWAY_ENV ? `(env:${GATEWAY_ENV}) ` : '';

console.log(`Starting Apollo Gateway in ${mode} mode ${env_display}...`);

const config = {};
if (mode === "local"){
  console.log(`Using local: ${supergraph}`)
  let supergraphSdl = readFileSync(supergraph).toString();
  if(GATEWAY_ENV){
    const regex = /%GATEWAY_ENV%/ig;
    supergraphSdl = supergraphSdl.replace(regex, GATEWAY_ENV);
  }
  config['supergraphSdl'] = supergraphSdl
}

const gateway = new ApolloGateway(config);

const server = new ApolloServer({
  gateway,
  debug: true,
  // Subscriptions are unsupported but planned for a future Gateway version.
  subscriptions: false
});

server.listen( {port: port} ).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
}).catch(err => {console.error(err)});
