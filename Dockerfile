### build stage
##FROM node:alpine
##WORKDIR /app
##COPY . .
##RUN npm install
##RUN npm run build
##
### production stage
##FROM nginx:stable-alpine as production-stage
##COPY --from=build-stage /app/dist /usr/share/nginx/html
##EXPOSE 80
##CMD ["nginx", "-g", "daemon off;"]
#FROM node:alpine
#WORKDIR /vue-app
#COPY . .
#RUN npm install
#RUN npm install -g live-server
#RUN npm run build
#EXPOSE 8080
#CMD ["live-server", "dist"]
##
# Multi-stage
# 1) Node image for building frontend assets
# 2) nginx stage to serve frontend assets

## Name the node stage "builder"
#FROM node:18 AS builder
## Set working directory
#WORKDIR /app
## Copy all files from current directory to working dir in image
#COPY . .
## install node modules and build assets
#RUN npm install && npm run build
#
## nginx state for serving content
#FROM nginx:alpine
## Set working directory to nginx asset directory
#WORKDIR /usr/share/nginx/html
## Remove default nginx static assets
#RUN rm -rf ./*
## Copy static assets from builder stage
#COPY --from=builder /app/dist .
## Containers run nginx with global directives and daemon off
#ENTRYPOINT ["nginx", "-g", "daemon off;"]

# build stage
FROM node:lts-alpine as build-stage
WORKDIR .
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
