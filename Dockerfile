FROM node:10

WORKDIR /opt/http-server

COPY . .

RUN npm install

EXPOSE 80

CMD ["npm", "start"]
