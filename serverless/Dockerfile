from node:14-alpine

WORKDIR /usr/src/app

RUN npm install -g serverless

COPY package.json .

RUN yarn install

COPY . ./

CMD [ "serverless", "offline" ]
