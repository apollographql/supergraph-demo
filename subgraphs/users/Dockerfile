from node:22-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

COPY users.js .
COPY users.graphql .

CMD [ "node", "users.js" ]
