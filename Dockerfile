FROM node:6
MAINTAINER arthur@arthursilber.de

COPY . /app/
WORKDIR /app

RUN npm install
RUN npm install -g grunt-cli
RUN grunt compileClient

ENTRYPOINT ["npm", "run", "startServer"]