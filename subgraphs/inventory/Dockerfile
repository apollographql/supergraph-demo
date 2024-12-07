from node:22-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

COPY inventory.js .
COPY inventory.graphql .

CMD [ "node", "inventory.js" ]
