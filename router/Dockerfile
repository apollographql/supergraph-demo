from node:14-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

COPY router.js .
COPY supergraph.graphql .

CMD [ "node", "router.js" ]
