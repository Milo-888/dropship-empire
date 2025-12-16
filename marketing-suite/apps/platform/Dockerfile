# --------------> The compiler image
FROM node:18 AS compile
WORKDIR /usr/src/app
COPY apps/platform/package*.json ./
COPY apps/platform/tsconfig*.json ./
COPY tsconfig.base.json ./
RUN npm ci
COPY apps/platform ./
RUN npm run build

# --------------> The build image
FROM node:18 AS build
WORKDIR /usr/src/app
COPY --from=compile /usr/src/app/package*.json ./
COPY --from=compile /usr/src/app/build ./build
COPY --from=compile /usr/src/app/db ./db
COPY --from=compile /usr/src/app/public ./public 
RUN npm ci --only=production

# --------------> The production image
FROM node:18-alpine
RUN apk add dumb-init
ENV NODE_ENV="production"
USER node
WORKDIR /usr/src/app
COPY --chown=node:node --from=build /usr/src/app ./
EXPOSE 3000
CMD ["dumb-init", "node", "build/boot.js"]
