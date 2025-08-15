FROM node:21 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
FROM nginx:alpine
WORKDIR /app
COPY --from=builder /app/dist /usr/share/nginx/html
COPY .env.docker .env.local
EXPOSE 5173
CMD [ "nginx", "-g", "daemon off;" ]

