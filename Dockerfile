### Name the node stage "builder" ###
FROM node:16-alpine AS builder
# Set working directory
WORKDIR /usr/src/frontend

# install node modules
COPY ./source/package.json .
COPY ./source/package-lock.json .
RUN npm ci

# App files
COPY ./source/src ./src
COPY ./source/public ./public 
COPY ./source/jsconfig.json .

# build for development
COPY ./source/.env ./.env
RUN npm run build

# nginx is serving the frontend site
FROM nginx:1.21.3-alpine
COPY --from=builder /usr/src/frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

