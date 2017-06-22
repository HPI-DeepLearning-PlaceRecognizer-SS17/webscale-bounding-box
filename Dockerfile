FROM node:6
MAINTAINER arthur@arthursilber.de

COPY ./* /app/
WORKDIR /app

RUN npm install
RUN ./node_modules/.bin/grunt compileClient

ENTRYPOINT ["npm", "run", "startServer"]