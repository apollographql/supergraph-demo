from node:19-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

COPY gateway.js .

CMD [ "node", "gateway.js" ]
