FROM node:21 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run test

FROM node:21-slim
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .
COPY .env.docker .env.local
EXPOSE 5000
CMD [ "node", "server.js" ]