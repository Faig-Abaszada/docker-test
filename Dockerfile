# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY . .
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
#FROM node
#WORKDIR /vue-app
#COPY . .
#RUN npm install
#RUN npm install -g live-server
#RUN npm run build
#EXPOSE 8080
#CMD ["live-server", "dist"]
