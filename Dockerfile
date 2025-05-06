FROM node:20.10.0

ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PASS=rajeev

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 5050

CMD ["node", "server.js"]