from node:17-alpine

WORKDIR /usr/src/app

RUN npm install -g serverless

COPY package.json .

RUN npm install

COPY . ./

CMD [ "serverless", "offline" ]
