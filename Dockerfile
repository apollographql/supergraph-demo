from node:14

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install

COPY index.js .
COPY supergraph.graphql .

CMD [ "node", "index.js", "local"]
