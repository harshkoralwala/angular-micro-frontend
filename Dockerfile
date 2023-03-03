FROM node:18.13.0-alpine AS shared
RUN mkdir -p /app/shared
WORKDIR /app/shared
COPY ./shared/package*.json /app/shared/
RUN npm ci
COPY ./shared /app/shared
RUN npm run build && rm -rf src

FROM node:18.13.0-alpine AS server
RUN mkdir -p /app/server
WORKDIR /app/server
COPY --from=shared /app/shared /app/shared
COPY ./server/package*.json /app/server/
RUN cd /app/shared && ls -alh
RUN npm ci
COPY ./server /app/server
RUN npm run build && rm -rf src

FROM node:18.13.0-alpine AS client
RUN mkdir -p /app/client
WORKDIR /app/client
COPY --from=shared /app/shared /app/shared
COPY ./client/package*.json /app/client/
RUN apk update
RUN apk add git
RUN npm ci
COPY ./client /app/client
RUN npm run build && rm -rf src node_modules

FROM node:18.13.0-alpine
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
RUN apk add --no-cache git maven curl ca-certificates
WORKDIR /app
COPY --from=client /app/client ./client
COPY --from=server /app/server ./server
COPY --from=shared /app/shared ./shared
RUN update-ca-certificates
WORKDIR /app/server
CMD npm run start:prod
