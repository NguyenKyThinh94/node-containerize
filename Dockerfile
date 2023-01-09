#1 Từ base image
FROM node:18.13.0-alpine3.16@sha256:3eb81689b639f6a7308c04003653daa94122bfcdbba9945e897b12cfe10bb034 as node

#2 Install devDependences
FROM node as server-dev
WORKDIR /app
COPY package.json package-lock.json /app/
COPY prisma /app/prisma
RUN npm ci

#2 Install prodDependences
FROM node as server-prod
WORKDIR /app
COPY package.json package-lock.json /app/
COPY prisma /app/prisma
RUN npm ci --production

#3 Build app
FROM node as server-builder
WORKDIR /app
COPY . .
COPY --from=server-dev /app/node_modules /app/node_modules
RUN npm run build

#4 Run app
FROM node as server
ENV NODE_ENV=production
WORKDIR /app
COPY --from=server-prod /app/node_modules /app/node_modules
COPY --from=server-builder /app/.env /app/
COPY --from=server-builder /app/dist /app/dist
CMD [ "node", "dist/main.js" ]
