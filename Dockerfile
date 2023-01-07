#1 Từ base image
FROM node:18.13.0-alpine3.16@sha256:3eb81689b639f6a7308c04003653daa94122bfcdbba9945e897b12cfe10bb034 as node
FROM node as server-builder
WORKDIR /app

#2 Coppy toàn bộ source
COPY . .

#3 install dependence
RUN npm ci

#4 build code
RUN npm run build

#4 remove dev dependence
RUN npm prune --production

#5 Mutil stage mới
FROM node as server

ENV NODE_ENV=production

WORKDIR /app

COPY --from=server-builder /app/node_modules /app/node_modules
COPY --from=server-builder /app/.env /app/
COPY --from=server-builder /app/dist /app/dist
#6 run app
CMD [ "node", "dist/main.js" ]
