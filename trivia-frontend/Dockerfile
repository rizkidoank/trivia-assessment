FROM node:14.5.0-alpine3.12
WORKDIR /app
COPY . .
RUN yarn install
EXPOSE 3000
ENTRYPOINT ["node","index.js"]
