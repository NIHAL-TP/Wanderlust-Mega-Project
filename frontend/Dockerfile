FROM node:21 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build


FROM node:21-slim
WORKDIR /app
COPY --from=builder /app .
COPY .env.docker .env.local
EXPOSE 5173
CMD [ "npm", "run", "dev", "--", "--host" ]

