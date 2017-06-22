FROM node:6
MAINTAINER arthur@arthursilber.de

COPY ./* /app/
WORKDIR /app

RUN npm install
RUN npm run compileClient

ENTRYPOINT ["npm", "run", "startServer"]