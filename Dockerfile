FROM node:20 as build

RUN apt-get update && apt install tree
RUN npm install -g typescript

WORKDIR /app

COPY web-client web-client
COPY web-server web-server

WORKDIR /app/web-client 
RUN rm package-lock.json
RUN npm install
RUN npm run build

WORKDIR /app/web-server
RUN npm install
RUN tsc



FROM node:20-slim as runner

ENV PORT=

COPY --from=build /app/client /app/client
COPY --from=build /app/output/src /app
COPY --from=build /app/web-server/package.json /app/package.json

WORKDIR /app
RUN mv index.js app.js
RUN npm install 

ENTRYPOINT [ "node", "app.js" ]

